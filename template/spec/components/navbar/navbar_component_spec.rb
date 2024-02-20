# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Navbar::NavbarComponent, type: :component do
  context 'when not signed in' do
    it 'renders a navbar with Log in Link' do
      render_inline(described_class.new)
      expect(page).to have_link 'Log in', href: new_user_session_path
    end

    it 'renders a navbar with Sign up Link' do
      render_inline(described_class.new)
      expect(page).to have_link 'Sign up', href: new_user_registration_path
    end
  end

  context 'when signed in' do
    let(:user) { create(:user) }

    it 'renders a navbar with Profile Link' do
      render_inline(described_class.new(current_user: user))
      expect(page).to have_link 'Profile', href: edit_user_registration_path
    end

    it 'renders a navbar with Log out Link' do
      render_inline(described_class.new(current_user: user))
      expect(page).to have_link 'Log out', href: destroy_user_session_path
    end
  end
end
