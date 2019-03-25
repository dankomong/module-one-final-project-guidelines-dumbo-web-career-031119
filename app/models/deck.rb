class Deck < ActiveRecord::Base
  belongs_to :user
  has_many :ownerships
  has_many :cards, through: :ownerships

  def add_card(card)
    Owner.new()
  end

  def card_count
    # count how many cards there are in the deck
    # instance
  end

  def delete_card(card)
  end
end
