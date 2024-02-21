# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pages' do
  describe 'GET /home' do
    context 'when user is not logged in' do
      it 'renders the home page status OK' do
        get root_path
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is logged in but not confirmed' do
      it 'redirects to login page' do
        sign_in create(:user)
        get root_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is logged in and confirmed' do
      it 'renders the home page status OK' do
        sign_in create(:user, :confirmed)
        get root_path
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
