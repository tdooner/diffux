class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :google_uid, null: false
      t.string :name
      t.string :email
      t.string :image_url

      t.timestamps
    end
  end
end
