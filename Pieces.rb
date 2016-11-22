class Piece
	attr_accessor :unicode, :color, :movements

	def initialize(color)
		@color = color
	end
end

class King < Piece
	def initialize(color)
		super(color)
		@unicode = color == 'white' ? "\u2654" : "\u265A"
		@movements = [[1,0], [1,1], [0,1], [-1,1], [-1,0], [-1,-1], [0,-1], [1,-1]]
	end
end

class Queen < Piece
	def initialize(color)
		super(color)
		@unicode = color == 'white' ? "\u2655" : "\u265B"
	end	
end

class Rook < Piece
	def initialize(color)
		super(color)
		@unicode = color == 'white' ? "\u2656" : "\u265C"
	end	
end

class Bishop < Piece
	def initialize(color)
		super(color)
		@unicode = color == 'white' ? "\u2657" : "\u265D"
	end	
end

class Knight < Piece
	def initialize(color)
		super(color)
		@unicode = color == 'white' ? "\u2658" : "\u265E"
		@movements = [[1,2], [1,-2], [-1,2], [-1,-2], [2,1], [2,-1], [-2,1], [-2,-1]]
	end	
end

class Pawn < Piece
	def initialize(color)
		super(color)
		@unicode = color == 'white' ? "\u2659" : "\u265F"
	end	
end