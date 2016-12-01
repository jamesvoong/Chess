require_relative "Board"

system "clear" or system "cls"
puts "Welcome to Chess.rb!"
puts "Please 'new' for a new game or 'load' to load a game from a save file."

choice = gets.chomp.downcase

while choice != "load" && choice != "new"
	puts "Invalid input. Please type new or load."
end

Chess = Board.new

if choice == "new"
	Chess.new_game
	Chess.play
else
	puts "Please enter the name of the save file (eg.chessfile.yaml)"
	filename = gets.chomp
	Chess.load(filename)
	Chess.display_board
	Chess.play
end