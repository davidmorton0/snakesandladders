require 'ruby2d'
require 'test/unit/assertions'
include Test::Unit::Assertions

require './config'
require './interface'
require './snakesandladders'
require './test'

test = Testgame.new
test.runtests

set Config::WINDOW_CONFIG
players = 2

gameboard = GameBoard.new(players)
game = SnakesLadders.new
starting_positions = [98, 98]
game.set_state(0, starting_positions, false)

gameboard.set_state(starting_positions)

on :mouse_down do |event|
	if gameboard.buttons[0].contains?(event.x, event.y)
 		game.reset
 		gameboard.reset
 	elsif gameboard.buttons[1].contains?(event.x, event.y) and gameboard.moving_counters == false
 		dice = [6, 6]    #dice = [rand(6) + 1, rand(6) + 1]
 		turn = game.play(dice)
	 	if turn[0] == -1
	 		gameboard.change_message(turn[2])
	 	else
	 		gameboard.update_turn(dice, turn[0], turn[1], turn[2])
	 	end
 	end
end

tick = 0

update do
	gameboard.move_counter(players)
  	tick += 1
end

show