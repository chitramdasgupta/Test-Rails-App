require 'openssl'

class User < ApplicationRecord
  attr_accessor :password, :password_confirmation

  before_save :hash_password
  validate :password_match

  validates :password, presence: true, on: :create
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def authenticate(submitted_password)
    self.hashed_password == OpenSSL::Digest::SHA256.hexdigest(submitted_password + self.salt)
  end

  private

  def hash_password
    if password.present?
      self.salt = SecureRandom.hex
      self.hashed_password = OpenSSL::Digest::SHA256.hexdigest(password + self.salt)
    end
  end

  def password_match
    errors.add(:password, "doesn't match Password confirmation") unless password == password_confirmation
  end
end
