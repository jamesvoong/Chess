require_relative "Pieces.rb"

class Board
	@@ROWS = 8
	@@COLUMNS = 8

	def initialize
		create_board
		display_board
	end

# Create an array of piece objects
	def create_board
		@current_turn = 'white'
		@chess_board = Array.new(8) {Array.new()}


		@chess_board[0][0], @chess_board[7][0] = Rook.new('white', [0,0]), Rook.new('white', [7,0])
		puts @chess_board[0][0].unicode
		@chess_board[1][0], @chess_board[6][0] = Knight.new('white', [1,0]), Knight.new('white', [6,0])
		@chess_board[2][0], @chess_board[5][0] = Bishop.new('white', [2,0]), Bishop.new('white', [5,0])
		@chess_board[3][0] = Queen.new('white', [3,0])
		@chess_board[4][0] = King.new('white', [4,0])
		8.times {|i| @chess_board[i][1] = Pawn.new('white', [i,1])}

		@chess_board[0][7], @chess_board[7][7] = Rook.new('black', [0,7]), Rook.new('black', [7,7])
		@chess_board[1][7], @chess_board[6][7] = Knight.new('black', [1,7]), Knight.new('black', [6,7])
		@chess_board[2][7], @chess_board[5][7] = Bishop.new('black', [2,7]), Bishop.new('black', [5,7])
		@chess_board[3][7] = Queen.new('black', [3,7])
		@chess_board[4][7] = King.new('black', [4,7])
		8.times {|i| @chess_board[i][6] = Pawn.new('black', [i,6])}

	end

# Prints out the board and coordinates
	def display_board
		display_string = "   ---------------------------------\n"

		@@ROWS.times do |y|
			@@COLUMNS.times do |x|
				
				display_string << " #{8-y} " if x == 0
				@chess_board[x][7-y] == nil ? display_string << "|   " : display_string << "| #{@chess_board[x][7-y].unicode} " 
			end
			display_string << "|\n   ---------------------------------\n"
		end

		puts display_string.encode('utf-8')
		puts "     1   2   3   4   5   6   7   8  "
	end

# Returns true if the picked position contains a chess piece of the argument color
	def valid_piece(position, color)
		if @chess_board[position[0]][position[1]] != nil && @chess_board[position[0]][position[1]].color == color
			return true
		else
			return false
		end
	end

# Returns empty if the position being checked is empty or the color of the piece occupying the position
	def check_space(board, position)
		board[position[0]][position[1]].nil? ? "empty" : board[position[0]][position[1]].color
	end

# Returns true if the position contains King of the argument color, false otherwise
	def space_contains_king?(board, position, color)
		return false if board[position[0]][position[1]].nil? 
		
		if board[position[0]][position[1]].class.to_s == "King" && board[position[0]][position[1]].color == color
			return true
		else
			return false
		end
	end	

# Returns true if the argument position is not inside the chess board
	def out_of_bounds?(position)
		return true if !position[0].between?(0,7) || !position[1].between?(0,7)
	end

	def potential_moves(board, position, color)
		case board[position[0]][position[1]].class.to_s
		when "King"
			return potential_king_moves(board, position, color)
		when "Queen", "Bishop", "Rook"
			return potential_line_moves(board, position, color)
		when "Knight"
			return potential_knight_moves(board, position, color)
		when "Pawn"
			return potential_pawn_moves(board, position, color)
		else
			puts "Error in potential_moves"
		end
	end

# Functions that return an array of possible moves given a certain position

# Returns potential moves of the king
	def potential_king_moves(board, position, color)
		moves_list = []
		board[position[0]][position[1]].movements.each do |movement|
			new_position = [position[0]+movement[0], position[1]+movement[1]]
			moves_list.push(new_position) if !out_of_bounds?(new_position) && check_space(board, new_position) != color 
		end
		return moves_list
	end

# Used to find potential moves of a queen, bishop and rook
	def potential_line_moves(board, position, color)
		moves_list = []
		board[position[0]][position[1]].movements.each do |movement|
			new_position = position
			loop {
				new_position = [new_position[0]+movement[0], new_position[1]+movement[1]]
				if !out_of_bounds?(new_position) && check_space(board, new_position) != color 
					moves_list.push(new_position)
				else
					break
				end
			}
		end
		return moves_list	
	end

	def potential_knight_moves(board, position, color)
		moves_list = []
		board[position[0]][position[1]].movements.each do |movement|
			new_position = [position[0]+movement[0], position[1]+movement[1]]
			moves_list.push(new_position) if !out_of_bounds?(new_position) && check_space(board, new_position) != color 
		end
		return moves_list		
	end

	def potential_pawn_moves(board, position, color)
		moves_list = []
		direction = color == 'white' ? 1 : -1
		opponent_color = color == 'white' ? 'black' : 'white'

		# Check in front of pawn
		new_position = [position[0], position[1] + direction]
		moves_list << new_position if check_space(board, new_position) == "empty"

		# Check two spaces in front of pawn if it has not moved
		if board[position[0]][position[1]].opening_position == position
			new_position = [position[0], position[1] + direction + direction]
			moves_list << new_position if check_space(board, new_position) == "empty"
		end

		# Check diagonals
		new_position = [position[0] + -1, position[1] + direction]
		moves_list << new_position if !out_of_bounds?(new_position) && check_space(board, new_position) == opponent_color

		new_position = [position[0] + 1, position[1] + direction]
		moves_list << new_position if !out_of_bounds?(new_position) && check_space(board, new_position) == opponent_color

		return moves_list
	end	

# Receives a chess board state and the color to check for check
	def check?(board, color)
		
		opponent_color = color == 'white' ? 'black' : 'white'
		@@ROWS.times do |x|
			@@COLUMNS.times do |y|
				moves_for_review = nil

				if check_space(board, [x,y]) == opponent_color
					moves_for_review = potential_moves(board, [x,y], opponent_color)
				end

				if moves_for_review != nil
					moves_for_review.each do |new_position|
						return true if space_contains_king?(board, new_position, color)
					end
				end
			end
		end

		return false
	end

# Returns true if the game is over by checkmate for player of argument color
	def checkmate?(board, color)		
		opponent_color = color == 'white' ? 'black' : 'white'

		@@ROWS.times do |x|
			@@COLUMNS.times do |y|
				moves_for_review = nil				

				if check_space(board, [x,y]) == color
					moves_for_review = potential_moves(board, [x,y], board[x][y].color)
				end

				if moves_for_review != nil
					moves_for_review.each do |new_position|
						return false if !color_checked_after_move?(board, color, [x,y], new_position)
					end
				end
			end
		end

		return true
	end

# Moves a piece 
	def move_piece(board, color, origin, destination)
		if potential_moves(board, [origin[0], origin[1]], color).include?(destination)
			board[destination[0]][destination[1]] = board[origin[0]][origin[1]]
			board[origin[0]][origin[1]] = nil
		end
		return board
	end	

# Function that simulates a move and checks if it causes the player to be checked
	def color_checked_after_move?(board, color, origin, destination)
		#Temporarily alter the board to check for check
		origin_content = board[origin[0]][origin[1]]
		destination_content = board[destination[0]][destination[1]]
		move_piece(board, color, origin, destination)
		checked = check?(board, color)

		#restore the board to previous state
		board[origin[0]][origin[1]] = origin_content
		board[destination[0]][destination[1]] = destination_content
		checked ? true : false
	end

	def play		
		puts "Please enter a move in the format 4,2 2,4"

		until checkmate?(@chess_board, @current_turn)
			invalid_move = true
			puts "#{@current_turn.capitalize}'s turn!"
			while invalid_move == true
				input = gets.chomp.to_s
				origin = [(input[0].to_i)-1, (input[2].to_i)-1]
				destination = [(input[4].to_i)-1, (input[6].to_i)-1]

				if valid_piece(origin, @current_turn) == false
					puts "You do not have a piece at #{origin[0]+1},#{origin[1]+1}"
					puts "Please enter a valid move:"
					invalid_move = true
				elsif !potential_moves(@chess_board, [origin[0], origin[1]], @chess_board[origin[0]][origin[1]].color).include?(destination)
					puts "The #{@chess_board[origin[0]][origin[1]].class} at #{origin[0]+1},#{origin[1]+1} cannot be moved to #{destination[0]+1},#{destination[1]+1}"
					puts "Please enter a valid move:"
					invalid_move = true
				elsif color_checked_after_move?(@chess_board, @current_turn, origin, destination)
					puts "This move will leave your king vulnerable."
					puts "Please enter a valid move:"
					invalid_move = true
				else
					invalid_move = false
				end
			end

			@chess_board = move_piece(@chess_board, @current_turn, origin, destination)
			@current_turn = @current_turn == 'white' ? 'black' : 'white'
			display_board
		end
	end
end

ChessTestBoard = Board.new
ChessTestBoard.play