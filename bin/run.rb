require_relative '../config/environment'


prompt = TTY::Prompt.new

main_menu_choice = prompt.select("Welcome to the Yu-Gi-Oh database!", %w(Sign-Up Log-in))



current_user = nil

while current_user == nil
    username = prompt.ask('Username:', required: true)
    pass = prompt.mask('Password:', required: true)
    if main_menu_choice == "Sign-Up"
        if User.find_by(name: username) != nil
            puts "Sorry, username is taken. Try again."
        else
            current_user = User.create(name: username, password: pass)
            puts "You have signed up and successfully logged in. Enjoy!"
         end
    elsif main_menu_choice == 'Log-in'
        current_user = User.find_by(name: username, password: pass)
        # system "clear"
        if current_user == nil
            puts "Your username or password is incorrect. Please try again."
        end
    end
end

decks = current_user.decks


def create_deck(current_user, prompt)
  deck_name = prompt.ask('What would you like to name your deck?', required: true)
  current_user.decks.create(name: deck_name)
end

input = 'y'

while input == 'y'
  deck_selection = prompt.select("Welcome to the Decks menu!", ["View Decks", "Create Deck"])
  if deck_selection == "View Decks"
    if decks == []
      puts "You don't have any decks. Please create one."
      if prompt.yes?("Would you like to go back to the decks menu?")
        input = 'y'
      end
    else
      fucku = prompt.select("Deck List") do |menu|
        decks.each do |deck|
          menu.choice deck.name, deck
        end
      end
      binding.pry
    end
  elsif deck_selection == "Create Deck"
    create_deck(current_user, prompt)
  end
end




# prompt.ask('password:', echo: false)

# User.find(2).destroy
