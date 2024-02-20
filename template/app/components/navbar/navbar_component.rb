# frozen_string_literal: true

module Navbar
  class NavbarComponent < ViewComponent::Base
    def initialize(current_user: nil)
      super
      @current_user = current_user
    end

    def signed_in?
      @current_user.present?
    end

    def admin?
      @current_user&.admin?
    end
  end
end
