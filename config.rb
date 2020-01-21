module Config

	SIZE = 0.8

	WINDOW_CONFIG = {
		background: 'silver',
		width: 800 * SIZE,
		height: 800 * SIZE,
		title: 'Snakes and Ladders'
	}

	BOARD_CONFIG = {
		width: 700 * SIZE,
		height: 700 * SIZE,
		border: 50 * SIZE,
		board_border: 5 * SIZE,
		image: 'snakesandladdersboard.jpg',
		image_border: 4 * SIZE,
		board_border_colour: 'black',
		button_gap: 5 * SIZE,
		buttons_across: 5 * SIZE,
		buttons_down: 20 * SIZE,
		button_colour: 'yellow',
		button_border_colour: 'black',
		button_border_size: 1 * SIZE,
		info_colour: 'gray',
		label_size: 0.5 * SIZE,
		label_x_adjust: 0.125 * SIZE,
		label_y_adjust: 0.25 * SIZE,
		label_text_colour: 'black',
		max_players: 2,
		player_colours: ['black', 'green'],
		sq_across: 10,
		sq_down: 10,
		counter_radius: 12 * SIZE,
		counter_sectors: 5,
		counter_speed: 5,
		message_x: 200 * SIZE,
		message_y: 20 * SIZE,
		message_colour: 'blue',
		z_border: 50 * SIZE,
		z_image: 100 * SIZE,
		z_counter: 200 * SIZE,
		z_button: 200 * SIZE,
		z_button_border: 100 * SIZE,
		z_label: 300 * SIZE,
		z_message: 200 * SIZE
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
