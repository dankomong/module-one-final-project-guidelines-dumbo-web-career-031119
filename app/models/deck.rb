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
  end

  def delete_card(card)
    self.cards.each do |card_user|
      if card_user.name == card.name
        card.destroy
      end
    end
  end

end
