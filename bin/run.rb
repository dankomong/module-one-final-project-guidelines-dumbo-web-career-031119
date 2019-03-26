require_relative '../config/environment'
require "catpix"

Catpix::print_image "pokemon.png",
  :limit_x => 1.0,
  :limit_y => 0,
  :center_x => true,
  :center_y => true,
  :bg => "white",
  :bg_fill => true

system "clear"

prompt = TTY::Prompt.new


prompt.ask("What is your name?", default: ENV['USER'])

main_menu_choice = prompt.select("Welcome to the Yu-Gi-Oh database!", %w(Sign-Up Log-in))



current_user = nil

while current_user == nil
    username = prompt.ask('Username:', required: true)
    pass = prompt.ask('password:', echo: false, required: true)
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
# prompt.ask('password:', echo: false)

# User.find(2).destroy
>>>>>>> cd56a5ac3b641f0981b70b353c745080400c5862
