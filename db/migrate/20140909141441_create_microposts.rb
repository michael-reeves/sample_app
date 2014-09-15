class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    # create a two key index for looking up posts by user and time
    add_index :microposts, [ :user_id, :created_at ]
  end
  
end
