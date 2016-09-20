class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :guid, null: false
    end
  end
end
