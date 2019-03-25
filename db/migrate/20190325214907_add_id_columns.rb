class AddIdColumns < ActiveRecord::Migration[5.0]
  def change
  	add_column :owners, :deck_id, :integer
  	add_column :owners, :card_id, :integer
  	add_column :decks, :user_id, :integer
  end
end
