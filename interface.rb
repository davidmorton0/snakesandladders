class Counter < Circle
 	attr_accessor :moving, :last_pos_x, :last_pos_y, :new_pos_x, :new_pos_y	
end
=begin
  	def initialize()
  		@last_pos_x = 0
  		@last_pos_y = 0
  		@new_pos_x = nil
  		@new_pos_y = nil
  		@moving = 0
  	end
=end

class GameBoard
  	attr_reader :border
  	attr_reader :board_border
  	attr_reader :board_border_colour
  	attr_reader :width
  	attr_reader :height
  	attr_reader :buttons
  	attr_reader :button_gap
  	attr_reader :counters, :player_colours
  	attr_reader :labels
  	attr_reader :image_border
  	attr_reader :square_width, :square_height

	def initialize(players)
		@border = 50
		@board_border = 5
		@board_border_colour = 'black'
		@width = 700
		@height = 700
		@buttons = []
		@button_gap = 5
		@counters = []
		@player_colours = ['black', 'green']
		@labels = []
		Image.new(
			'snakesandladdersboard.jpg',
			x: border, y: border,
			width: width, height: width,
			colour: [1.0, 1.0, 1.0, 1.0],
			z: 100
			)
		@image_border = 4
		@square_width = (width - 2 * image_border) / 10
		@square_height = (height - 2 * image_border) / 10
		make_border()
		add_button("New Game")
		add_button("Go")
		add_button("Dice")
		players.times { |p| add_counter(p) }
	end

	def board_space_position_x(board_space)
		if (board_space - 1) % 20 == (board_space - 1) % 10
			x = border + image_border + (board_space - 1) % 10 * square_width
		else
			x = border + width - image_border - (board_space % 10 == 0 ? 10 : board_space % 10) * square_width
		end
	end

	def board_space_position_y(board_space)
		y = border + height - image_border - (board_space - 1) / 10 * square_height
	end

	def make_border()
		Rectangle.new(
			x: border - board_border, y: border - board_border,
			width: width + board_border * 2,
			height: height + board_border * 2,
			color: board_border_colour,
			z: 1
			)
	end

	def add_button(text)
		# add button
		buttons << Rectangle.new(
			x: border + buttons.size * (width / 5 + button_gap),
			y: height + border + board_border + button_gap,
			width: width / 5,
			height: height / 20,
			color: 'yellow'
			)
		labels << Text.new(
			text,
			x: @buttons[-1].x + @buttons[-1].width / 8,
			y: @buttons[-1].y + @buttons[-1].height / 4,
			size: @buttons[-1].height / 2,
			color: 'black'
			)
	end

	def show_dice(a)
		labels[2].text = "Rolled: #{a.join(", ")}"
	end

	def add_counter(player)
		counters << Counter.new(
  			radius: 12,
  			sectors: 5,
  			color: player_colours[player],
  			z: 200
			)
		update(counters.size - 1, 0)		
	end

	def update(player, pos)
		labels[1].text = "Player #{2 - player}: Go"
		if pos == 0
			counters[player].x = board_space_position_x(1) - (player + 1) * square_width / 3
			counters[player].y = board_space_position_y(1) - (player + 1) * square_height / 3
		else
			counters[player].x = board_space_position_x(pos) + (player + 1) * square_width / 3
			counters[player].y = board_space_position_y(pos) - (player + 1) * square_height / 3
=begin
			counters[player].last_pos_x = counters[player].x
			counters[player].last_pos_y = counters[player].y
			counters[player].new_pos_x = board_space_position_x(pos) + (player + 1) * square_width / 3
			counters[player].new_pos_y = board_space_position_y(pos) - (player + 1) * square_height / 3
			counters[player].moving == 100
=end
		end
	end

	def move_counter(players)
		(0..players - 1).each do |p|
			puts p
			puts counters[p].x
			if counters[p].moving > 0
				counters[p].moving -= 1
				counters[p].x = counters[p].new_pos_x - (counters[p].last_pos_x - counters[p].new_pos_x) * 100 / counters[p].moving
				counters[p].y = counters[p].new_pos_y - (counters[p].last_pos_y - counters[p].new_pos_y) * 100 / counters[p].moving
			end
		end
	end
end