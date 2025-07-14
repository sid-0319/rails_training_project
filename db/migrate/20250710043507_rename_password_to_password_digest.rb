# frozen_string_literal: true

# Renames the password
class RenamePasswordToPasswordDigest < ActiveRecord::Migration[8.0]
  def change
    rename_column :users, :password, :password_digest
  end
end
