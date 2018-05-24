class CreateBookmarks < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmarks do |t|
      t.string :sc_shot
      t.string :logo
      t.string :url
      t.string :name

      t.timestamps
    end
  end
end
