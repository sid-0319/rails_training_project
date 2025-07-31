class AddRoleTypeAndAccountStatusToUsers < ActiveRecord::Migration[6.1]
  def change
    # Columns already exist in DB, so we don't add them again.
    # This migration is just to keep history clean.
  end
end
