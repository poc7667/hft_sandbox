class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.integer :user_id
      t.text :query_content

      t.timestamps
    end
  end
end
