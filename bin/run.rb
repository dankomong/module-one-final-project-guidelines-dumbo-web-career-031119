require_relative '../config/environment'

#### Global Variables ######
$prompt = TTY::Prompt.new ##
$current_user = nil
$current_deck = nil       ##
############################


################### Start of Methods ###################
def sign_up(name, password)
  if User.find_by(name: name) != nil
    puts "Sorry, username is taken. Try again."
  else
    $current_user = User.create(name: name, password: password)
    puts "You have signed up and successfully logged in. Enjoy!"
  end
end

def sign_in(name, password)
  $current_user = User.find_by(name: name, password: password)
  if $current_user == nil
    puts "Your username or password is incorrect. Please try again."
  end
end

def welcome_menu
  main_menu_choice = $prompt.select("Welcome to the Yu-Gi-Oh database!", %w(Sign-Up Log-in))
  while $current_user == nil
    username = $prompt.ask('Username:', required: true)
    pass = $prompt.mask('Password:', required: true)
    if main_menu_choice == "Sign-Up"
      sign_up(username, pass)
    elsif main_menu_choice == 'Log-in'
      sign_in(username, pass)
    end
  end
end

def timetoduel
  system "clear"
  welcome_menu
  system "clear"
  deck_menu_1
end

def deck_menu_1
  puts "Welcome #{$current_user.name}!"
  deckloop = true
  while(deckloop)
    deck_menu_choice = $prompt.select("What would you like to do?", ["View Decks", "Create Deck"])
    if deck_menu_choice == "View Decks"
      if $current_user.decks == []
        puts "You don't have any decks. Please create one."
      else
        $current_deck = $prompt.select("Deck List") do |menu|
          $current_user.decks.each do |deck|
            menu.choice deck.name, deck
          end
        end
        # separate method here to customize the deck
        customize_deck
      end
    elsif deck_menu_choice == "Create Deck"
      create_deck
    end
  end
end

def create_deck
  deck_name = $prompt.ask('What would you like to name your deck?', required: true)
  $current_user.decks.create(name: deck_name)
end


def card_info(selected_card)
  if selected_card.level != nil
    puts "STATS"
    puts "Name: #{selected_card.name}"
    puts "Type: #{selected_card.cardtype}"
    puts "Race: #{selected_card.race}"
    puts "Attack: #{selected_card.attack}"
    puts "Defense: #{selected_card.defense}"
    puts "Attribute: #{selected_card.cardattr}"
    puts "Description: #{selected_card.description}"
  else
    puts "STATS"
    puts "Name: #{selected_card.name}"
    puts "Type: #{selected_card.cardtype}"
    puts "Race: #{selected_card.race}"
    puts "Description: #{selected_card.description}"
  end
end


def current_card_list
  selected_cards = $prompt.select("Card List") do |menu|
    $current_deck.cards.each_with_index do |card, index|
      menu.choice "#{index + 1}. #{card.name}", card
    end
  end
  card_info(selected_cards)
end


def deck_menu_2
  counter = 1
  card_menu_choice = $prompt.select("Customize your cards!", ["View Cards", "Customize Deck", "Back"])
  if card_menu_choice == "View Cards"
    current_card_list
  elsif card_menu_choice == "Customize Deck"
    # bring them to customize deck menu
    card_menu
  end
end


def customize_deck
  if $current_deck.cards.length == 0
    puts "You have no cards. Please add a card first."
    menu_choice = $prompt.select("Please select a choice:", ["Go to Cards Menu", "Back"])
    if menu_choice == "Go to Cards Menu"
      # bring them to the card menu through card_menu method
      card_menu
    else
      # back method
    end
  else
    deck_menu_2
  end
end


def card_menu
  card_menu_choice = $prompt.select("Welcome to the cards menu!", ["View a Card from our library", "Add a Card", "Remove a Card"])
  if card_menu_choice == "View a Card from our library"
    filter_cards_by_search
  elsif card_menu_choice == "Add a Card"
    # method to add Card
    card_row = nil
    while card_row == nil
      card_name = $prompt.ask("Please enter the name of the card you want to add to your deck: ")
      card_row = Card.find_by(name: card_name)
      if card_row == nil
        puts "Sorry. Your card wasn't found. Try again."
      else
        $current_deck.add_card(card_row)
        puts "Your card #{card_row.name} has been added! Thank you!"
      end
    end
  elsif card_menu_choice == "Remove a Card"
    # method to remove card
    card_row = nil
    while card_row == nil
      card_name = $prompt.ask("Please enter the name of the card you want to remove from your deck: ")
      # card_row = Card.find_by(name: card_name)
      $current_deck.cards.each do |ycard|
        if ycard.name == card_name
          card_row = ycard
        end
      end
      if card_row == nil
        puts "Sorry. Your card wasn't found. Try again."
      else
        $current_deck.delete_card(card_row)
        puts "Your card #{card_row.name} has been deleted! Thank you!"
      end
      deck_menu_2
    end
  end
end

def filter_cards_by_search
  card_stat_choice = $prompt.select("Please select a filter below to search for a card!", ["Name", "Type", "Level", "Attribute"])
  if card_stat_choice == "Name"
    user_input = $prompt.ask("Type in the name of the card")
    cards_arr = Card.where(name: user_input)
  elsif card_stat_choice == "Type"
    user_input = $prompt.ask("Type in the type of the card")
    cards_arr = Card.where(cardtype: user_input)
  elsif card_stat_choice == "Level"
    user_input = $prompt.ask("Type in the level of the card")
    cards_arr = Card.where(level: user_input)
  elsif card_stat_choice == "Attribute"
    user_input = $prompt.ask("Type in the attribute of the card")
    cards_arr = Card.where(cardattr: user_input)
  end

  if cards_arr.length == 0
    puts "Sorry, there are no cards that match your search."
  else
    cards_arr.each do |card|
      card_info(card)
    end
  end
  #user_input = $prompt.ask("Type in the #{card_stat_choice} of the card")
  #  cards_arr = Cards.where(cards_stat_choice.to_sym => input)
  # if cards_arr.length == 0
  #   puts "Sorry, there are no cards that match your search."
  # else
  #   cards_arr.each do |card|
  #     card_info(card)
  #   end
  # end
end


################### End of Methods ###################
################### Program Starts ###################

timetoduel

#################### Program Ends ####################
