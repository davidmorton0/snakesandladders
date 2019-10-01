SNAKES = { 16 => 6, 46 => 25, 49 => 11, 62 => 19, 64 => 60, 74 => 53, 89 => 68, 92 => 88, 95 => 75, 99 => 80 }
LADDERS = { 2 => 38, 7 => 14, 8 => 31, 15 => 26, 21 => 42, 28 => 84, 36 => 44, 51 => 67, 71 => 91, 78 => 98, 87 => 94 }

class SnakesLadders  
	attr_accessor :player_turn
	attr_accessor :player_place
    attr_accessor :game_over

	def initialize()
  		reset()
	end

    # does a turn - returns [ player turn, destinations, message ]
	def play(dice)
        current_pos = player_place[player_turn]
    	new_pos = dice.sum + player_place[player_turn]

        destinations = []
        message = ""
    	if game_over
    		return [-1, -1, "Game over!"]
    	elsif new_pos == 100
    		self.game_over = true
            message = "Player #{player_turn + 1} Wins!"
            destinations = [100]
    	elsif new_pos > 100
            destinations = [ 200 - new_pos, 100 ]
        else
            destinations = [new_pos]
    	end

        # need to turn corners
        if (current_pos - 1).floor(-1) + 20 == (destinations.first - 1).floor(-1)
            destinations.push((current_pos - 1).floor(-1) + 21)
            destinations.push((current_pos - 1).floor(-1) + 20)
            destinations.push((current_pos - 1).floor(-1) + 11)
            destinations.push((current_pos - 1).floor(-1) + 10)
        elsif (current_pos - 1).floor(-1) + 10 == (destinations.first - 1).floor(-1)
            destinations.push((current_pos - 1).floor(-1) + 11)
            destinations.push((current_pos - 1).floor(-1) + 10)
        elsif (current_pos - 1).floor(-1) - 10 == (destinations.first - 1).floor(-1)
            destinations.insert(1, 90, 91)
        end

        # check snakes or ladders
    	if SNAKES.key?(destinations.first)
    		message += "Oh no, a snake. "
    		destinations.unshift(SNAKES[destinations.first])
    	elsif LADDERS.key?(destinations.first)
    		message +=  "Yes, a ladder! "
            destinations.unshift(LADDERS[destinations.first])
    	end

        self.player_place[player_turn] = destinations.first
        message += "Player #{player_turn + 1} is on square #{destinations.first}" if not game_over
    	result = [ player_turn, destinations, message ]

    	#next player's turn unless rolled doubles
        self.player_turn = (1 - player_turn) if dice.uniq.length == 2
    	return result
  	end

    def reset()
        self.player_turn = 0
        self.player_place = [0, 0]
        self.game_over = false
    end

    def set_state(turn, player_places, set_game_over)
        self.player_turn = turn
        (0..player_places.length - 1).each { |x| self.player_place[x] = player_places[x] }
        self.game_over = set_game_over
    end
end