require_relative 'Chess_Unicodes'

class Chess
	@@ROWS = 8
	@@COLUMNS = 8

	def initialize
		create_board
		display_board
	end

	def create_board
		@chess_board = []
		8.times {@chess_board << Array.new(8, " ")}

		@chess_board[0][0], @chess_board[7][0] = UNICODE_WHITE_ROOK, UNICODE_WHITE_ROOK
		@chess_board[1][0], @chess_board[6][0] = UNICODE_WHITE_KNIGHT, UNICODE_WHITE_KNIGHT
		@chess_board[2][0], @chess_board[5][0] = UNICODE_WHITE_BISHOP, UNICODE_WHITE_BISHOP
		@chess_board[3][0] = UNICODE_WHITE_QUEEN
		@chess_board[4][0] = UNICODE_WHITE_KING
		8.times {|i| @chess_board[i][1] = UNICODE_WHITE_PAWN}

		@chess_board[0][7], @chess_board[7][7] = UNICODE_BLACK_ROOK, UNICODE_BLACK_ROOK
		@chess_board[1][7], @chess_board[6][7] = UNICODE_BLACK_KNIGHT, UNICODE_BLACK_KNIGHT
		@chess_board[2][7], @chess_board[5][7] = UNICODE_BLACK_BISHOP, UNICODE_BLACK_BISHOP
		@chess_board[3][7] = UNICODE_BLACK_QUEEN
		@chess_board[4][7] = UNICODE_BLACK_KING
		8.times {|i| @chess_board[i][6] = UNICODE_BLACK_PAWN}
	end

	def display_board
		display_string = "   ---------------------------------\n"

		@@ROWS.times do |y|

			@@COLUMNS.times do |x|
				display_string << " #{y} " if x == 0
				display_string << "| #{@chess_board[x][y]} "
			end
			display_string << "|\n   ---------------------------------\n"
		end

		puts display_string.encode('utf-8')
		puts "     1   2   3   4   5   6   7   8  "
	end
end

ChessTestBoard = Chess.new