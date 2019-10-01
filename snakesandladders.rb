require './config'
SNAKES = Config::SNAKES
LADDERS = Config::LADDERS
GAME_CONSTANTS = Config::GAME_CONSTANTS

class SnakesLadders  
	attr_accessor :player_turn, :player_place, :game_over

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
    		return [-1, -1, GAME_CONSTANTS[:game_over_message]]
    	elsif new_pos == GAME_CONSTANTS[:square_num]
    		self.game_over = true
            message = eval("\"" + GAME_CONSTANTS[:win_message] + "\"")
            destinations = [GAME_CONSTANTS[:square_num]]
    	elsif new_pos > GAME_CONSTANTS[:square_num]
            destinations = [ GAME_CONSTANTS[:square_num] * 2 - new_pos, GAME_CONSTANTS[:square_num] ]
        else
            destinations = [new_pos]
    	end

        # turning corners
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
    		message += GAME_CONSTANTS[:snake_message]
    		destinations.unshift(SNAKES[destinations.first])
    	elsif LADDERS.key?(destinations.first)
    		message += GAME_CONSTANTS[:ladder_message]
            destinations.unshift(LADDERS[destinations.first])
    	end

        self.player_place[player_turn] = destinations.first
        message += eval("\"" + GAME_CONSTANTS[:turn_message] + "\"") if not game_over
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