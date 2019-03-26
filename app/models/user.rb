class User < ActiveRecord::Base
  validates :name, presence: true
  validates :password, presence: true
  validates :password, confirmation: true
  has_many :decks
end
