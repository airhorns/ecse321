# Use as so:
# <%= semantic_menu do |root|
#   root.add "overview", root_path
#   root.add "comments", comments_path
# end %>
#
# Assuming you are on /comments, the output would be:
#
# <ul class="menu">
#   <li>
#     <a href="/">overview</a>
#   </li>
#   <li class="active">
#     <a href="/comments">comments</a>
#   </li>
# </ul>
module SemanticMenuHelper
  def semantic_menu(options = {}, &block)
    content = SemanticMenu::Menu.new(controller, options, self, &block).to_s
    concat(content)
    content
  end
end
