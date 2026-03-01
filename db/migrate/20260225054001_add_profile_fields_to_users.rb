class AddProfileFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :display_name, :string
    add_column :users, :bio, :text
    add_column :users, :location, :string
    add_column :users, :interests, :string
  end
end
