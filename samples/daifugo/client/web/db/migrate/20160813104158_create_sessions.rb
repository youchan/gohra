class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :guid, null: false
      t.string :player_guid
      t.string :session_id
      t.time :login_at
      t.time :expire_at
      t.boolean :login
    end
  end
end
