# frozen_string_literal: true

require 'openssl'

class User < ApplicationRecord
  attr_accessor :password, :password_confirmation

  before_save :hash_password
  validate :password_match

  validates :password, presence: true, on: :create
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def authenticate(submitted_password)
    hashed_password == OpenSSL::Digest::SHA256.hexdigest(submitted_password + salt)
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64.to_s
    save
  end

  def clear_token
    self.token = nil
    save
  end

  private

  def hash_password
    return unless password.present?

    self.salt = SecureRandom.hex
    self.hashed_password = OpenSSL::Digest::SHA256.hexdigest(password + salt)
  end

  def password_match
    errors.add(:password, "doesn't match Password confirmation") unless password == password_confirmation
  end
end
