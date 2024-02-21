# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean          default(FALSE), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User do
  describe 'factories' do
    context 'with no trait' do
      it 'is valid' do
        expect(build(:user)).to be_valid
      end

      it 'is not confirmed' do
        expect(create(:user).confirmed?).to be false
      end

      it 'is not an admin' do
        expect(create(:user).admin?).to be false
      end
    end

    context 'with trait :confirmed' do
      it 'is valid' do
        expect(build(:user, :confirmed)).to be_valid
      end

      it 'is confirmed' do
        expect(create(:user, :confirmed).confirmed?).to be true
      end

      it 'is not an admin' do
        expect(create(:user, :confirmed).admin?).to be false
      end
    end

    context 'with trait :admin' do
      it 'is valid' do
        expect(build(:user, :admin)).to be_valid
      end

      it 'is not confirmed' do
        expect(create(:user, :admin).confirmed?).to be false
      end

      it 'is an admin' do
        expect(create(:user, :admin).admin?).to be true
      end
    end
  end

  describe 'validations' do
    subject { user }

    let(:user) { build(:user) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_length_of(:password).is_at_least(8) }
    it { is_expected.to validate_length_of(:password).is_at_most(128) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_confirmation_of(:password) }
    it { is_expected.to allow_value('P@ssw0rd').for(:password) }

    it {
      expect(user).not_to allow_value('P@SSW0RD')
        .for(:password)
        .with_message(I18n.t('errors.messages.password_lower_case'))
    }

    it {
      expect(user).not_to allow_value('p@ssw0rd')
        .for(:password)
        .with_message(I18n.t('errors.messages.password_upper_case'))
    }

    it {
      expect(user).not_to allow_value('P@ssword')
        .for(:password)
        .with_message(I18n.t('errors.messages.password_number'))
    }

    it {
      expect(user).not_to allow_value('Passw0rd')
        .for(:password)
        .with_message(I18n.t('errors.messages.password_special'))
    }
  end
end
