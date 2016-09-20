class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :guid, null: false
      t.string :account_guid
      t.string :game_guid
      t.boolean :playing
    end
  end
end
