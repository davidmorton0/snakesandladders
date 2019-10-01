

class Testgame
	def runtests(gameboard)
		# game engine tests
		testgame = SnakesLadders.new
		assert_equal testgame.player_place[0], 0, "start position should be 0"
		assert_equal testgame.game_over, false, "should not be game over"
		assert_equal testgame.player_turn, 0, "should be player 0(1)'s' turn"
		turn = testgame.play([6, 3])
		assert_equal testgame.player_place[0], 9, "should move to position 9"
		assert_equal testgame.player_turn, 1, "should now be player 1(2)'s' turn"
		# check message
		assert_equal turn[0], 0, "message should state player 0(1)'s' turn"
		assert_equal turn[1].first, 9, "message should state move to position 9"
		assert_equal turn[2], "Player 1 is on square 9", "message should be correct"
		# go up ladder
		turn = testgame.play([4, 3])
		assert_equal testgame.player_place[1], 14, "should move to position 14"
		# check message
		assert_equal turn[0], 1, "message should state player 1(2)'s' turn"
		assert_equal turn[1].first, 14, "message should state move to position 14"
		assert_equal turn[2], "Yes, a ladder! Player 2 is on square 14", "ladder message should be correct"
		# go down snake
		turn = testgame.play([5, 2])
		assert_equal testgame.player_place[0], 6, "should move to position 6"
		# check message
		assert_equal turn[0], 0, "message should state player 0(1)'s' turn"
		assert_equal turn[1].first, 6, "message should state move to position 6"
		assert_equal turn[2], "Oh no, a snake. Player 1 is on square 6", "snake message should be correct"
		# doubles
		player_turn = testgame.player_turn
		testgame.play([5, 5])
		assert_equal player_turn, testgame.player_turn, "should be same player's turn after doubles"
		testgame.game_over = true
		# can set game state
		testgame.set_state(1, [10, 96], false)
		assert_equal testgame.player_turn, 1, "should set state: player 1(2)'s' turn"
		assert_equal testgame.player_place[0], 10, "should set state: player 0, position 10"
		assert_equal testgame.player_place[1], 96, "should set state: player 1, position 96"
		assert_equal testgame.game_over, false, "should set state: not game over"
		# check win
		testgame.set_state(0, [97, 96], false)
		turn = testgame.play([1, 2])
		assert_equal testgame.player_place[0], 100, "player 0 should be at 100"
		assert_equal testgame.game_over, true, "should be game over after win"
		assert_equal turn[1].first, 100, "should state player at position 100"
		assert_equal turn[2], "Player 1 Wins!", "should have win message"

		# interface tests
		assert_equal gameboard.players, 2, "should be 2 players"
		assert_equal gameboard.buttons.length, 4, "should be 4 buttons"
		assert_equal gameboard.labels.length, 4, "should be 4 labels"
		assert_equal gameboard.counters.length, 2, "should be no counters"
	end
end