class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :guid
      t.string :name
      t.string :uid
      t.string :password
    end
  end
end
