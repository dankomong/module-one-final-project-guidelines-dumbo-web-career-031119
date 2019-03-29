require_relative '../config/environment'

#### Global Variables ######
$prompt = TTY::Prompt.new ##
$current_user = nil       ##
$current_deck = nil       ##
$current_card = nil       ##
############################


################### Start of Methods ###################
def timetoduel
  # binding.pry
  prompt_selection = [0]
  while prompt_selection[0] != nil
    system "clear"
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
    when 6
      prompt_selection[0] = customize_deck_menu_choices
    when 7
      prompt_selection[0] = update_deck_name
    when 8
      prompt_selection[0] = add_card
    when 9
      prompt_selection[0] = delete_card
    end
    !$current_deck.nil? ? $current_deck.reload : ()
  	!$current_user.nil? ? $current_user.reload : ()

  end
end

def welcome_menu #0
  main_menu_choice = $prompt.select("Welcome to the Yu-Gi-Oh database!", %w(Sign-Up Log-in Exit))
  if main_menu_choice == 'Exit'
    # $current_user = 0
    system 'clear'
    puts "Believe in the heart of the cards"
    return nil
  end
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

def log_out
  $current_user = nil
  $current_deck = nil
  $current_card = nil     
  return 0
end

def deck_choice_menu #1
  puts "Welcome #{$current_user.name}!"
  deck_menu_arr = [{name: "View Decks", value: 2}, {name: "Create Deck", value: 3},{name: "Log-out", value: 0}]
  $current_user.decks == [] ? (deck_menu_arr[0] = {name: "View Decks".colorize(:red), disabled: "(you don't have any decks to view)"}) : ""
  user_choice = $prompt.select("What would you like to do?", deck_menu_arr)
  user_choice == 0 ? log_out : user_choice
end


def view_decks #2
  $current_deck = $prompt.select("#{$current_user.name}'s deck list") do |menu|
    $current_user.decks.each do |deck|
      menu.choice "#{deck.name} - #{deck.cards.length} Cards", deck
    end
  end
  return 4
end

def create_deck #3
  deck_name = $prompt.ask('What would you like to name your deck?', required: true)
  $current_user.decks.create(name: deck_name)
  return 2
end

def deck_menu #4
  puts "Deck: " + "#{$current_deck.name}".colorize(:light_blue)
  deck_menu_arr = [{name: "View Cards", value: 5}, {name: "Customize Deck", value: 6}, {name: "Delete Deck", value: -1},{name: "Back", value: 1}]
  $current_deck.cards.length == 0 ? (deck_menu_arr[0] = {name: "View Cards".colorize(:red), disabled: "(you don't have any cards in this deck"}) : ""
  menu_return_value = $prompt.select("Customizing your Deck: " + "#{$current_deck.name}".colorize(:light_blue), deck_menu_arr)
  # binding.pry
  if menu_return_value == -1
  # binding.pry

    ## Destroying all instances of owner related to the deck we're about to delete
    $current_deck.delete_linked_owners
    $current_deck.destroy
    puts "You have deleted your deck '#{$current_deck.name}'"
    $current_deck = nil
    menu_return_value = 1
  end
  # binding.pry

  menu_return_value
end

def deck_card_list #5
  if $current_deck.card_count == 0  
    $prompt.keypress("You have no cards")
    return 6
  end
  $current_card = $prompt.select("Card List") do |menu|
    $current_deck.cards.each_with_index do |card, index|
      menu.choice "#{index + 1}. #{card.name}", card
    end
    menu.choice "Back"
  end

  # binding.pry
  if $current_card == "Back" #couldnt return nil
    $current_card = nil
    return 6
  end

  $current_card.print_card_info

  menu_choice = $prompt.select("What do you want to do?") do |menu|
    menu.choice 'Delete card'
    menu.choice 'Back'
  end
  if menu_choice == "Delete card"
    delete_current_card
  end
  return 5
end

def customize_deck_menu_choices #6
  # card_menu_choice = [{name: 'Add a Card', value: 8}, {name: 'Remove a Card', value: 5}, {name: 'Back', value: 4}]
  card_menu_choice = $prompt.select("what would you like to do.") do |menu|
    menu.choice 'Add a Card', 8
    if $current_deck.card_count != 0
      menu.choice 'Remove a Card', 5
    else
      menu.choice 'Remove a Card'.colorize(:red), 5,  disabled: "(You don't have any cards to remove!)"
    end
    menu.choice 'Update deck name', 7
    menu.choice 'Back', 4
  end

  def update_deck_name #7
   puts "Current Deck: " + "#{$current_deck.name}".colorize(:light_blue)
   user_input = $prompt.ask("Type in the new name for your deck: ")    
   $current_deck.update(name: user_input)
   return 6
  end


  # puts "what would you like to do. Deck: #{$current_deck.name}. Cards:#{$current_deck.owners.all.length}"
  # menu_choices = [{name: "Add a Card", value: 8}, {name: "Remove a Card", value: 9}]
  # card_menu_choice = $prompt.select(
    # "what would you like to do. Deck: #{$current_deck.name}. Cards:#{$current_deck.owners.all.length}", 
    # [{])
  # deck_destiny_choice = [{name: "Add a card", value: 7}, {name: "Delete card", value: -1},{name: "Back", value: 4}]
  ## Things to do
  ## make prompt with choices
  ## Add to deck *interpolate name*         ##Pass in array of hashes to prompt.choice with
  ## $current_deck.add_card($current_card)
  ## Remove from deck *interpolate name*    ##check of if $current_card is in $current_deck
  ## $current_deck.remove_card($current_card)
  ## Back                                   ##disable options appropriately
  ## $current_card = nil
  ## return 5

  return card_menu_choice
end

def add_card #8
  filter_cards_by_search
  puts $current_card.print_card_info
  menu_choice = $prompt.select("What would you like to do.") do |menu|
    menu.choice "Add to deck"
    menu.choice "Back"
  end
  # binding.pry

  if menu_choice == "Add to deck"
    $current_deck.add_card($current_card)
    $prompt.keypress("#{$current_card.name} added to deck. \nPress any key to continue")
  end
  ## similar to current_card_menu_from_deck
  ## instead, back returns to whatever case card search was
  ## and add and remove to/from current deck returns 5
  return 4
end

def delete_current_card #9
  # show_deck_cards
  Owner.find_by(deck: $current_deck, card: $current_card).destroy

  # $prompt.keypress("#{$current_card.name} added to deck")
  return 4
end



def filter_cards_by_search 
  cards_arr = []
  while cards_arr.length == 0 #keep searching till you are able to find a card
  card_stat_choice = $prompt.select("Please select a filter below to search for a card!", ["Name", "Type", "Level", "Attribute"])

  if card_stat_choice == "Name"
   user_input = $prompt.ask("Type in the name of the card")
   user_input = "%#{user_input}%"
   cards_arr = Card.where('name LIKE ?',user_input).sort_by{|card| card.name}

  elsif card_stat_choice == "Type"
   user_input = $prompt.ask("Type in the type of the card")
   user_input = "%#{user_input}%"
   cards_arr = Card.where('cardtype LIKE ?',user_input).sort_by{|card| card.name}

  elsif card_stat_choice == "Level"
   user_input = $prompt.ask("Type in the level of the card")
   user_input = "%#{user_input}%"
   cards_arr = Card.where('level LIKE ?',user_input).sort_by{|card| card.name}

  elsif card_stat_choice == "Attribute"
   user_input = $prompt.ask("Type in the attribute of the card")
   user_input = "%#{user_input}%"
   cards_arr = Card.where('cardattr LIKE ?',user_input).sort_by{|card| card.name}

  end

  if cards_arr.length == 0
    $prompt.keypress("Sorry, there are no cards that match your search. \n Press any key to continue")
   system "clear"

  else#selection menu
   $current_card = $prompt.select("Select a card.") do |menu|
   cards_arr.each do |card|
     menu.choice card.name, card
   end
  end
 end
end
#make it not return anything just call from viewCard/DeleteCard
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


# def card_choice_menu
#     card_menu_choice = $prompt.select("Welcome to the cards menu!", ["View a Card", "Add a card", "Back"])
#     if card_menu_choice == "View a Card"
#       filter_cards_by_search
#     elsif card_menu_choice == "Add a Card"

#     elsif card_menu_choice == "Back"

#     end
# end

# def card_menu
#   card_menu_choice = $prompt.select("Welcome to the cards menu!", ["View a Card from our library", "Add a Card", "Remove a Card", "Delete the entire deck"])
#   if card_menu_choice == "View a Card from our library"
#     filter_cards_by_search
#   elsif card_menu_choice == "Add a Card"
#     ############## start of add card method ##################
#     card_row = nil
#     while card_row == nil
#       card_name = $prompt.ask("Please enter the name of the card you want to add to your deck: ")
#       card_row = Card.find_by(name: card_name)
#       if card_row == nil
#         puts "Sorry. Your card wasn't found. Try again."
#       else
#         $current_deck.add_card(card_row)
#         puts "Your card #{card_row.name} has been added! Thank you!"
#       end
#       ############## end of add card method ##################
#     end
#   elsif card_menu_choice == "Remove a Card"
#     ############## start of remove card method ##################
#     card_row = nil
#     while card_row == nil
#       card_name = $prompt.ask("Please enter the name of the card you want to remove from your deck: ")
#       # card_row = Card.find_by(name: card_name)
#       $current_deck.cards.each do |ycard|
#         if ycard.name == card_name
#           card_row = ycard
#         end
#       end
#       if card_row == nil
#         puts "Sorry. Your card wasn't found. Try again."
#       else
#         $current_deck.delete_card(card_row)
#         puts "Your card #{card_row.name} has been deleted! Thank you!"
#       end
#     end
#     ############## end of remove card method ##################
#   end
# end
  #user_input = $prompt.ask("Type in the #{card_stat_choice} of the card")
  #  cards_arr = Cards.where(cards_stat_choice.to_sym => input)
    # if cards_arr.length == 0
    #   puts "Sorry, there are no cards that match your search."
    # else
    #   cards_arr.each do |card|
    #     card_info(card)
    #   end
    # end
  


################### End of Methods ###################
################### Program Starts ###################

timetoduel

#################### Program Ends ####################


