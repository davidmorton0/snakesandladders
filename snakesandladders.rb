SNAKES = { 16 => 6, 46 => 25, 49 => 11, 62 => 19, 64 => 60, 74 => 53, 89 => 68, 92 => 88, 95 => 75, 99 => 80 }
LADDERS = { 2 => 38, 7 => 14, 8 => 31, 15 => 26, 21 => 42, 28 => 84, 36 => 44, 51 => 67, 71 => 91, 78 => 98, 87 => 94 }

class SnakesLadders  
	attr_accessor :player_turn
	attr_accessor :player_place
    attr_accessor :game_over

	def initialize()
  		reset()
	end

	def play(dice)
    	@player_place[@player_turn] += dice.sum
        message = ""
    	if @game_over
    		return [-1, -1, "Game over!"]
    	elsif @player_place[@player_turn] == 100
    		@game_over = true
    		return [ @player_turn, 100, "Player #{@player_turn + 1} Wins!"]
    	elsif @player_place[@player_turn] > 100
    		@player_place[@player_turn] = 200 - @player_place[@player_turn]
    	end
    	if SNAKES.key?(@player_place[@player_turn])
    		message = "Oh no, a snake. "
    		@player_place[@player_turn] = SNAKES[@player_place[@player_turn]]
    	elsif LADDERS.key?(@player_place[@player_turn])
    		message =  "Yes, a ladder!. "
    		@player_place[@player_turn] = LADDERS[@player_place[@player_turn]]
    	end
    	result = [ @player_turn, @player_place[@player_turn], message + "Player #{@player_turn + 1} is on square #{@player_place[@player_turn]}"]
    	@player_turn = (1 - @player_turn) if dice.uniq.length == 2
    	return result
  	end

    def reset()
        @player_turn = 0
        @player_place = [0, 0]
        @game_over = false
    end
end