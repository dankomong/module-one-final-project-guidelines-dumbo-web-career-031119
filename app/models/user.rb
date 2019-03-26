class User < ActiveRecord::Base
  validates :name, presence: true
  validates :password, presence: true, confirmation: true
  has_many :decks
end
