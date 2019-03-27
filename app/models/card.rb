class Card < ActiveRecord::Base
  has_many :owners
  has_many :decks, through: :owners

  def self.get_card_by(type)
    self.send(type)
  end


  def self.filter(input)
    
  end

  def print_card_info
  	system "clear"
  	puts "Name: #{self.name}".colorize(:red)
  	puts "Type: #{self.cardtype}".colorize(:light_red)
  	!self.race.nil? ? (puts "Race: #{self.race}".colorize(:light_magenta)) : ()
  	!self.attack.nil? ? (puts "Attack: #{self.attack}".colorize(:green)) : ()
  	!self.defense.nil? ? (puts "Defense: #{self.defense}".colorize(:blue)) : ()
  	!self.cardattr.nil? ? (puts "Attribute: #{self.cardattr}".colorize(:cyan)) : ()
  	!self.description.nil? ? (puts "Description: #{self.description}".colorize(:yellow)) : ()
  end
end
