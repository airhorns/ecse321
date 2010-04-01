module Canable
  Version = '0.2'

  # Module that holds all the can_action? methods.
  module Cans; end

  # Module that holds all the [method]able_by? methods.
  module Ables; end
  
  # Module that is included by a role implementation
  module Role
    include Cans # each role has a distinct set of responses to all the can_action? methods
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    # These are applied to the actual Role module 'instance' that includes this (Canable::Role) module 
    module ClassMethods
      # Each role has a default query response, found in this variable
      attr_accessor :_default_response
      
      
      # Called when another Role imeplementation module tries to inherit an existing Role implementation
      # Notice this method isn't self.included, this method becomes self.included on the module including this (Canable::Role) module
      # This is nesscary to emulate inhertance of the default response and any other variables in the future
      def included(base)
        base._default_response = self._default_response
      end
      
      # Called when an Actor decides its role and extends itself (an instance) with a Role implementation
      # Creates the default instance methods for an Actor and persists the can_action? response default down
      def extended(base)
        base.extend(RoleEnabledCanInstanceMethods)
        this_role = self # can't use self inside the instance eval
        base.instance_eval { @_canable_role = this_role }
      end
      
      # Methods given to an instance of an Actor
      module RoleEnabledCanInstanceMethods
        def _canable_default # the role default response
          @_canable_role._default_response
        end
      end
      
      # ----------------------
      # Role building DSL
      # ----------------------
      def default_response(val)
        self._default_response = val
      end
    end
  end
  
  module Actor
    attr_accessor :canable_included_role

    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      attr_accessor :canable_default_role
      attr_accessor :canable_role_proc
      
      # ---------------
      # RBAC Actor building DSL
      # ---------------
      
      def default_role(role)
        self.canable_default_role = role
      end
      
      def role_attribute(role)
        self.canable_role_proc = Proc.new {
          self.instance_var_get(role)
        }
      end
    end
    
    def initialize(*args)
      super(*args)
      self.__initialize_canable_role
      self
    end
    
    def __initialize_canable_role
      role_constant = self.__get_role_constant
      if role_constant == nil
        default_role = self.class.canable_default_role
        self.act(default_role) unless default_role == nil
      else
        self.act(role_constant)
      end
    end
    
    def __get_role_constant 
      attribute = self.class.canable_role_attribute
      if attribute == nil && self.class.canable_role_proc.respond_to?(:call)
        attribute = self.class.canable_role_proc.call
      end
      attribute
    end
    
    # Sets the role of this actor by including a role module
    def act(role)
      if(role.respond_to?(:included))
        self.extend role
      else
        self.extend Canable::Roles.const_get((role.to_s.capitalize+"Role").intern)
      end
      self.canable_included_role = role
    end
  end
  
  # Holds all the different roles that an actor may assume
  module Roles
    # Make one default role that is false for everything
    module Role
      include Canable::Role
      default_response false
    end
  end

  # Module that holds all the enforce_[action]_permission methods for use in controllers.
  module Enforcers
    def self.included(controller)
      controller.class_eval do
        Canable.actions.each do |can, able|
          delegate      "can_#{can}?", :to => :current_user
          helper_method "can_#{can}?" if controller.respond_to?(:helper_method)
          hide_action   "can_#{can}?" if controller.respond_to?(:hide_action)
        end
      end
    end
  end

  # Exception that gets raised when permissions are broken for whatever reason.
  class Transgression < StandardError; end

  # Default actions to an empty hash.
  @actions = {}

  # Returns hash of actions that have been added.
  #   {:view => :viewable, ...}
  def self.actions
    @actions
  end

  # Adds an action to actions and the correct methods to can and able modules.
  #
  #   @param [Symbol] can_method The name of the can_[action]? method.
  #   @param [Symbol] resource_method The name of the [resource_method]_by? method.
  def self.add(can, able)
    @actions[can] = able
    add_can_method(can)
    add_able_method(can, able)
    add_enforcer_method(can)
  end

  private
    def self.add_can_method(can)
      Cans.module_eval <<-EOM
        def can_#{can}?(resource)
          method = ("can_#{can}_"+resource.class.name.gsub(/::/,"_").downcase+"?").intern
          if self.respond_to?(method, true)
            self.send method, resource
          elsif self.respond_to?(:_canable_default)
            self._canable_default
          else
            false
          end
        end
      EOM
    end

    def self.add_able_method(can, able)
      Ables.module_eval <<-EOM
        def #{able}_by?(actor)
          return false if actor.blank?
          actor.can_#{can}?(self)
        end
      EOM
    end

    def self.add_enforcer_method(can)
      Enforcers.module_eval <<-EOM
        def enforce_#{can}_permission(resource)
          raise Canable::Transgression unless can_#{can}?(resource)
        end
        private :enforce_#{can}_permission
      EOM
    end
end

Canable.add(:view,    :viewable)
Canable.add(:create,  :creatable)
Canable.add(:update,  :updatable)
Canable.add(:destroy, :destroyable)