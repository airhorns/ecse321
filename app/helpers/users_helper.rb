module UsersHelper
  def edit_contact_text(user)
    if user == current_user
      "Edit My Profile"
    else
      "Edit this User"
    end
  end
end
