require 'ruby2d'
require './config.rb'
require './interface_rectangle.rb'
require './snakesandladders.rb'
require './interface.rb'

set Config::WINDOW_CONFIG
players = 2

gameboard = GameBoard.new(players)
game = SnakesLadders.new
(0..players - 1).each { |x| game.player_place[x] = 98 }

message = Text.new('Snakes & Ladders', x: 200, y: 20)
(0..players - 1).each { |x|	gameboard.update(x, game.player_place[x]) }

on :mouse_down do |event|
	if gameboard.buttons[0].contains?(event.x, event.y)
 		message.remove
 		game.reset
 		(0..players - 1).each { |x|	gameboard.update(x, game.player_place[x]) }
 		message = Text.new('Game Started', x: 200, y: 20)
 	elsif gameboard.buttons[1].contains?(event.x, event.y) and game.game_over == false
 		dice = [1, 2]
 		#dice = [rand(6) + 1, rand(6) + 1]
 		gameboard.show_dice(dice)
 		turn = game.play(dice)
 		message.remove
 		message = Text.new(turn[2], x: 200, y: 20)
 		gameboard.update(turn[0], turn[1])
 	end
end

=begin
tick = 0

update do
  	if tick % 10 == 0
		gameboard.move_counter(players)
  	end
  	tick += 1
end
=end

show