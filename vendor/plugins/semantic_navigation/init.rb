require 'semantic_menu'
require 'menu_helper'
require 'controller'

ActionView::Base.send :include, SemanticMenuHelper
ActionController::Base.send :include, SemanticMenu::Controller