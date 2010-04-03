require 'rubygems'
require 'action_view'
require 'active_support'

module SemanticMenu
  mattr_accessor :active_class
  @@active_class = 'active'
  
  class Base
    cattr_accessor :controller
    
    attr_accessor :items
    
    def initialize
      @items = []
    end
    
    def empty?
      @items.empty?
    end
    
    def to_s
      items.join("\n")
    end
  end
  
  class Item < Base
    attr_reader :url, :title
    attr_accessor :active

    def initialize(title, url, html_options = {}, template = nil)
      super()
      @title, @url, @html_options, @template = title, url, html_options, template
    end

    def add(title, url, html_options = {}, &block)
      returning(Item.new(title, url, html_options, @template)) do |item|
        @items << item
        if block_given?
          if block.arity == 0
            item.active = !!yield
          else
            yield item
          end
        end
      end
    end
    
    def pseudo_add(title, url, &block)
      returning(PseudoItem.new(title, url, @template)) do |item|
        @items << item
        yield item if block_given?
      end
    end
    
    def add_and_activate condition, title, url, html_options = {}, &block
      item = add title, url, html_options, &block
      item.active = !!condition
      item
    end

    def to_s
      options = @html_options.delete(:html) || {}
      if active?
        options[:class] ||= ''
        (options[:class] << " #{SemanticMenu::active_class}").strip!
      end
      children = super
      children = @template.content_tag :ul, children unless empty?
      
      content = if @url == false
        @template.content_tag :span, @title, @html_options
      else
        @template.link_to @title, @url, @html_options
      end
      
      @template.content_tag :li, content + children, options
    end

    def active?
      return false if @url == false
      active || @template.current_page?(@url) || @items.any?(&:active?)
    end
  end
  
  class PseudoItem < Item
    def initialize(title, url, template = nil)
      super(title, url, {}, template)
    end
    
    def to_s
      ''
    end
  end
  
  class Menu < Item
    undef :url, :title, :active?
    
    def initialize(controller, options = {}, template = nil, &block)
      @@controller, @items, @template = controller, [], template
      @options = {:class => 'semantic-menu'}.merge options
      
      yield self if block_given?
    end
    
    def to_s
      empty?? '' : @template.content_tag(:ul, items.join("\n"), @options)
    end
  end
end
