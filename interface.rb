class Counter < Circle
 	attr_accessor :moving, :speed, :last_pos_x, :last_pos_y, :new_pos_x, :new_pos_y, :destinations
end

class GameBoard
  	attr_reader :width, :height, :border, :board_border, :board_border_colour, :image_border, :square_width, :square_height
  	attr_reader :players
  	attr_accessor :buttons, :button_gap, :counters, :player_colours, :labels
  	attr_accessor :message, :moving_counters

	def initialize(players)
		@border = 50
		@board_border = 5
		@board_border_colour = 'black'
		@width = 700
		@height = 700
		@button_gap = 5
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

		#add buttons and labels
		@buttons = []
		@labels = []
		add_button("New Game")
		add_button("Go")
		add_button("Dice")

		@players = players
		@counters = []
		@player_colours = ['black', 'green']
		max_players = 2
		raise GameBoardError, "Too many players.  Maximum is #{max_players}" if players > max_players
		raise GameBoardError, "Can't have less than 0 players" if players < 0
		players.times { |p| add_counter(p) }
		
		self.moving_counters = false
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

	def add_counter(player)
		counters << Counter.new(
  			radius: 12,
  			sectors: 5,
  			color: player_colours[player],
  			z: 200
			)
		self.counters[-1].moving = 0
		self.counters[-1].destinations = []
	end

	def board_position(player, pos)
		if pos == 0
			[ board_space_position_x(1) - (player + 1) * square_width / 3, board_space_position_y(1) - (player + 1) * square_height / 3 ]
		else
			[ board_space_position_x(pos) + (player + 1) * square_width / 3, board_space_position_y(pos) - (player + 1) * square_height / 3 ]
		end
	end

	def board_space_position_x(board_space)
		if (board_space - 1) % 20 == (board_space - 1) % 10
			border + image_border + (board_space - 1) % 10 * square_width
		else
			border + width - image_border - (board_space % 10 == 0 ? 10 : board_space % 10) * square_width
		end
	end

	def board_space_position_y(board_space)
		border + height - image_border - (board_space - 1) / 10 * square_height
	end

	def change_message(new_message)
		self.message.remove if not message.nil?
		self.message = Text.new(new_message, x: 200, y: 20)
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

	def move_counter(players)
		moving = false
		(0..players - 1).each do |p|
			if counters[p].moving > 0
				counters[p].moving -= 5
				counters[p].x = (counters[p].new_pos_x * (counters[p].speed - counters[p].moving) + counters[p].last_pos_x * counters[p].moving) / counters[p].speed
				counters[p].y = (counters[p].new_pos_y * (counters[p].speed - counters[p].moving) + counters[p].last_pos_y * counters[p].moving) / counters[p].speed
				moving = true
			elsif counters[p].destinations.size > 0
				set_new_counter_position(p, counters[p].destinations.pop)
				moving = true
			end
			if not moving
				self.moving_counters = false
 				self.buttons[1].color = 'yellow'
			end
		end
	end

	def reset()
		(0..players - 1).each do |p|
			set_counter_position(p, 0)
		end
		change_message("New Game")
	end

	def set_counter_position(player, pos)
		counters[player].x, counters[player].y = board_position(player, pos)
	end

	def set_new_counter_position(player, pos)
		counters[player].last_pos_x, counters[player].last_pos_y = counters[player].x, counters[player].y
		counters[player].new_pos_x, counters[player].new_pos_y = board_position(player, pos)
		counters[player].moving = Integer.sqrt((counters[player].new_pos_x - counters[player].last_pos_x) ** 2 + (counters[player].new_pos_y - counters[player].last_pos_y) ** 2)
		counters[player].speed = counters[player].moving
	end

	def set_state(positions)
		(0..players - 1).each do |p|
			set_counter_position(p, positions[p])
		end
		change_message("Snakes & Ladders: Game Loaded")
	end

	def show_dice(a)
		labels[2].text = "Rolled: #{a.join(", ")}"
	end

	def update_turn(dice, player, position, message)
		show_dice(dice)
 		change_message(message)
 		self.counters[player].destinations = position
 		self.moving_counters = true
 		self.buttons[1].color = 'black'
	end
end