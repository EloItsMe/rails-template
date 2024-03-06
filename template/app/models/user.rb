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
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # Email\Password validations is done by devise
  validates :password, format: { with: /\A.*[a-z].*\z/x, message: I18n.t('errors.messages.password_lower_case') }
  validates :password, format: { with: /\A.*[A-Z].*\z/x, message: I18n.t('errors.messages.password_upper_case') }
  validates :password, format: { with: /\A.*\d.*\z/x, message: I18n.t('errors.messages.password_number') }
  validates :password, format: { with: /\A.*[[:^alnum:]].*\z/x, message: I18n.t('errors.messages.password_special') }

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
