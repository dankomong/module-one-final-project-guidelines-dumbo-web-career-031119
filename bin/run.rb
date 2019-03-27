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

def sign_in (name, password)
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
  return 1
end

def timetoduel
  prompt_selection = [0]
  while prompt_selection[0] != nil
    #system "clear"
    case prompt_selection[0]
      when 0
        prompt_selection[0] = welcome_menu
      when 1
        prompt_selection[0] = deck_choice_menu
      when 2
        prompt_selection[0] = view_decks
      when 3
        prompt_selection[0] = create_deck
      when 4
        prompt_selection[0] = deck_menu
      when 5
        prompt_selection[0] = deck_card_list
    end
  end
end


def deck_choice_menu
  puts "Welcome #{$current_user.name}!"
  deck_menu_arr = [{name: "View Decks", value: 2}, {name: "Create Deck", value: 3}]
  $current_user.decks == [] ? (deck_menu_arr[0] = {name: "View Decks".colorize(:red), disabled: "(you don't have any decks to view)"}) : ""
  $prompt.select("What would you like to do?", deck_menu_arr)
end


def view_decks
  $current_deck = $prompt.select("#{$current_user.name}'s deck list") do |menu|
    $current_user.decks.each do |deck|
    menu.choice deck.name, deck
    end
  end
  return 4
end

def create_deck
  deck_name = $prompt.ask('What would you like to name your deck?', required: true)
  $current_user.decks.create(name: deck_name)
  return 2
end


def deck_card_list
  selected_card = $prompt.select("Card List") do |menu|
    $current_deck.cards.each_with_index do |card, index|
      menu.choice "#{index + 1}. #{card.name}", card
    end
  end
  selected_card.print_card_info
  return 5
end

def deck_menu
  deck_menu_arr = [{name: "View Cards", value: 5}, {name: "Customize Deck", value: 6}, {name: "Back", value: 2}]
  $current_deck.cards.length == 0 ? (deck_menu_arr[0] = {name: "View Cards".colorize(:red), disabled: "(you don't have any cards in this deck"}) : ""
  $prompt.select("Customizing your Deck: #{$current_deck.name}", deck_menu_arr)
  # if card_menu_choice == "View Cards"
  #   current_card_list
  # elsif card_menu_choice == "Customize Deck"
  #   # bring them to customize deck menu
  #   card_menu
  # end
end


# def customize_deck
#   if $current_deck.cards.length == 0
#     puts "You have no cards. Please add a card first."
#     menu_choice = $prompt.select("Please select a choice:", ["Go to Cards Menu", "Back"])
#     if menu_choice == "Go to Cards Menu"
#       # bring them to the card menu through card_menu method
#       card_menu
#     else
#       # back method
#     end
#   else
#     deck_menu_2
#   end
# end


def card_choice_menu
    card_menu_choice = $prompt.select("Welcome to the cards menu!", ["View a Card", "Add a card", "Back"])
    if card_menu_choice == "View a Card"
      filter_cards_by_search
    elsif card_menu_choice == "Add a Card"

    elsif card_menu_choice == "Back"

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
      card.print_card_info
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

# def card_info(selected_card)
#   if selected_card.level != nil
#     puts "STATS"
#     puts "Name: #{selected_card.name}"
#     puts "Type: #{selected_card.cardtype}"
#     puts "Race: #{selected_card.race}"
#     puts "Attack: #{selected_card.attack}"
#     puts "Defense: #{selected_card.defense}"
#     puts "Attribute: #{selected_card.cardattr}"
#     puts "Description: #{selected_card.description}"
#   else
#     puts "STATS"
#     puts "Name: #{selected_card.name}"
#     puts "Type: #{selected_card.cardtype}"
#     puts "Race: #{selected_card.race}"
#     puts "Description: #{selected_card.description}"
#   end
# end
#
# def current_card_list
#   selected_cards = $prompt.select("Card List") do |menu|
#     $current_deck.cards.each_with_index do |card, index|
#       menu.choice "#{index + 1}. #{card.name}", card
#     end
#   end
#   card_info(selected_cards)
# end
# def deck_menu_1
#   puts "Welcome #{$current_user.name}!"
#   deckloop = true
#   while(deckloop)
#     deck_menu_choice = $prompt.select("What would you like to do?", ["View Decks", "Create Deck"])
#     if deck_menu_choice == "View Decks"
#       if $current_user.decks == []
#         puts "You don't have any decks. Please create one."
#       else
#         $current_deck = $prompt.select("Deck List") do |menu|
#           $current_user.decks.each do |deck|
#             menu.choice deck.name, deck
#           end
#         end
#         # separate method here to customize the deck
#         customize_deck
#       end
#     elsif deck_menu_choice == "Create Deck"
#       create_deck
#     end
#   end
# end
