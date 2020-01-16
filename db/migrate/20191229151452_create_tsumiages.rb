class CreateTsumiages < ActiveRecord::Migration[5.2]
  def change
    create_table :tsumiages do |t|
      t.integer :time
      t.string :genre
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :tsumiages, [:user_id, :created_at]
  end
end
