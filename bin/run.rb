require_relative '../config/environment'
require "catpix"

Catpix::print_image "pokemon.png",
  :limit_x => 1.0,
  :limit_y => 0,
  :center_x => true,
  :center_y => true,
  :bg => "white",
  :bg_fill => true



puts "HELLO WORLD"
prompt = TTY::Prompt.new

prompt.ask("What is your name?", default: ENV['USER'])
