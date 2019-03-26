require_relative 'config/environment'
require 'sinatra/activerecord/rake'

desc 'starts a console'
task :console do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  Pry.start
end

desc 'gets cards from Yu-Gi-Oh database'
task :pullfromdb do
	response_string = RestClient.get('https://db.ygoprodeck.com/api/v4/cardinfo.php')
  	response_hash = JSON.parse(response_string)[0]
  	response_hash.each do |card|
  		# binding.pry
  		newCard = Card.new(name:card["name"], cardtype:card["type"], race:card["race"], level:card["level"], attack:card["atk"], defense:card["def"], cardattr:card["attribute"], description:card["desc"], image_url:card["image_url_small"])
  		# binding.pry
  		newCard.save
  	end
end


# Copy and paste into rake console to delete duplicate cards

desc 'deletes duplicate cards from database'
task :deletedupes do
	Card.all.uniq{|card| card.name}.each do |x|
		if (Card.where(name: x.name).count > 1)
			Card.where(name: x.name).last((Card.where(name: x.name).count)-1).each do |y|
				y.destroy
			end
		end
	end
end
