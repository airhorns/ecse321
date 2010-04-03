module SemanticMenu
  module Controller
    def self.included base
      base.extend ClassMethods
    end
    
    module ClassMethods
      def semantic_menu_for *names
        names.each do |name|
          class_eval <<-EOT, __FILE__, __LINE__
            def #{name}
              @#{name} ||= SemanticMenu::Menu.new(self, {}, @template)
            end
            hide_action :#{name}
            helper_method :#{name}
            
            def self.#{name} options = {}, &block
              before_filter options do |controller|
                controller.instance_exec(controller.#{name}, &block)
              end
            end
          EOT
        end
      end
    end
  end
end