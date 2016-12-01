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
	end		

	describe "#check?" do
	end

	describe "#game_over" do
	end

	describe "#insufficient_pieces" do
	end

	describe "#can_move?" do
	end

	describe "#move_piece" do		
	end

	describe "#color_checked_after_move?" do
	end

	describe "#promotion" do
	end

	describe "#can_en_passant?" do
		
	end

	describe "#en_passant" do
	end

	describe "#undo_en_passant" do
	end

	describe "#can_castle" do
	end

	describe "#castle" do
	end

	describe "#uncastle" do
	end	
end