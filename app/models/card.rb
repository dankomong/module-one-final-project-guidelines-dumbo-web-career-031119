class Card < ActiveRecord::Base
  has_many :owners
  has_many :decks, through: :owners

  def self.get_card_by(type)
    self.send(type)
  end
end
