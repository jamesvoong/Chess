require_relative "Pieces.rb"

class Board
	@@ROWS = 8
	@@COLUMNS = 8
	@@PROMOTION_CHOICES = ["rook", "knight", "bishop", "queen"]

	@@LETTER_MAPPING = {
		"A" => 7,
		"B" => 6,
		"C" => 5,
		"D" => 4,
		"E" => 3,
		"F" => 2,
		"G" => 1,
		"H" => 0
  	}

	def initialize
		create_board
		display_board
	end

# Create an array of piece objects
	def create_board
		@current_turn = 'white'
		@chess_board = Array.new(8) {Array.new()}


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

# Prints out the board and coordinates
	def display_board
		puts "     1   2   3   4   5   6   7   8  "
		display_string = "   ---------------------------------\n"

		@@ROWS.times do |y|
			@@COLUMNS.times do |x|
				display_string << " #{@@LETTER_MAPPING.key(7-y)} " if x == 0
				@chess_board[x][7-y] == nil ? display_string << "|   " : display_string << "| #{@chess_board[x][7-y].unicode} " 
			end
			display_string << "| #{@@LETTER_MAPPING.key(7-y)}\n   ---------------------------------\n"
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

# Used to find potential moves of pieces that move in straight lines (queen, bishop and rook)
	def potential_line_moves(board, position, color)
		moves_list = []
		opponent_color = color == 'white' ? 'black' : 'white'

		board[position[0]][position[1]].movements.each do |movement|
			new_position = position
			loop {
				new_position = [new_position[0]+movement[0], new_position[1]+movement[1]]
				if !out_of_bounds?(new_position) && check_space(board, new_position) == "empty"
					moves_list.push(new_position)
				elsif !out_of_bounds?(new_position) && check_space(board, new_position) == opponent_color
					moves_list.push(new_position)
					break
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
		if board[position[0]][position[1]].moved == false
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

		# If the player is not in check, they cannot be in checkmate
		return false if check?(board, color) == false

		# Check all possible moves for color and return false if there is a move that allows them to leave a checked state
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

		if can_en_passant?(board, color, @last_move, 'left')
			return false if !color_checked_after_move?(board, color, nil, nil, "en passant left")
		end

		if can_en_passant?(board, color, @last_move, 'right')
			return false if !color_checked_after_move?(board, color, nil, nil, "en passant right")
		end

		return true
	end

	def move_piece(board, color, origin, destination)
		board[destination[0]][destination[1]] = board[origin[0]][origin[1]]
		board[origin[0]][origin[1]] = nil
		board[destination[0]][destination[1]].moved = true if board[destination[0]][destination[1]].moved == false
	end	

# Function that simulates a move and checks if it causes the player to be checked
	def color_checked_after_move?(board, color, origin, destination, special_move=nil)
		case special_move
		when 'castle right'
			castle(board, color, 'right')
			checked = check?(board, color)
			uncastle(board, color, 'right')
			return checked
		when 'castle left'
			castle(board, color, 'left')
			checked = check?(board, color)
			uncastle(board, color, 'left')
			return checked			
		when 'en passant left'
			en_passant(board, color, @last_move, 'left')
			checked = check?(board, color)
			undo_en_passant(board, color, @last_move, 'left')
			return checked	
		when 'en passant right'
			en_passant(board, color, @last_move, 'left')
			checked = check?(board, color)
			undo_en_passant(board, color, @last_move, 'left')
			return checked				
		else
			#Temporarily alter the board to check for check
			origin_content = board[origin[0]][origin[1]]
			destination_content = board[destination[0]][destination[1]]

			origin_has_moved = board[origin[0]][origin[1]].moved if origin_content != nil
			destination_has_moved = board[destination[0]][destination[1]].moved if destination_content != nil
			
			move_piece(board, color, origin, destination)
			checked = check?(board, color)

			#restore the board to previous state
			board[origin[0]][origin[1]] = origin_content
			board[destination[0]][destination[1]] = destination_content

			board[origin[0]][origin[1]].moved = origin_has_moved if origin_content != nil
			board[destination[0]][destination[1]] = destination_has_moved if destination_content != nil
			checked ? true : false
		end
	end

# Function that promotes a pawn based on the users choice
	def promotion(board, destination)
		puts "Please choose a piece to replace your pawn:"
		promotion_choice = gets.chomp
		while !@@PROMOTION_CHOICES.include?(promotion_choice.downcase)
			puts "Invalid choice. Please enter the piece you would like to promote your pawn to."
			promotion_choice = gets.chomp
		end
		case promotion_choice.downcase
		when "queen"
			board[destination[0]][destination[1]] = Queen.new(board[destination[0]][destination[1]].color)
		when "knight"
			board[destination[0]][destination[1]] = Knight.new(board[destination[0]][destination[1]].color)
		when "rook"
			board[destination[0]][destination[1]] = Rook.new(board[destination[0]][destination[1]].color)
		when "bishop"
			board[destination[0]][destination[1]] = Bishop.new(board[destination[0]][destination[1]].color)
		else
			puts "Error in promotion function"
		end
	end

	# Function that receives a board state and returns true if an en passant move can be made
	def can_en_passant?(board, color, last_move, direction)
		prev_origin = [(last_move[1].to_i)-1, @@LETTER_MAPPING[last_move[0]]]
		prev_destination = [(last_move[4].to_i)-1, @@LETTER_MAPPING[last_move[3]]]
		direction_index = direction == 'left' ? -1 : 1

		if color == 'white'
			# If last move was a two step move by an opposing pawn
			if board[prev_destination[0]][prev_destination[1]].class.to_s == "Pawn" && prev_origin[1] == 6 && prev_destination[1] == 4
				#If the user has a pawn in position to do en passant, checks both sides
				return true if board[prev_destination[0]+direction_index][prev_destination[1]].is_a?(Pawn) && board[prev_destination[0]+direction_index][prev_destination[1]].color == color
			end
		else
			# If last move was a two step move by an opposing pawn
			if board[prev_destination[0]][prev_destination[1]].class.to_s == "Pawn" && prev_origin[1] == 1 && prev_destination[1] == 3
				#If the user has a pawn in position to do en passant, checks both sides
				return true if board[prev_destination[0]+direction_index][prev_destination[1]].is_a?(Pawn) && board[prev_destination[0]+direction_index][prev_destination[1]].color == color
			end		
		end

		return false
	end

	# Function to perform an en passant move to the chess board
	def en_passant(board, color, last_move, direction)
		prev_origin = [(last_move[1].to_i)-1, @@LETTER_MAPPING[last_move[0]]]
		prev_destination = [(last_move[4].to_i)-1, @@LETTER_MAPPING[last_move[3]]]	

		direction_index = color == 'white' ? 1 : -1

		if direction == 'left'
			move_piece(board, color, [prev_destination[0]-1, prev_destination[1]], [prev_destination[0], prev_destination[1] + direction_index]) 
			board[prev_destination[0]][prev_destination[1]] = nil
		else
			move_piece(board, color, [prev_destination[0]+1, prev_destination[1]], [prev_destination[0], prev_destination[1] + direction_index]) 
			board[prev_destination[0]][prev_destination[1]] = nil
		end
	end

	def undo_en_passant(board, color, last_move, direction)
		prev_origin = [(last_move[1].to_i)-1, @@LETTER_MAPPING[last_move[0]]]
		prev_destination = [(last_move[4].to_i)-1, @@LETTER_MAPPING[last_move[3]]]	

		direction_index = color == 'white' ? 1 : -1
		opponent_color = color == 'white' ? 'black' : 'white'

		if direction == 'left'
			move_piece(board, color, [prev_destination[0], prev_destination[1] + direction_index], [prev_destination[0]-1, prev_destination[1]]) 
			board[prev_destination[0]][prev_destination[1]] = Pawn.new(opponent_color)
		else
			move_piece(board, color, [prev_destination[0], prev_destination[1] + direction_index], [prev_destination[0]+1, prev_destination[1]]) 
			board[prev_destination[0]][prev_destination[1]] = Pawn.new(opponent_color)
		end
	end

	# Function that checks a castling move is available for the argument color and direction 
	def can_castle?(board, color, direction)
		return false if check?(board, color)

		if color == 'white'
			return false if board[4][0].moved == true

			if direction == 'left'
				return false if board[0][0].moved == true
				return false if check_space(board, [1,0]) != "empty" || check_space(board, [2,0]) != "empty" || check_space(board, [3,0]) != "empty"
				return false if color_checked_after_move?(board, color, nil, nil, 'castle left')
			else
				return false if board[7][0].moved == true
				return false if check_space(board, [5,0]) != "empty" || check_space(board, [6,0]) != "empty"
				return false if color_checked_after_move?(board, color, nil, nil, 'castle right')
			end
		else
			return false if board[4][7].moved == true

			if direction == 'left'
				return false if board[0][7].moved == true
				return false if check_space(board, [1,7]) != "empty" || check_space(board, [2,7]) != "empty" || check_space(board, [3,7]) != "empty"
				return false if color_checked_after_move?(board, color, nil, nil, 'castle left')
			else
				return false if board[7][7].moved == true
				return false if check_space(board, [5,7]) != "empty" || check_space(board, [6,7]) != "empty"
				return false if color_checked_after_move?(board, color, nil, nil, 'castle right')
			end
		end
		return true
	end

	# Function that performs a castle movement
	def castle(board, color, direction)
		if color == 'white'
			if direction == 'left'
				move_piece(board, color, [4,0], [2,0])
				move_piece(board, color, [0,0], [3,0])
			else
				move_piece(board, color, [4,0], [6,0])
				move_piece(board, color, [7,0], [5,0])	
			end
		else
			if direction == 'left'
				move_piece(board, color, [4,7], [2,7])
				move_piece(board, color, [0,7], [3,7])
			else
				move_piece(board, color, [4,7], [6,7])
				move_piece(board, color, [7,7], [5,7])	
			end
		end
	end

	# Function that undoes a castle movement
	def uncastle(board, color, direction)
		if color == 'white'
			if direction == 'left'
				move_piece(board, color, [2,0], [4,0])
				move_piece(board, color, [3,0], [0,0])
				board[4][0].moved = false
				board[0][0].moved = false
			else
				move_piece(board, color, [6,0], [4,0])
				move_piece(board, color, [5,0], [7,0])	
				board[4][0].moved = false
				board[7][0].moved = false
			end
		else
			if direction == 'left'
				move_piece(board, color, [2,7], [4,7])
				move_piece(board, color, [3,7], [0,7])
				board[4][7].moved = false
				board[0][7].moved = false
			else
				move_piece(board, color, [6,7], [4,7])
				move_piece(board, color, [5,7], [7,7])	
				board[4][7].moved = false
				board[7][7].moved = false
			end
		end
	end

# Function to play the game, ends when checkmate
	def play		
		puts "Please type a move in the format G1 E1, 'castle' to castle and 'en passant' to perform en passant"

		until checkmate?(@chess_board, @current_turn)
			puts "Check" if check?(@chess_board, @current_turn)
				
			invalid_move = true
			puts "#{@current_turn.capitalize}'s turn!"
			while invalid_move == true
				input = gets.chomp.upcase

				if input == "CASTLE" 
					puts "Please enter a direction to castle (left or right):"
					direction = gets.chomp 

					until direction == 'left' || direction == 'right'
						puts "Please enter a valid direction:"
						direction = gets.chomp
					end

					if can_castle?(@chess_board, @current_turn, direction)
						castle(@chess_board, @current_turn, direction)
						@last_move = "castle"
						invalid_move = false
					else
						puts "Cannot castle to the #{direction}."
						puts "Please enter a valid move:"
						invalid_move = true
					end

				elsif input == "EN PASSANT"
					left_passant = can_en_passant?(@chess_board, @current_turn, @last_move, "left")
					right_passant = can_en_passant?(@chess_board, @current_turn, @last_move, "right")

					if left_passant && right_passant
						puts "Please type 'left' or 'right' for the pawn you would like to en passant with."
						passant_direction = gets.chomp.downcase

						until passant_direction == 'left' || passant_direction == 'right'
							puts "Invalid direction. Please choose left or right."
							passant_direction = gets.chomp
						end

						en_passant(@chess_board, @current_turn, @last_move, passant_direction)
						@last_move = "en passant"
						invalid_move = false						
					elsif left_passant
						en_passant(@chess_board, @current_turn, @last_move, 'left')
						@last_move = "en passant"
						invalid_move = false						
					elsif right_passant
						en_passant(@chess_board, @current_turn, @last_move, 'right')
						@last_move = "en passant"
						invalid_move = false						
					else
						puts "Cannot perform en passant, please enter a different move"
					end

				else
					origin = [(input[1].to_i)-1, @@LETTER_MAPPING[input[0]]]
					destination = [(input[4].to_i)-1, @@LETTER_MAPPING[input[3]]]

					if valid_piece(origin, @current_turn) == false
						puts "You do not have a piece at #{@@LETTER_MAPPING.key(origin[1])}#{origin[0]+1}"
						puts "Please enter a valid move:"
						invalid_move = true
					elsif !potential_moves(@chess_board, [origin[0], origin[1]], @chess_board[origin[0]][origin[1]].color).include?(destination)
						puts "The #{@chess_board[origin[0]][origin[1]].class} at #{@@LETTER_MAPPING.key(origin[1])}#{origin[0]+1} cannot be moved to #{@@LETTER_MAPPING.key(destination[1])}#{destination[0]+1}"
						puts "Please enter a valid move:"
						invalid_move = true
					elsif color_checked_after_move?(@chess_board, @current_turn, origin, destination)
						puts "This move will leave your king vulnerable."
						puts "Please enter a valid move:"
						invalid_move = true
					else
						move_piece(@chess_board, @current_turn, origin, destination)
						@last_move = "#{@@LETTER_MAPPING.key(origin[1])}#{origin[0]+1} #{@@LETTER_MAPPING.key(destination[1])}#{destination[0]+1}"
						if @chess_board[destination[0]][destination[1]].is_a?(Pawn) && (destination[1] == 7 || destination[1] == 0)
							promotion(@chess_board, destination)
						end
						invalid_move = false
					end
				end
			end
			
			@current_turn = @current_turn == 'white' ? 'black' : 'white'
			system "clear" or system "cls"
			display_board
			puts "Last move was: #{@last_move}"
		end
		winning_player = @current_turn == 'white' ? 'black' : 'white'
		puts "Checkmate! #{winning_player.capitalize} wins!"
	end
end

ChessTestBoard = Board.new
ChessTestBoard.play