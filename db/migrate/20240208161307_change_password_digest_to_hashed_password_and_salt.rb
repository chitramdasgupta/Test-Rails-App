class ChangePasswordDigestToHashedPasswordAndSalt < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :password_digest, :string
    add_column :users, :hashed_password, :string
    add_column :users, :salt, :string
  end
end
