require_relative '../config/environment'


$prompt = TTY::Prompt.new
$current_user = nil

def sign_up(name, password)#, current_user)
  if User.find_by(name: name) != nil
      puts "Sorry, username is taken. Try again."
  else
      $current_user = User.create(name: name, password: password)
      puts "You have signed up and successfully logged in. Enjoy!"
  end
  # current_user
end

def sign_in (name, password)#, current_user)
  $current_user = User.find_by(name: name, password: password)
  if $current_user == nil
      puts "Your username or password is incorrect. Please try again."
  end
  # current_user
end


def welcome_menu# (prompt, current_user)
  main_menu_choice = $prompt.select("Welcome to the Yu-Gi-Oh database!", %w(Sign-Up Log-in))
  while $current_user == nil
      username = $prompt.ask('Username:', required: true)
      pass = $prompt.mask('Password:', required: true)
      if main_menu_choice == "Sign-Up"
          sign_up(username, pass)#, current_user)
      elsif main_menu_choice == 'Log-in'
          sign_in(username, pass)#, current_user)
      end
    end
end


# def start_menu
#   main_menu_choice = prompt.select("Welcome to the Yu-Gi-Oh database!", %w(Sign-Up Log-in))
#   current_user = nil
#
#   while current_user == nil
#       username = prompt.ask('Username:', required: true)
#       pass = prompt.mask('Password:', required: true)
#       if main_menu_choice == "Sign-Up"
#           sign_up(username, pass, current_user)
#           # if User.find_by(name: username) != nil
#           #     puts "Sorry, username is taken. Try again."
#           # else
#           #     current_user = User.create(name: username, password: pass)
#           #     puts "You have signed up and successfully logged in. Enjoy!"
#           #  end
#       elsif main_menu_choice == 'Log-in'
#           sign_in(username, pass, current_user)
#       end
#   end
#
#   return current_user
# end

def timetoduel# (prompt, current_user)
  system "clear"
  welcome_menu#(prompt,current_user)
  system "clear"
  new_deck_menu#(prompt, current_user)
end



def new_deck_menu# (prompt, current_user)
  #binding.pry
  puts "Welcome #{$current_user.name}!"
  deckloop = true
  while(deckloop)
    deck_menu_choice = $prompt.select("What would you like to do?", ["View Decks", "Create Deck"])
    if deck_menu_choice == "View Decks"
      if $current_user.decks == []
        puts "You don't have any decks. Please create one."
      else
        selected_deck = $prompt.select("Deck List") do |menu|
          $current_user.decks.each do |deck|
            menu.choice deck.name, deck
          end
        end
        # separate method here to customize the deck
      end
    elsif deck_menu_choice == "Create Deck"
      create_deck
    end
  end
end

def create_deck#(current_user, prompt)
  deck_name = $prompt.ask('What would you like to name your deck?', required: true)
  $current_user.decks.create(name: deck_name)
end



def deck_menu
  # prompt = TTY::Prompt.new
  # current_user = start_menu
  # decks = start_menu.decks
  # input = 'y'

  # while input == 'y'
    deck_selection = prompt.select("Welcome to the Decks menu!", ["View Decks", "Create Deck"])
    if deck_selection == "View Decks"
      if decks == []
        puts "You don't have any decks. Please create one."
        if prompt.yes?("Would you like to go back to the decks menu?")
          input = 'y'
        end
      else
        decks_with_user = prompt.select("Deck List") do |menu|
          decks.each do |deck|
            menu.choice deck.name, deck
          end
        end
        # separate method here to customize the deck
      end
    elsif deck_selection == "Create Deck"
      current_user = start_menu
      create_deck(current_user, prompt)
    end
  # end
end


timetoduel#(prompt, current_user)




# prompt.ask('password:', echo: false)

# User.find(2).destroy
