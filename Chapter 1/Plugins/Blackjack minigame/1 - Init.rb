# Blackjack game
# Credit: bo4p5687

module BlackJack
	# Value of Chip, graphics has 5 chip -> 5 values. Don't change this size.
	ValueChips = [1, 25, 100, 500, 1000]
	# Class
	class Play
		# Check delay for clicking
		DelayMouse = 0
		# Quantity of player (Dont change it)
		QuantityPlayer = 4
		# Name of AI, the size of this array must be greater than or equal to 3
		# If not, maybe, player have same name but it must be greater than 0
		NameAI = ["Airi", "Whattt", "Hamson"]
		def initialize
			@sprites = {}
			# Viewport
      @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
      @viewport.z = 99999
			# Value
			# Store: A-Hearts, A-Diamonds, A-Clubs, A-Spade, etc
			# Order: 0, 1, 2, 3, etc
			@card = []
			52.times { |i| @card << i }
			# Store card player (position and dealer)
			@player = {}
			# Set for finishing game
			@finish = false
			# Check mouse and use
			@oldm = [0,0]
			@delay = 0
			# Set name AI
			@nameai = NameAI
			@nameai = ["Name"] if @nameai.size<=0 || !@nameai.is_a?(Array)
			# Store position and name of main player (it's you)
			@mainplayer = {
				:position => nil,
				:symbol => nil
			}
			# Check card if it opened
			@opened = []
			QuantityPlayer.times { @opened << false }
			# Store history when dealer opens player's card
			@history = []
			@poshistory = 0
			# Set progress
			@action = false # Bet
			# (Progress) player play
			@playertime  = false # Player can choose action in this progress
			@information = false # Player see informations of each player, include dealer
			@createdchoice = false # Progress for creating choice for player
			@choice = {} # Store information of rectangle 'Choice'
			# (Progress) turn of player
			@turn = 0
			# Check information before finish
			@checkInfor = false
			# Set mouse sounds when move
			@semouse = 0
		end
	end
	# Def
	def self.play
		value = ValueChips
		value.sort!
		if GameData::Item.exists?(:COINCASE) && !$PokemonBag.pbHasItem?(:COINCASE)
			pbMessage(_INTL("It's a BlackJack Game."))
			return
		elsif $Trainer.coins<=0
			pbMessage(_INTL("You don't have any Coins to play!"))
			return
		elsif $Trainer.coins<value[0]
			pbMessage(_INTL("You don't have enough Coins to play!"))
			return
		end
		pbMessage(_INTL("It's a BlackJack Game."))
		if !pbConfirmMessage(_INTL("Do you want to play it?"))
			pbMessage(_INTL("See ya!!!"))
			return
		end
		loop do
			pbFadeOutIn {
				p = Play.new
				p.play
				p.endScene
			}
			if pbConfirmMessage(_INTL("Do you want to continue?"))
				# Check condition for playing
				if $Trainer.coins<=0
					pbMessage(_INTL("You don't have any Coins to play!"))
					break
				end
			else
				break
			end
		end
	end
end