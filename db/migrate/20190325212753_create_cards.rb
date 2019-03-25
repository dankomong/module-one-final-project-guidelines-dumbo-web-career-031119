class CreateCards < ActiveRecord::Migration[5.0]
  def change
    create_table :cards do |t|
      t.string :name
      t.string :cardtype
      t.string :race
      t.integer :level
      t.integer :attack
      t.integer :defense
      t.string :cardattr
      t.string :description
      t.string :image_url
    end
  end
end
