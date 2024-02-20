# frozen_string_literal: true

class NavbarComponentPreview < ViewComponent::Preview
  def not_signed_in
    render(Navbar::NavbarComponent.new)
  end

  def signed_in
    render(Navbar::NavbarComponent.new(current_user: User.new))
  end
end
