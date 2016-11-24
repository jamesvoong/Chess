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
		@chess_board = []
		8.times {@chess_board << Array.new(8, nil)}

		@chess_board[0][0], @chess_board[7][0] = Rook.new('white', [0,0]), Rook.new('white', [7,0])
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
		8.times {|i| @chess_board[i][6] = Pawn.new('black', [i,7])}
	end

# Prints out the board and coordinates
	def display_board
		display_string = "   ---------------------------------\n"

		@@ROWS.times do |y|
			@@COLUMNS.times do |x|
				display_string << " #{8-y} " if x == 0
				@chess_board[x][y] == nil ? display_string << "|   " : display_string << "| #{@chess_board[x][y].unicode} " 
			end
			display_string << "|\n   ---------------------------------\n"
		end

		puts display_string.encode('utf-8')
		puts "     1   2   3   4   5   6   7   8  "
	end

# Returns true if the picked position contains a chess piece of the argument color
	def valid_piece(position, color)
		if @chess_board[position[0],position[1]] != nil && @chess_board[position[0],position[1]].color == color
			return true
		else
			return false
		end
	end

# Returns empty if the position being checked is empty or the color of the piece occupying the position
	def check_space(position)
		@chess_board[position[0],position[1]].nil? ? "empty" : @chess_board[position[0],position[1]].color
	end

# Returns true if the position contains King of the argument color, false otherwise
	def space_contains_king?(position, color)
		return false if @chess_board[position[0],position[1]].nil? 
		
		if @chess_board[position[0],position[1]].class == "King" && @chess_board[position[0],position[1]].color == color
			return true
		else
			return false
		end
	end	

# Returns true if the argument position is not inside the chess board
	def out_of_bounds?(position)
		return true if !position[0].between?(0..7) || !position[1].between?(0..7)
	end

# Functions that return an array of possible moves given a certain position


	def potential_king_moves(position, color)
		moves_list = []
		@chess_board[position[0],position[1]].movements.each do |movement|
			new_position = [position[0]+movement[0], position[1]+movement[1]]
			moves_list.push(new_position) if check_space(new_position) != color && !out_of_bounds?(new_position)
		end
		return moves_list
	end

# Used to find potential moves of a queen, bishop and rook
	def potential_line_moves(position, color)
		moves_list = []
		@chess_board[position[0],position[1]].movements.each do |movement|
			new_position = position
			loop {
				new_position = [new_position[0]+movement[0], new_position[1]+movement[1]]
				if check_space(new_position) != color && !out_of_bounds?(new_position)
					moves_list.push(new_position)
				else
					break
				end
			}
		end
		return moves_list	
	end

	def potential_knight_moves(position, color)
		moves_list = []
		@chess_board[position[0],position[1]].movements.each do |movement|
			new_position = [position[0]+movement[0], position[1]+movement[1]]
			moves_list.push(new_position) if check_space(new_position) != color && !out_of_bounds?(new_position)
		end
		return moves_list		
	end

	def potential_pawn_moves(position, color)
		moves_list = []
		direction = color == 'white' ? 1 : -1
		opponent_color = color == 'white' ? 'black' : 'white'

		# Check in front of pawn
		new_position = [position[0], position[1] + direction]
		moves_list << new_position if check_space(new_position) == "empty"

		# Check two spaces in front of pawn if it has not moved
		if @chess_board[position[0], position[1]].opening_position == position
			new_position = [position[0], position[1] + direction + direction]
			moves_list << new_position if check_space(new_position) == "empty"
		end

		# Check diagonals
		new_position = [position[0] + -1, position[1] + direction]
		moves_list << new_position if !out_of_bounds?(new_position) && check_space(new_position) == opponent_color

		new_position = [position[0] + 1, position[1] + direction]
		moves_list << new_position if !out_of_bounds?(new_position) && check_space(new_position) == opponent_color
	end	

# Receives a chess board state and the color to check for check
	def check?(temporary_board, color)
		temporary_board.each do |x|
			x.each do |y|

			end
		end
	end

end

ChessTestBoard = Board.new