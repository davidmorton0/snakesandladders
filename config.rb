module Config

	WINDOW_CONFIG = {
		background: 'silver',
		width: 800,
		height: 800,
		title: 'Snakes and Ladders'
	}

	BOARD_CONFIG = {
		width: 700,
		height: 700,
		border: 50,
		board_border: 5,
		image: 'snakesandladdersboard.jpg',
		image_border: 4,
		board_border_colour: 'black',
		button_gap: 5,
		buttons_across: 5,
		buttons_down: 20,
		button_colour: 'yellow',
		button_border_colour: 'black',
		button_border_size: 1,
		info_colour: 'gray',
		label_size: 0.5,
		label_x_adjust: 0.125,
		label_y_adjust: 0.25,
		label_text_colour: 'black',
		max_players: 2,
		player_colours: ['black', 'green'],
		sq_across: 10,
		sq_down: 10,
		counter_radius: 12,
		counter_sectors: 5,
		counter_speed: 5,
		message_x: 200,
		message_y: 20,
		message_colour: 'blue',
		z_border: 50,
		z_image: 100,
		z_counter: 200,
		z_button: 200,
		z_button_border: 100,
		z_label: 300,
		z_message: 200
	}

	SNAKES = { 16 => 6, 46 => 25, 49 => 11, 62 => 19, 64 => 60, 74 => 53, 89 => 68, 92 => 88, 95 => 75, 99 => 80 }
	LADDERS = { 2 => 38, 7 => 14, 8 => 31, 15 => 26, 21 => 42, 28 => 84, 36 => 44, 51 => 67, 71 => 91, 78 => 98, 87 => 94 }

	GAME_CONSTANTS = {
		square_num: 100,
		game_over_message: "Game over!",
		win_message: 'Player #{player_turn + 1} Wins!',
		turn_message: 'Player #{player_turn + 1} is on square #{destinations.first}',
		snake_message: "Oh no, a snake. ",
		ladder_message: "Yes, a ladder! "
	}
end