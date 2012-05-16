class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.integer :user_id
      t.integer :type_id
      t.integer :value

      t.timestamps
    end
  end
end
