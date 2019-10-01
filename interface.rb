require './config'
BOARD_CONFIG = Config::BOARD_CONFIG

class Counter < Circle
 	attr_accessor :destinations, :last_pos_x, :last_pos_y, :moving, :new_pos_x, :new_pos_y, :speed
end

class GameBoard
  	attr_accessor :buttons, :counters, :labels, :message, :moving_counters, :players, :square_height, :square_width

	def initialize(players)
		Image.new(
			BOARD_CONFIG[:image],
			x: BOARD_CONFIG[:border],
			y: BOARD_CONFIG[:border],
			width: BOARD_CONFIG[:width],
			height: BOARD_CONFIG[:height],
			z: BOARD_CONFIG[:z_image]
			)
		self.square_width = (BOARD_CONFIG[:width] - 2 * BOARD_CONFIG[:image_border]) / BOARD_CONFIG[:sq_across]
		self.square_height = (BOARD_CONFIG[:height] - 2 * BOARD_CONFIG[:image_border]) / BOARD_CONFIG[:sq_down]

		make_border()

		#add buttons and labels
		self.buttons = []
		self.labels = []

		add_button("New Game", BOARD_CONFIG[:button_colour])
		add_button("Go", BOARD_CONFIG[:button_colour])
		add_button("Quit", BOARD_CONFIG[:button_colour])
		add_button("Dice", BOARD_CONFIG[:info_colour])

		self.players = players	
		raise GameBoardError, "Too many players.  Maximum is #{BOARD_CONFIG[:max_players]}" if players > BOARD_CONFIG[:max_players]
		raise GameBoardError, "Can't have less than 0 players" if players < 0

		self.counters = []
		players.times { |p| add_counter(p) }
		self.moving_counters = false

		# start new game
		reset()
	end

	def add_button(text, colour)
		# add button
		self.buttons << Rectangle.new(
			x: BOARD_CONFIG[:border] + buttons.size * (BOARD_CONFIG[:width] / BOARD_CONFIG[:buttons_across] + BOARD_CONFIG[:button_gap]),
			y: BOARD_CONFIG[:height] + BOARD_CONFIG[:border] + BOARD_CONFIG[:board_border] + BOARD_CONFIG[:button_gap],
			width: BOARD_CONFIG[:width] / BOARD_CONFIG[:buttons_across],
			height: BOARD_CONFIG[:height] / BOARD_CONFIG[:buttons_down],
			color: colour,
			z: BOARD_CONFIG[:z_button]
			)
		#add button border
		Rectangle.new(
			x: buttons[-1].x - BOARD_CONFIG[:button_border_size],
			y: buttons[-1].y - BOARD_CONFIG[:button_border_size],
			width: buttons[-1].width + 2 * BOARD_CONFIG[:button_border_size],
			height: buttons[-1].height + 2 * BOARD_CONFIG[:button_border_size],
			color: BOARD_CONFIG[:button_border_colour],
			z: BOARD_CONFIG[:z_button_border]
			)
		self.labels << Text.new(
			text,
			x: @buttons[-1].x + @buttons[-1].width * BOARD_CONFIG[:label_x_adjust],
			y: @buttons[-1].y + @buttons[-1].height * BOARD_CONFIG[:label_y_adjust],
			size: @buttons[-1].height * BOARD_CONFIG[:label_size],
			color: BOARD_CONFIG[:label_text_colour],
			z: BOARD_CONFIG[:z_label]
			)
	end

	def add_counter(player)
		counters << Counter.new(
  			radius: BOARD_CONFIG[:counter_radius],
  			sectors: BOARD_CONFIG[:counter_sectors],
  			color: BOARD_CONFIG[:player_colours][player],
  			z: BOARD_CONFIG[:z_counter]
			)
		self.counters[-1].moving = 0
		self.counters[-1].destinations = []
	end

	def board_position(player, pos)
		counter_adjust_x = (player + 1) * square_width / 3
		counter_adjust_y = (player + 1) * square_height / 3
		if pos == 0
			[ board_space_position_x(1) - counter_adjust_x, board_space_position_y(1) - counter_adjust_y ]
		else
			[ board_space_position_x(pos) + counter_adjust_x, board_space_position_y(pos) - counter_adjust_y ]
		end
	end

	def board_space_position_x(board_space)
			# right to left squares direction
		if (board_space - 1) % 20 == (board_space - 1) % 10
			BOARD_CONFIG[:border] + BOARD_CONFIG[:image_border] + (board_space - 1) % 10 * square_width
			# left to right squares direction
		else
			BOARD_CONFIG[:border] + BOARD_CONFIG[:width] - BOARD_CONFIG[:image_border] - (board_space % 10 == 0 ? 10 : board_space % 10) * square_width
		end
	end

	def board_space_position_y(board_space)
		BOARD_CONFIG[:border] + BOARD_CONFIG[:height] - BOARD_CONFIG[:image_border] - (board_space - 1) / 10 * square_height
	end

	def change_message(new_message)
		self.message.remove if not message.nil?
		self.message = Text.new(
			new_message,
			x: BOARD_CONFIG[:message_x],
			y: BOARD_CONFIG[:message_y],
			color: BOARD_CONFIG[:message_colour],
			z: BOARD_CONFIG[:z_message]
		)
	end

	def make_border()
		Rectangle.new(
			x: BOARD_CONFIG[:border] - BOARD_CONFIG[:board_border],
			y: BOARD_CONFIG[:border] - BOARD_CONFIG[:board_border],
			width: BOARD_CONFIG[:width] + BOARD_CONFIG[:board_border] * 2,
			height: BOARD_CONFIG[:height] + BOARD_CONFIG[:board_border] * 2,
			color: BOARD_CONFIG[:board_border_colour],
			z: BOARD_CONFIG[:z_border]
			)
	end

	def move_counter(players)
		moving = false
		(0..players - 1).each do |p|
			if counters[p].moving > 0
				counters[p].moving -= BOARD_CONFIG[:counter_speed]
				counters[p].x = (counters[p].new_pos_x * (counters[p].speed - counters[p].moving) + counters[p].last_pos_x * counters[p].moving) / counters[p].speed
				counters[p].y = (counters[p].new_pos_y * (counters[p].speed - counters[p].moving) + counters[p].last_pos_y * counters[p].moving) / counters[p].speed
				moving = true
			elsif counters[p].destinations.size > 0
				set_new_counter_position(p, counters[p].destinations.pop)
				moving = true
			end
		end
		if not moving
			self.moving_counters = false
			self.buttons[0].color = BOARD_CONFIG[:button_colour]
			self.buttons[1].color = BOARD_CONFIG[:button_colour]
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
		labels[3].text = "Rolled: #{a.join(", ")}"
	end

	def update_turn(dice, player, position, message)
		show_dice(dice)
 		change_message(message)
 		self.counters[player].destinations = position
 		self.moving_counters = true
 		self.buttons[0].color = BOARD_CONFIG[:label_text_colour]
 		self.buttons[1].color = BOARD_CONFIG[:label_text_colour]
	end
end