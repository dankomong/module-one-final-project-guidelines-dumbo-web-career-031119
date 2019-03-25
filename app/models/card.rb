class Card < ActiveRecord::Base
  has_many :ownerships
  has_many :decks, through: :ownerships

  def self.get_card_by(type)
    self.send(type)
  end
end
