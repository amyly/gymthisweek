class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :foursquare_token
      t.string :custom_hashtags

      t.timestamps
    end
  end
end
