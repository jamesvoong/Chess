require_relative "../lib/board"

describe Board do 
	let(:board) {Board.new}

	describe "#valid_piece" do
		context "Square contains opponent piece" do
			before do
				board.create_piece("Pawn", 0, 0, "white", true)
			end

			it "returns true if current player is white" do
				expect(board.valid_piece([0, 0], "white")).to be true
			end
		end
	end

	describe "#check_space" do
		context "Square contains opponent piece" do
			before do
				board.create_piece("Pawn", 0, 0, "white", true)
			end

			it "returns the correct color of the piece" do
				expect(board.check_space(board.chess_board, [0, 0])).to eq('white')
			end
		end

		context "Square does not contain anything" do
			it "returns empty if the space does not contain a space" do
				expect(board.check_space(board.chess_board, [0, 0])).to eq('empty')
			end
		end
	end

	describe "#space_contains_king?" do
		context "King is located at [4,4]" do
			before do
				board.create_piece("King", 4, 4, "white", true)
			end

			it "returns true on checking [4,4] for white king" do
				expect(board.space_contains_king?(board.chess_board, [4, 4], 'white')).to be true
			end

			it "returns false on checking [4,4] for black king" do
				expect(board.space_contains_king?(board.chess_board, [4, 4], 'black')).to be false
			end

			it "returns false on for a space that does not contain the king" do
				expect(board.space_contains_king?(board.chess_board, [0, 0], 'white')).to be false
			end						
		end
	end

	describe "#out_of_bounds?" do
		context "[0,0] to [7,7] is correctly identified as in bounds" do
			it "returns false on checking [4,4]" do
				expect(board.out_of_bounds?([4, 4])).to be false
			end

			it "identifies negative numbers are OOB" do
				expect(board.out_of_bounds?([-1, 4])).to be true
			end

			it "identifies 7 is largest number inside the board" do
				expect(board.out_of_bounds?([4, 8])).to be true
			end			
		end		
	end

	describe "#potential_moves" do
		context "Rook is surrounded" do
			before do
				board.create_piece("Pawn", 0, 1, "white", true)
				board.create_piece("Rook", 0, 0, "white", true)
				board.create_piece("Knight", 1, 0, "white", true)
			end		

			it "returns no moves" do
				moves_list = board.potential_moves(board.chess_board, [0,0], "white")
				expect(moves_list).to eq([])
			end
		end

		context "Rook has space" do
			before do
				board.create_piece("Pawn", 0, 3, "white", true)
				board.create_piece("Rook", 0, 0, "white", true)
				board.create_piece("Knight", 3, 0, "white", true)
			end		

			it "returns a few moves" do
				moves_list = board.potential_moves(board.chess_board, [0,0], "white")
				expect(moves_list.include?([0,1])).to be true
				expect(moves_list.include?([0,2])).to be true
				expect(moves_list.include?([1,0])).to be true
				expect(moves_list.include?([2,0])).to be true
			end
		end

		context "Bishop can move a diagonal" do
			before do
				board.create_piece("Bishop", 0, 0, "white", true)
				board.create_piece("Rook", 5, 0, "white", true)
				board.create_piece("Knight", 4, 4, "white", true)
			end				

			it "returns a few moves" do
				moves_list = board.potential_moves(board.chess_board, [0,0], "white")
				expect(moves_list.include?([1,1])).to be true
				expect(moves_list.include?([2,2])).to be true
				expect(moves_list.include?([3,3])).to be true
				expect(moves_list.include?([4,4])).to be false
			end			
		end

		context "Knight can move anywhere" do
			before do
				board.create_piece("Knight", 4, 4, "white", true)
			end				

			it "returns a few moves" do
				moves_list = board.potential_moves(board.chess_board, [4,4], "white")
				expect(moves_list.include?([5,6])).to be true
				expect(moves_list.include?([5,2])).to be true
				expect(moves_list.include?([3,6])).to be true
				expect(moves_list.include?([3,2])).to be true
				expect(moves_list.include?([6,5])).to be true
				expect(moves_list.include?([6,3])).to be true
				expect(moves_list.include?([2,5])).to be true
				expect(moves_list.include?([2,3])).to be true
				expect(moves_list.include?([5,5])).to be false
				expect(moves_list.include?([5,-8])).to be false
				expect(moves_list.include?([6,6])).to be false
				expect(moves_list.include?([-5,-6])).to be false				
			end				
		end

		context "Queen has space to move in any direction" do
			before do
				board.create_piece("Pawn", 0, 3, "white", true)
				board.create_piece("Queen", 0, 0, "white", true)
				board.create_piece("Knight", 3, 0, "white", true)
				board.create_piece("Knight", 4, 4, "white", true)
			end		

			it "returns a list of moves" do
				moves_list = board.potential_moves(board.chess_board, [0,0], "white")
				expect(moves_list.include?([1,1])).to be true
				expect(moves_list.include?([2,2])).to be true
				expect(moves_list.include?([3,3])).to be true					
				expect(moves_list.include?([0,1])).to be true
				expect(moves_list.include?([0,2])).to be true
				expect(moves_list.include?([1,0])).to be true
				expect(moves_list.include?([2,0])).to be true			
			end
		end

		context "King has space to move in any direction" do
			before do
				board.create_piece("King", 4, 4, "black", true)
			end

			it "returns an array of 8 arrays" do
				moves_list = board.potential_moves(board.chess_board, [4,4], "black")
				expect(moves_list.include?([4,3])).to be true
				expect(moves_list.include?([4,5])).to be true
				expect(moves_list.include?([3,3])).to be true					
				expect(moves_list.include?([3,4])).to be true
				expect(moves_list.include?([3,5])).to be true
				expect(moves_list.include?([5,3])).to be true
				expect(moves_list.include?([5,4])).to be true
				expect(moves_list.include?([5,5])).to be true	
			end
		end

		context "Pawn that has not moved" do
			before do
				board.create_piece("Pawn", 0, 6, "black", false)
			end

			it "returns an array of 2 arrays" do
				moves_list = board.potential_moves(board.chess_board, [0,6], "black")
				expect(moves_list.include?([0,5])).to be true
				expect(moves_list.include?([0,4])).to be true	
			end			
		end

		context "Pawn that can take a piece" do
			before do
				board.create_piece("Pawn", 0, 6, "black", false)
				board.create_piece("Pawn", 1, 5, "white", true)
			end

			it "returns an array of 3 arrays" do
				moves_list = board.potential_moves(board.chess_board, [0,6], "black")
				expect(moves_list.include?([0,5])).to be true
				expect(moves_list.include?([0,4])).to be true
				expect(moves_list.include?([1,5])).to be true		
			end				
		end
	end		

	describe "#check?" do
		context "Start of game" do
			before do
				board.create_board
			end			

			it "returns false for start of game scenario" do
				expect(board.check?(board.chess_board, "white")).to be false
			end
		end

		context "Knight moves to cause check" do
			before do
				board.create_piece("King", 4, 4, "white", true)
				board.create_piece("Knight", 5, 6, "black", true)
			end

			it "returns true if knight is in position to check" do
				expect(board.check?(board.chess_board, "white")).to be true
			end
		end

		context "Bishop moves to cause check" do
			before do
				board.create_piece("King", 4, 4, "white", true)
				board.create_piece("Bishop", 7, 7, "black", true)
			end

			it "returns true if bishop is in position to check" do
				expect(board.check?(board.chess_board, "white")).to be true
			end			
		end

		context "Queen moves to cause check" do
			before do
				board.create_piece("King", 4, 4, "white", true)
				board.create_piece("Queen", 7, 7, "black", true)
			end

			it "returns true if queen is in position to check" do
				expect(board.check?(board.chess_board, "white")).to be true
			end					
		end

		context "Rook moves to cause check" do
			before do
				board.create_piece("King", 4, 4, "white", true)
				board.create_piece("Rook", 4, 0, "black", true)
			end

			it "returns true if rook is in position to check" do
				expect(board.check?(board.chess_board, "white")).to be true
			end				
		end

		context "Pawn moves to cause check" do
			before do
				board.create_piece("King", 4, 4, "white", true)
				board.create_piece("Pawn", 5, 5, "black", true)
			end

			it "returns true if pawn is in position to check" do
				expect(board.check?(board.chess_board, "white")).to be true
			end	
		end				
	end

	describe "#game_over" do
		context "Checkmate" do
			before do
				board.create_piece("King", 0, 0, "white", true)
				board.create_piece("Rook", 7, 0, "black", true)
				board.create_piece("Rook", 7, 1, "black", true)
				board.last_move = "A8 H8"
			end

			it "returns checkmate string if checkmate" do
				expect(board.game_over(board.chess_board, "white")).to eq("Checkmate! Black wins!")
			end	
		end		

		context "Stalemate" do
			before do
				board.create_piece("King", 4, 0, "white", true)
				board.create_piece("Rook", 3, 3, "black", true)
				board.create_piece("Rook", 5, 5, "black", true)
				board.create_piece("Queen", 0, 1, "black", true)
				board.last_move = "A1 B1"
			end

			it "returns stalemate string if board is at stalemate" do
				expect(board.game_over(board.chess_board, "white")).to eq("Draw by Stalemate!")
			end	
		end		

		context "Only kings remaining" do
			before do
				board.create_piece("King", 4, 4, "white", true)
				board.create_piece("King", 6, 6, "black", true)
				board.last_move = "G8 G7"
			end

			it "returns draw string if there are only kings remaining" do
				expect(board.game_over(board.chess_board, "white")).to eq("Draw as there are not enough pieces on the board to end the game.")
			end	
		end	

		context "King and bishop against a king" do
			before do
				board.create_piece("King", 4, 4, "white", true)
				board.create_piece("Bishop", 0, 0, "white", true)
				board.create_piece("King", 6, 6, "black", true)
				board.last_move = "G8 G7"
			end

			it "returns draw string" do
				expect(board.game_over(board.chess_board, "white")).to eq("Draw as there are not enough pieces on the board to end the game.")
			end	
		end	

		context "King and knight against king and bishop" do
			before do
				board.create_piece("King", 4, 4, "white", true)
				board.create_piece("Knight", 0, 0, "white", true)
				board.create_piece("King", 6, 6, "black", true)
				board.create_piece("Bishop", 6, 7, "black", true)
				board.last_move = "G8 G7"
			end

			it "returns draw string" do
				expect(board.game_over(board.chess_board, "black")).to eq("Draw as there are not enough pieces on the board to end the game.")
			end	
		end		

		context "Knight and two knights against king and bishop" do
			before do
				board.create_piece("King", 4, 4, "white", true)
				board.create_piece("Knight", 5, 5, "white", true)
				board.create_piece("Knight", 1, 3, "white", true)
				board.create_piece("Bishop", 0, 0, "black", true)
				board.create_piece("King", 6, 6, "black", true)
				board.last_move = "G8 G7"
			end

			it "returns draw string" do
				expect(board.game_over(board.chess_board, "black")).to eq("Draw as there are not enough pieces on the board to end the game.")
			end	
		end													

		context "Queen and king against king" do
			before do
				board.create_piece("King", 4, 4, "white", true)
				board.create_piece("Queen", 0, 0, "white", true)
				board.create_piece("King", 6, 6, "black", true)
				board.last_move = "G8 G7"
			end

			it "returns false" do
				expect(board.game_over(board.chess_board, "white")).to be false
			end	
		end	
	end

	describe "#move_piece" do
		context "Move into empty space" do
			before do
				board.create_piece("King", 4, 4, "white", true)
				board.move_piece(board.chess_board, "white", [4,4], [5,5])
			end

			it "has moved the King into the empty space at 5,5" do
				expect(board.chess_board[5][5].is_a?(King)).to be true
			end
		end		

		context "Move to take a piece" do
			before do
				board.create_piece("King", 1, 7, "white", true)
				board.create_piece("Knight", 2, 7, "black", true)
				board.move_piece(board.chess_board, "white", [1,7], [2,7])
			end

			it "has moved the King into the empty space at 5,5" do
				expect(board.chess_board[2][7].is_a?(King)).to be true
			end		
		end
	end

	describe "#color_checked_after_move?" do
		context "Move into knight potential move" do
			before do
				board.create_piece("King", 1, 7, "white", true)
				board.create_piece("Knight", 3, 5, "black", true)
			end

			it "returns true" do
				expect(board.color_checked_after_move?(board.chess_board, "white", [1,7], [2,7])).to be true
			end
		end

		context "Move into bishop potential move" do
			before do
				board.create_piece("King", 0, 1, "white", true)
				board.create_piece("Bishop", 7, 7, "black", true)
			end			

			it "returns true" do
				expect(board.color_checked_after_move?(board.chess_board, "white", [0,1], [0,0])).to be true
			end		
		end

		context "Move into rook potential move" do
			before do
				board.create_piece("King", 0, 1, "white", true)
				board.create_piece("Rook", 2, 2, "black", true)
			end	

			it "returns true" do
				expect(board.color_checked_after_move?(board.chess_board, "white", [0,1], [0,2])).to be true
			end				
		end

		context "Move into queen potential move" do
			before do
				board.create_piece("King", 0, 1, "white", true)
				board.create_piece("Queen", 2, 2, "black", true)
			end	

			it "returns true" do
				expect(board.color_checked_after_move?(board.chess_board, "white", [0,1], [0,2])).to be true
			end				
		end

		context "Move into pawn potential move" do
			before do
				board.create_piece("King", 2, 4, "white", true)
				board.create_piece("Pawn", 4, 5, "black", true)
			end	

			it "returns true" do
				expect(board.color_checked_after_move?(board.chess_board, "white", [2,4], [3,4])).to be true
			end				
		end

		context "Move bishop that was blocking king from a rook" do
			before do
				board.create_piece("King", 0, 0, "white", true)
				board.create_piece("Bishop", 0, 1, "white", true)
				board.create_piece("Rook", 0, 7, "black", true)
			end	

			it "returns true" do
				expect(board.color_checked_after_move?(board.chess_board, "white", [0,1], [1,2])).to be true
			end				
		end
	end

	describe "#can_en_passant?" do
		context "Able to en passant to the right" do
			before do
				board.create_piece("Pawn", 4, 4, "white", true)
				board.create_piece("Pawn", 5, 4, "black", true)
				board.last_move = "B6 D6"
			end				

			it "returns true" do
				expect(board.can_en_passant?(board.chess_board, "white", board.last_move, "right")).to be true
			end
		end

		context "Able to en passant to the left" do
			before do
				board.create_piece("Pawn", 4, 4, "white", true)
				board.create_piece("Pawn", 3, 4, "black", true)
				board.last_move = "B4 D4"
			end				

			it "returns true" do
				expect(board.can_en_passant?(board.chess_board, "white", board.last_move, 'left')).to be true
			end			
		end

		context "Pawns are in position but the last turn was not the two step pawn move" do
			before do
				board.create_piece("Pawn", 4, 4, "white", true)
				board.create_piece("Pawn", 3, 4, "black", true)
				board.create_piece("Pawn", 0, 4, "black", true)
				board.last_move = "B0 D0"
			end				

			it "returns false" do
				expect(board.can_en_passant?(board.chess_board, "white", board.last_move, 'left')).to be false
			end		
		end	
	end

	describe "#en_passant" do
		context "Correctly en passants to the left" do
			before do
				board.create_piece("Pawn", 4, 4, "white", true)
				board.create_piece("Pawn", 3, 4, "black", true)
				board.last_move = "B4 D4"
				board.en_passant(board.chess_board, "white", board.last_move, "left")
			end				

			it "returns true" do
				expect(board.chess_board[3][5].is_a?(Pawn)).to be true
			end		
		end

		context "Correctly en passants to the right" do
			before do
				board.create_piece("Pawn", 4, 4, "white", true)
				board.create_piece("Pawn", 5, 4, "black", true)
				board.last_move = "B6 D6"
				board.en_passant(board.chess_board, "white", board.last_move, 'right')
			end				

			it "returns true" do
				expect(board.chess_board[5][5].is_a?(Pawn)).to be true
			end					
		end
	end

	describe "#undo_en_passant" do
		context "Undoes en passant to the right" do
			before do
				board.create_piece("Pawn", 4, 4, "white", true)
				board.create_piece("Pawn", 5, 4, "black", true)
				board.last_move = "B6 D6"
				board.en_passant(board.chess_board, "white", board.last_move, 'right')
				board.undo_en_passant(board.chess_board, "white", board.last_move, 'right')
			end				

			it "returns true" do
				expect(board.chess_board[4][4].is_a?(Pawn)).to be true
				expect(board.chess_board[5][4].is_a?(Pawn)).to be true
			end							
		end

		context "Undoes en passant to the left" do
			before do
				board.create_piece("Pawn", 4, 4, "white", true)
				board.create_piece("Pawn", 3, 4, "black", true)
				board.last_move = "B4 D4"
				board.en_passant(board.chess_board, "white", board.last_move, "left")
				board.undo_en_passant(board.chess_board, "white", board.last_move, "left")
			end

			it "returns true" do
				expect(board.chess_board[4][4].is_a?(Pawn)).to be true
				expect(board.chess_board[3][4].is_a?(Pawn)).to be true
			end						
		end
	end

	describe "#can_castle?" do
		context "King has already moved and moved back" do
			before do
				board.create_piece("King", 4, 0, "white", true)
				board.create_piece("Rook", 0, 0, "white", false)
			end		

			it "returns false" do
				expect(board.can_castle?(board.chess_board, 'white', 'left')).to be false
			end
		end

		context "Rook has already moved" do
			before do
				board.create_piece("King", 4, 0, "white", false)
				board.create_piece("Rook", 0, 4, "white", true)
			end		

			it "returns false" do
				expect(board.can_castle?(board.chess_board, 'white', 'left')).to be false
			end		
		end

		context "Castle to the left" do
			before do
				board.create_piece("King", 4, 0, "white", false)
				board.create_piece("Rook", 0, 0, "white", false)
			end		

			it "returns true" do
				expect(board.can_castle?(board.chess_board, 'white', 'left')).to be true
			end				
		end

		context "Castle to the right" do
			before do
				board.create_piece("King", 4, 0, "white", false)
				board.create_piece("Rook", 7, 0, "white", false)
			end		

			it "returns true" do
				expect(board.can_castle?(board.chess_board, 'white', 'right')).to be true
			end				
		end

		context "There are pieces between the Rook and King" do
			before do
				board.create_piece("King", 4, 0, "white", false)
				board.create_piece("Knight", 6, 0, "white", true)
				board.create_piece("Rook", 7, 0, "white", false)
			end		

			it "returns false" do
				expect(board.can_castle?(board.chess_board, 'white', 'right')).to be false
			end					
		end

	end

	describe "#castle" do
		context "Castle to the left" do
			before do
				board.create_piece("King", 4, 0, "white", false)
				board.create_piece("Rook", 0, 0, "white", false)
				board.castle(board.chess_board, 'white', 'left')
			end		

			it "returns true" do
				expect(board.chess_board[2][0].is_a?(King)).to be true
				expect(board.chess_board[3][0].is_a?(Rook)).to be true
			end				
		end

		context "Castle to the right" do
			before do
				board.create_piece("King", 4, 0, "white", false)
				board.create_piece("Rook", 7, 0, "white", false)
				board.castle(board.chess_board, 'white', 'right')
			end		

			it "returns true" do
				expect(board.chess_board[6][0].is_a?(King)).to be true
				expect(board.chess_board[5][0].is_a?(Rook)).to be true
			end				
		end
	end

end