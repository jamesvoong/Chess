class Piece
    attr_accessor :color, :moved, :movements, :unicode
	
	def initialize(color)
		@color = color
		@moved = false
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
		@movements = [[1,1], [1,-1], [-1,1], [-1,-1], [1,0], [-1,0], [0,1], [0,-1]]
	end	
end

class Rook < Piece
	def initialize(color)
		super(color)
		@unicode = color == 'white' ? "\u2656" : "\u265C"
		@movements = [[1,0], [-1,0], [0,1], [0,-1]]
	end	
end

class Bishop < Piece
	def initialize(color)
		super(color)
		@unicode = color == 'white' ? "\u2657" : "\u265D"
		@movements = [[1,1], [1,-1], [-1,1], [-1,-1]]
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