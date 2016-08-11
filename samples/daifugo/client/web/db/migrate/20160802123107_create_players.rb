class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :guid
      t.string :name
      t.string :login
      t.string :password
    end
  end
end
