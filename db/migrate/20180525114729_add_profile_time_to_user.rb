class AddProfileTimeToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :profile_link, :string
  end
end
