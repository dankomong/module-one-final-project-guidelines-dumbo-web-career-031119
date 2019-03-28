class Deck < ActiveRecord::Base
  belongs_to :user
  has_many :owners
  has_many :cards, through: :owners

  def add_card(card)
     Owner.create(card_id: card.id, deck_id: self.id)
  end

  def card_count
    # count how many cards there are in the deck
    # instance
    self.cards.all.length
  end


  def delete_linked_owners
    owners.all.each do |owner|
      owner.destroy
    end
  end
end
