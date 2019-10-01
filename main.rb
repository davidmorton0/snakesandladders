require 'ruby2d'
require 'test/unit/assertions'
include Test::Unit::Assertions

require './config'
require './interface'
require './snakesandladders'
require './test'

# start game at chosen positions
def set_start(starting_positions)
	game.set_state(0, starting_positions, false)
	gameboard.set_state(starting_positions)
end

set Config::WINDOW_CONFIG
players = 2

gameboard = GameBoard.new(players)
game = SnakesLadders.new
#set_start([98, 98])

test = Testgame.new
test.runtests(gameboard)

on :mouse_down do |event| # handles button clicks
	if gameboard.buttons[0].contains?(event.x, event.y) and gameboard.moving_counters == false
 		game.reset
 		gameboard.reset
 	elsif gameboard.buttons[1].contains?(event.x, event.y) and gameboard.moving_counters == false
 		dice = [rand(6) + 1, rand(6) + 1]
 		turn = game.play(dice)
	 	if turn[0] == -1
	 		gameboard.change_message(turn[2])
	 	else
	 		gameboard.update_turn(dice, turn[0], turn[1], turn[2])
	 	end
 	elsif gameboard.buttons[2].contains?(event.x, event.y)
 		exit
 	end
end

tick = 0
update do
	gameboard.move_counter(players)
  	tick += 1
end

show