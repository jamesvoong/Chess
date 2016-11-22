require_relative "Pieces.rb"

class Board
	@@ROWS = 8
	@@COLUMNS = 8

	def initialize
		create_board
		display_board
	end

	def create_board
		@chess_board = []
		8.times {@chess_board << Array.new(8, nil)}

		@chess_board[0][0], @chess_board[7][0] = Rook.new('white'), Rook.new('white')
		@chess_board[1][0], @chess_board[6][0] = Knight.new('white'), Knight.new('white')
		@chess_board[2][0], @chess_board[5][0] = Bishop.new('white'), Bishop.new('white')
		@chess_board[3][0] = Queen.new('white')
		@chess_board[4][0] = King.new('white')
		8.times {|i| @chess_board[i][1] = Pawn.new('white')}

		@chess_board[0][7], @chess_board[7][7] = Rook.new('black'), Rook.new('black')
		@chess_board[1][7], @chess_board[6][7] = Knight.new('black'), Knight.new('black')
		@chess_board[2][7], @chess_board[5][7] = Bishop.new('black'), Bishop.new('black')
		@chess_board[3][7] = Queen.new('black')
		@chess_board[4][7] = King.new('black')
		8.times {|i| @chess_board[i][6] = Pawn.new('black')}
	end

########## Prints out the board and 
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

	def pick_piece(position)

	end
end

ChessTestBoard = Board.new