class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.bigint :user_id
      t.integer :amount
      t.text :motes
      t.bigint :tags_id, array: true
      t.datetime :happen_at

      t.timestamps
    end
  end
end
