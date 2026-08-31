#===============================================================================
# Safari Zone battle class
#===============================================================================
#  attr_accessor :attackFactor
#  attr_accessor :catchFactor
#  attr_accessor :escapeFactor


class SafariBattle
  attr_reader   :battlers         # Array of fake battler objects
  attr_accessor :sideSizes        # Array of number of battlers per side
  attr_accessor :backdrop         # Filename fragment used for background graphics
  attr_accessor :backdropBase     # Filename fragment used for base graphics
  attr_accessor :time             # Time of day (0=day, 1=eve, 2=night)
  attr_accessor :environment      # Battle surroundings (for mechanics purposes)
  attr_reader   :weather
  attr_reader   :player
  attr_accessor :party2
  attr_accessor :canRun           # True if player can run from battle
  attr_accessor :canLose          # True if player won't black out if they lose
  attr_accessor :switchStyle      # Switch/Set "battle style" option
  attr_accessor :showAnims        # "Battle scene" option (show anims)
  attr_accessor :expGain          # Whether Pokémon can gain Exp/EVs
  attr_accessor :moneyGain        # Whether the player can gain/lose money
  attr_accessor :rules
  attr_accessor :ballCount
  attr_accessor :ballType
  attr_accessor :index
  attr_accessor :selected_menu
  attr_accessor :decision
  attr_accessor :runrate
  attr_accessor :used_special
  attr_accessor :thrown_pokemon
  attr_reader :suboptions

  include Battle::CatchAndStoreMixin

  def pbRandom(x); return rand(x); end

  #=============================================================================
  # Initialize the battle class
  #=============================================================================
  def initialize(scene, player, party2)
    @scene         = scene
    @peer          = Battle::Peer.new
    @backdrop      = ""
    @backdropBase  = nil
    @time          = 0
    @environment   = :None   # e.g. Tall grass, cave, still water
    @weather       = :None
    @decision      = 0
    @caughtPokemon = []
    @player        = [player]
    @party2        = party2
    @sideSizes     = [1, party2.length]
    @battlers      = [Battle::FakeBattler.new(self, 0),
                      Battle::FakeBattler.new(self, 1)]
					  
					  
	@suboptions = {}	
    @used_special = false 	
	@thrown_pokemon = nil
	refresh_action_options
    @cmd     = 0
	@target = 0
	@runrate = 5
	@selected_menu = nil 
    @index     = 0
    @rules         = {}
  end


  def can_soothe?
   offered = @battlers[0].offered_approach_last_turn == true

   no_one_approached = !@battlers[1..].any? { |battler| battler.approached }

   return false if offered && no_one_approached
   return true
  end

  def add_action(menu, klass, *args)
    action = klass.new(*args)
    return unless action.can_add?
    @suboptions[menu] << action
  end
  def setup_attacking_options
    menu = _INTL("ATTACK")
    @suboptions[menu] = []
	add_action(menu, SafariBattle::Acts::Attack::BlackBeltPunch, _INTL("NORMAL"), _INTL("Strike out at the enemy like a common man."), 4)
	add_action(menu, SafariBattle::Acts::Attack::PreciseAttack, _INTL("PRECISE"), _INTL("Land a carefully aimed hit."), 4)
	add_action(menu, SafariBattle::Acts::Attack::FierceAttack, _INTL("FIERCE"), _INTL("Attack fiercely and with reckless abandon."), 8)
	add_action(menu, SafariBattle::Acts::Attack::SpecialAttack, _INTL("SPECIAL"), _INTL("Use your *special* attack."), 25) if @used_special==false
	
	
	add_action(menu, SafariBattle::Acts::Attack::Punch, _INTL("PUNCH"), _INTL("Strike at your enemy with your fist."), 4)
	
	
	add_action(menu, SafariBattle::Acts::Attack::Machete, GameData::Item.get(:MACHETE).name.upcase, GameData::Item.get(:MACHETE).description, 8)
	add_action(menu, SafariBattle::Acts::Attack::Stone, GameData::Item.get(:STONE).name.upcase, GameData::Item.get(:STONE).description, 6, true)
  end 
  def setup_defending_options
    menu = _INTL("DEFEND")
    @suboptions[menu] = []
	add_action(menu, SafariBattle::Acts::Defend::Rest, _INTL("REST"), _INTL("Take a pause to regain some stamina."), -(($player.playermaxstamina * 0.6).round + rand(5)))
	add_action(menu, SafariBattle::Acts::Defend::Block, _INTL("BLOCK"), _INTL("A trained defensive art to ensure you will not fall."), 12)
	add_action(menu, SafariBattle::Acts::Defend::Counter, _INTL("COUNTER"), _INTL("A trained defensive art to intercept enemy attacks and make them your own."), 25)
	add_action(menu, SafariBattle::Acts::Defend::Brace, _INTL("BRACE"), _INTL("Brace for the next attack."), 10)
	add_action(menu, SafariBattle::Acts::Defend::Run, _INTL("RUN"), _INTL("Attempt to run away from the battle."), 8)
	add_action(menu, SafariBattle::Acts::Defend::Pokemon, _INTL("POKeMON"), _INTL("Select a POKeMON to battle."), 6)
  end 
  def setup_appealing_options
    menu = _INTL("APPEAL")
    @suboptions[menu] = []
	add_action(menu, SafariBattle::Acts::Appeal::Soothe, _INTL("SOOTHE"), _INTL("Attempt to get the POKeMON to relax."), 6) if can_soothe?
	add_action(menu, SafariBattle::Acts::Appeal::BreederGroom, _INTL("GROOM"), _INTL("Attempt to groom the POKeMON with your Brush."), 4)
	add_action(menu, SafariBattle::Acts::Appeal::Groom, _INTL("GROOM"), _INTL("Attempt to groom the POKeMON with your Brush."), 4)
	add_action(menu, SafariBattle::Acts::Appeal::Bait, _INTL("BAIT"), _INTL("Attempt to get the POKeMON to relax by feeding it."), 6, true)
  end 
  
  def setup_catching_options
    menu = _INTL("CATCH")
    @suboptions[menu] = []
    balls = $bag.any_pokeballs?
	balls.each do |ball| 
	 add_action(menu, SafariBattle::Acts::Catch::Ball, GameData::Item.get(ball).name.upcase, GameData::Item.get(ball).description, 8, true, ball)
	end 

  end 
  

  def refresh_action_options
	setup_attacking_options
	setup_defending_options
	setup_appealing_options
	setup_catching_options
  end 
  

  def disablePokeBalls=(value); end
  def sendToBoxes=(value); end
  def defaultWeather=(value); @weather = value; end
  def defaultTerrain=(value); end

  #=============================================================================
  # Information about the type and size of the battle
  #=============================================================================
  def wildBattle?;    return true;  end
  def trainerBattle?; return false; end

  def setBattleMode(mode); end

  def pbSideSize(index)
    return @sideSizes[index % 2]
  end

  #=============================================================================
  # Trainers and owner-related
  #=============================================================================
  def pbPlayer; return @player[0]; end
  def opponent; return nil;        end

  def pbGetOwnerFromBattlerIndex(idxBattler); return pbPlayer; end

  def pbSetSeen(battler)
    return if !battler || !@internalBattle
    if battler.is_a?(Battle::Battler)
      pbPlayer.pokedex.register(battler.displaySpecies, battler.displayGender,
                                battler.displayForm, battler.shiny?)
    else
      pbPlayer.pokedex.register(battler)
    end
  end

  def pbSetCaught(battler)
    return if !battler || !@internalBattle
    if battler.is_a?(Battle::Battler)
      pbPlayer.pokedex.register_caught(battler.displaySpecies)
    else
      pbPlayer.pokedex.register_caught(battler.species)
    end
  end

  #=============================================================================
  # Get party info (counts all teams on the same side)
  #=============================================================================
  def pbParty(idxBattler)
    return (opposes?(idxBattler)) ? @party2 : nil
  end

  def pbAllFainted?(idxBattler = 0); return false; end

  #=============================================================================
  # Battler-related
  #=============================================================================
  def opposes?(idxBattler1, idxBattler2 = 0)
    idxBattler1 = idxBattler1.index if idxBattler1.respond_to?("index")
    idxBattler2 = idxBattler2.index if idxBattler2.respond_to?("index")
    return (idxBattler1 & 1) != (idxBattler2 & 1)
  end

  def pbRemoveFromParty(idxBattler, idxParty); end
  def pbGainExp; end

  #=============================================================================
  # Messages and animations
  #=============================================================================
  def pbDisplay(msg, &block)
    @scene.pbDisplayMessage(msg, &block)
  end

  def pbDisplayPaused(msg, &block)
    @scene.pbDisplayPausedMessage(msg, &block)
  end

  def pbDisplayBrief(msg)
    @scene.pbDisplayMessage(msg, true)
  end

  def pbDisplayConfirm(msg)
    return @scene.pbDisplayConfirmMessage(msg)
  end



  class BattleAbortedException < Exception; end

  def pbAbort
    raise BattleAbortedException.new("Battle aborted")
  end
end

class SafariBattle

  def pbStartBattle
    begin
	  $player.playerstamina=0.0 if $player.playerstamina < 0.0
      pkmn = @party2[0]
      pbSetSeen(pkmn)
      @scene.pbStartBattle(self)
      pbDisplayPaused(_INTL("{1} was jumped by a wild {2}!", $player.name,pkmn.name)) if @party2.length==1
      @scene.pbSafariStart
	  
      weather_data = GameData::BattleWeather.try_get(@weather)
      @scene.pbCommonAnimation(weather_data.animation) if weather_data
	  @battlers.each_with_index do |battler, i|
	     next if i==0
		 pkmn = battler.pokemon
         catch_rate = pkmn.species_data.catch_rate
        # battler.catchFactor  = (catch_rate * 100) / 1275
         battler.catchFactor  = pbCatchRate(catch_rate)
         battler.catchFactor  = [[battler.catchFactor, 0].max, 255].min
       #  battler.escapeFactor = (pbEscapeRate(catch_rate) * 100) / 1275
         battler.escapeFactor = pbEscapeRate(catch_rate)
         battler.escapeFactor = [[battler.escapeFactor, 0].max, 255].min
       #  battler.attackFactor  = (pbAttackRate(pkmn) * 100) / 1275
         battler.attackFactor  = pbAttackRate(pkmn)
         battler.attackFactor  = [[battler.attackFactor, 0].max, 255].min
	  end
      #pbShowTipCardsGrouped(:BASICSCOMBAT) if $game_switches[556]==true


	  
      loop do
	    @scene.pbUpdate
	    @scene.pbRefresh
	    refresh_action_options
	    #Player Turn
        @cmd = @scene.pbSafariCommandMenu(0)
		if @cmd 
		
	    @battlers[0].offered_approach_last_turn = false
        player_turn
        @battlers.each_with_index do |battler, i|
	      next if i==0
          battler.catchFactor  = [[battler.catchFactor, 0].max, 255].min
          battler.escapeFactor = [[battler.escapeFactor, 0].max, 255].min
          battler.attackFactor  = [[battler.attackFactor, 0].max, 255].min
		end
        @battlers.each_with_index do |battler, i|
	       next if i==0
           next if @decision != 0
	       pkmn = battler.pokemon
		   if pkmn.fainted?
		     pbDisplayPaused(_INTL("You've knocked out {1}! ",pkmn.name))
			 next
		   end
           enemy_turn(battler)
        end

	    @scene.closeBriefMessage
        @battlers.each_with_index do |battler, i|
	      next if i==0
          battler.catchFactor  = [[battler.catchFactor, 0].max, 255].min
          battler.escapeFactor = [[battler.escapeFactor, 0].max, 255].min
          battler.attackFactor  = [[battler.attackFactor, 0].max, 255].min
		end
		end 
		
        if @battlers.drop(1).all? { |battler| battler.pokemon.fainted? }
          @decision = 1
        end


	    if $player.playerhealth <=0
		 pbDisplayPaused(_INTL("{1} was knocked out!",$player.name))
		 @decision = 2
		end
        break if @decision > 0
		
        weather_data = GameData::BattleWeather.try_get(@weather)
        @scene.pbCommonAnimation(weather_data.animation) if weather_data
        @runrate += 1
		
        end

  #    puts "Decision: #{@decision}"
      if @decision == 5 && @thrown_pokemon
		 $game_temp.in_safari=false
		 $game_temp.stop_intro_animations=true
		 foe_party = WildBattle.generate_foes(@decision[1])
		 WildBattle.start_core(*foe_party)
		 $game_temp.stop_intro_animations=false
      else
	     if @decision != 2
		 
		 pbPlayerEXP(pkmn) if @decision == 4 || @decision == 1
		 if @decision == 1
		 pbDisplayPaused(_INTL("You collected some meat from {1}! ",pkmn.name))
         pbHeldItemDropOW(pkmn,true)
		 end 
		 @scene.pbEndCombat
		 end 
         @scene.pbEndBattle(@decision)
	  end 
    rescue BattleAbortedException
      @decision = 0
      @scene.pbEndBattle(@decision)
    end
  end 

end 


class SafariBattle
  #=============================================================================
  # Safari battle-specific methods
  #=============================================================================
  def pbInflictHPDamage(target)
      target.pbReduceHP(target.damageState.hpLost, false, true, false)
  end
  
  def pbAnimateHitAndHPLost(user, targets)
    animArray = []
    2.times do |side| 
	targets.each do |b|
        next if b.damageState.unaffected || b.damageState.hpLost == 0
        next if (side == 0 && b.opposes?(user)) || (side == 1 && !b.opposes?(user))
	    oldHP = b.hp
        oldHP += b.damageState.hpLost
        animArray.push([b, oldHP, 0])
	end 
      if animArray.length > 0
        @scene.pbHitAndHPLossAnimation(animArray)
        animArray.clear
      end
	end
  end
 def pbEscapeRate(catch_rate)
    rate =
    if catch_rate <= 45
      125
    elsif catch_rate <= 60
      100
    elsif catch_rate <= 120
      75
    elsif catch_rate <= 250
      50
    else
      25
    end
	
    rate = [[rate, 0].max, 255].min
	return rate 
  end
  def pbCatchRate(catch_rate)
    rate = (catch_rate * 255) / 1275
	variation = (rate * 0.15).to_i
	rate += rand(-variation..variation)
    rate = [[rate, 0].max, 255].min
    return rate
  end 
  def pbAttackRate(pkmn)
   rate = 50
   case pkmn.nature.id 
    when :ADAMANT, :BRAVE, :NAUGHTY, :BOLD
     rate += 20
    when :TIMID, :CALM, :CAREFUL, :LONELY
     rate -= 15
   end
   rate += 50 if pkmn.shadowPokemon?
   rate = (rate * 3) / 2 if pkmn.hp > (pkmn.totalhp / 4) && pkmn.hp <= (pkmn.totalhp / 2)
   rate *= 2 if pkmn.hp <= (pkmn.totalhp / 4)
   rate += 25 if $player.playerhealth <= 25
   rate += 10 if $player.playerhealth <= 50

   rate += 25 if $player.playerstamina <= 5
   rate += 10 if $player.playerstamina <= 10
   rate = [[rate, 0].max, 255].min
   return rate
  end 


 
 def catching
    pkmn = @target
 
		    case $shifted1
		     when 1
		       @ballType = @scene.pbSafariBalls
		       @ballType = GameData::Item.get(@ballType).id if !@ballType.nil?
			    @cmd = -1 if @ballType.nil? && pbDisplayPaused2(_INTL("You did not choose a POKeBALL!"))
		       return -1 if @ballType.nil?
	           @scene.pbUpdate
	           @scene.pbRefresh
			  when 0
			    if pbBoxesFull?
			   pbDisplay(_INTL("You can't catch any more Pokémon!")) 
		       return -1
			  end
		       if @ballType.nil?
		       @ballType = @scene.pbSafariBalls
			    @cmd = -1 if @ballType.nil? && pbDisplayPaused2(_INTL("You did not choose a POKeBALL!"))
		       return -1 if @ballType.nil?
		       @ballType = GameData::Item.get(@ballType).id if !@ballType.nil?
	           @scene.pbUpdate
	           @scene.pbRefresh
		       end
			   if @ballType
			   
			   
			   
			   
			   if $bag.quantity(@ballType) == 0 
		       @ballType = @scene.pbSafariBalls
			    @cmd = -1 if @ballType.nil? && pbDisplayPaused2(_INTL("You did not choose a POKeBALL!"))
		       return -1 if @ballType.nil?
		       @ballType = GameData::Item.get(@ballType).id if !@ballType.nil?
	           @scene.pbUpdate
	           @scene.pbRefresh
		       end
              $bag.remove(@ballType,1)
		       rare = (@battlers[@party2.length].catchFactor * 1275) / 100
		       if $player.decreaseStamina(5)
                pbThrowPokeBall(1, @ballType, rare, true)
		       
			   else
			     pbDisplayPaused2(_INTL("You overexerted yourself trying to throw a POKeBALL!"))
			   end



			   if @caughtPokemon.length > 0 && @party2.length==1
                pbRecordAndStoreCaughtPokemon
                @decision = 4
              end
			  
			  
			  
			  
			  
			  
              end
		     end
		
		
		
		
		
		
		




 
 
 
 end
 def appealing
    pkmn = @target
      case $shifted2
	    when 1
          pbDisplayBrief(_INTL("{1} crouches down and acts friendly!", self.pbPlayer.name, @target.name))
		   $player.playerstamina += 2.0
          @battlers[@party2.index(pkmn)+1].catchFactor  +=5
          @battlers[@party2.index(pkmn)+1].escapeFactor -=5
           @runrate += 1
		   @cmd =5 
		when 0 
		
         if $bag.quantity(:BAIT) < 1
          pbDisplayBrief(_INTL("You do not have enough Bait!"))
         else
          pbDisplayBrief(_INTL("{1} threw some bait at the {2}!", self.pbPlayer.name, pkmn.name))
		  
		       if $player.decreaseStamina(5)
                baitresult = @scene.pbThrowBait
		        if baitresult == true
		                  pbDisplayBrief(_INTL("It's looking at the bait curiously!"))
		                  @battlers[@party2.index(pkmn)+1].catchFactor  += 10
		                  @battlers[@party2.index(pkmn)+1].escapeFactor -= 10   
		                  @runrate *= 2
		        else
		                  pbDisplayBrief(_INTL("The bait flew past {1}", pkmn.name))
		        		  @cmd = 5
		        end
			   else
			     pbDisplayPaused2(_INTL("You overexerted yourself trying to throw bait!"))
			   end
                  
		  end



		
	  end




 end
 def attacking
    @target
	
	
	
	
	
    case $shifted3
	  when 2
	    if $player.decreaseStamina(10)
          pbDisplayBrief(_INTL("You attacked {1} with a Machete!", pkmn.name))
		  pkmn.hp -= rand(5)+12
          @battlers[@party2.index(pkmn)+1].attackFactor  -= 5                       # Easier to catch
          @battlers[@party2.index(pkmn)+1].escapeFactor += 7   # More likely to escape
		   @cmd = 7
		 else
			pbDisplayPaused2(_INTL("You overexerted yourself using your Machete!"))
		 end 
	  when 1
         if $bag.quantity(:STONE) < 1
          pbDisplayBrief(_INTL("You do not have enough Stones!"))
		  elsif decreaseStamina(10)
			pbDisplayPaused2(_INTL("You overexerted yourself throwing a Rock!"))
         else
          pbDisplayBrief(_INTL("{1} threw a rock at the {2}!", self.pbPlayer.name, @target.name))
          $bag.remove(:STONE,1)						
          rockresult = @scene.pbThrowRock
		  if rockresult == true
          @battlers[@party2.index(pkmn)+1].attackFactor  -= 10                       # Easier to catch
          @battlers[@party2.index(pkmn)+1].escapeFactor += 10   # More likely to escape
		   #pkmn.hp -= rand(10)+1
          pbDisplayBrief(_INTL("{1} seems to have taken some damage!", pkmn.name))
		  else
          pbDisplayBrief(_INTL("The rock flew past {1}!", pkmn.name))
		  @cmd = 5
		  end
         end

	  
	  
	  


	  when 0	
	    if $player.decreaseStamina(10)
		  pkmn.hp -= rand(5)+6
          pbDisplayBrief(_INTL("You punched the {1}!", pkmn.name))
          @battlers[@party2.index(pkmn)+1].attackFactor  -= 7                       # Easier to catch
          @battlers[@party2.index(pkmn)+1].escapeFactor += 5  # More likely to escape
		  @cmd = 7
		 else
			pbDisplayPaused2(_INTL("You overexerted yourself while punching!"))
		 end 
	 
    end

 end
 def defending
    pkmn = @target
			  @battlers[@party2.index(pkmn)+1].attackFactor+=10
          @battlers[@party2.index(pkmn)+1].catchFactor -= 10
 		 if Input.press?(Input::CTRL) && $DEBUG
          pbSEPlay("Battle flee")
          pbDisplayPaused(_INTL("You got away safely!"))
          @decision = 3
		 elsif $shifted4==1
		 





		 
		    if @battlers[@party2.index(pkmn)+1].attackFactor>10 && pbRandom(100) > (50+@battlers[@party2.index(pkmn)+1].attackFactor)
             pbDisplay(_INTL("Before {1} could even think of resting, {2} attacked!", self.pbPlayer.name,pkmn.name))
             $player.damagePlayer(rand(pkmn.attack.to_i)+1)
		      pbSEPlay("normaldamage")
			elsif (pbRandom(100)+@battlers[@party2.index(pkmn)+1].attackFactor) >= 25
             pbDisplayBrief(_INTL("{1} chose to rest!", self.pbPlayer.name))
			  $player.playerstamina += (rand(6)+15).to_f
			  $player.increaseHealth(rand(15)+5)
		      pbSEPlay("normaldamage")
			  if $player.playersaturation == 0.0
			  $player.playerfood -= (rand(5)+1).to_f
			  $player.playerwater -= (rand(5)+1).to_f
			  $player.playerfood = 0.0 if $player.playerfood<0.0
			  $player.playerwater = 0.0 if $player.playerwater<0.0
			  else
			  $player.playersaturation -= (rand(5)+1).to_f
			  end


			else
             pbDisplayBrief(_INTL("{1} tried to rest, but got attacked!", self.pbPlayer.name))
              $player.damagePlayer(rand(pkmn.attack.to_i)+1)
		       pbSEPlay("normaldamage")






		    end





			@cmd = 5
		 elsif $shifted4==2
		  if $player.party.length > 0 && !$player.party[0].egg?
         pbDisplayPaused(_INTL("You throw out #{$player.party[0].name}!"))
		  @decision = [5,pkmn]
		  else
         pbDisplayPaused(_INTL("You don't have any POKeMON!"))
           @cmd = 5
		  
		  end
		 elsif $player.playerhealth > 0
		       runInjury=rand(100)
		       injury = rand(pkmn.attack.to_i)+1
		       playercrit = rand(24)+1
			    if decreaseStamina(5)
				  random = pbRandom(100)
				
				  if @battlers[@party2.index(pkmn)+1].attackFactor>=10  && $player.playerstamina <= 25 && random<51
                     pbDisplayPaused(_INTL("{1} leaps at you and bits you when you attempt to move!",pkmn.name)) 
				       $player.damagePlayer(injury)
				  elsif @battlers[@party2.index(pkmn)+1].attackFactor>=10 && $player.playerstamina <= 25 && random>49
                     pbSEPlay("Battle flee")
                     pbDisplayPaused(_INTL("While you were running away, {1} attacked!",pkmn.name)) 
				       $player.damagePlayer(injury)
		              pbSEPlay("normaldamage")
                     @decision = 3
				  elsif @battlers[@party2.index(pkmn)+1].attackFactor>=10
                  pbDisplayPaused(_INTL("You don't try it! {1} seems too jumpy, and is ready to lunge if you move!",pkmn.name)) 
				  elsif $player.playerstamina <= 25
                   pbDisplayPaused(_INTL("You are far too tired to be able to get away!"))
				     return -1
				  elsif random<=@runrate
                   pbSEPlay("Battle flee")
                   pbDisplayPaused(_INTL("You got away safely!"))
                   @decision = 3
				  else 
                   pbDisplayPaused(_INTL("You cannot flee!"))
				  end









			    else
				
				
                pbDisplayPaused(_INTL("You don't have enough Stamina to dodge!"))
				end
               @runrate += 1
		 end
 end

def choose_intent(battler)
  pkmn = battler.pokemon 
  attack = battler.attackFactor
  escape = battler.escapeFactor
  calm   = battler.catchFactor
  
  
  weights = {
    attack: 20,
    flee: 10,
    calm: 10,
    recover: 0,
    observe: 5
  }

  weights[:attack] += attack
  weights[:flee] += escape
  weights[:calm] += calm
  
  # Personality interactions
  # Calm makes aggression less likely
  weights[:attack] -= calm / 2

  # Fear makes a Pokemon less willing to engage calmly
  weights[:calm] -= escape / 2

  # Hostility makes a Pokemon less likely to flee
  weights[:flee] -= attack / 2
  
  # Injured Pokemon are more likely to rest
  if battler.canRecover?
  if pkmn.hp < pkmn.totalhp / 2 && 
    weights[:recover] += 20
  end
  if pkmn.hp < pkmn.totalhp / 4 && 
    weights[:recover] += 40
  end
  if pkmn.hp < pkmn.totalhp / 8
    weights[:recover] += 80
  end
  end
  # Don't allow negative chances
  weights.each_key do |key|
    weights[key] = 0 if weights[key] < 0
  end

 #    puts "Weights: #{weights.to_s}"
  total = weights.values.sum
  return :observe if total <= 0
  
  roll = rand(total)

  current = 0
  weights.each do |intent, weight|
    current += weight
    return intent if roll < current
  end

  return :observe
end
 
 def prevent_flee(battler)
   
      pkmn = battler.pokemon
      cmdChallenge = -1
      cmdCall = -1
      cmdBait = -1
      cmdChase = -1
      cmdNothing = -1
      commands = []
      commands[cmdChallenge = commands.length] = _INTL("Challenge") 
      commands[cmdCall = commands.length] = _INTL("Call") 
      commands[cmdBait = commands.length] = _INTL("Bait") if $bag.has?(:BAIT)
      commands[cmdChase = commands.length] = _INTL("Chase") 
      commands[cmdNothing = commands.length] = _INTL("Do Nothing") 
      command = @scene.pbShowCommands(_INTL("{1} is trying to flee, what do you do?", battler.pokemon.name), commands, -1)
      case command 
	    when cmdChallenge
		   #Add impact from Nature.
		   random = rand(100)
           success = random < (battler.attackFactor / 2)
           
           if success
             pbDisplayPaused(_INTL("You goad at {1}. {1} turns around!", pkmn.name))
             battler.escapeFactor -= rand(20..30)
             battler.attackFactor += rand(5..10)
             battler.catchFactor -= rand(5..10)
           else
             pbDisplayPaused(_INTL("You goad at {1}. {1} ignores your challenge and flees!", pkmn.name))
             @decision = 3
           end
	    when cmdCall
		   #Add impact from Nature.
		   random = rand(100)
           success = random < (battler.catchFactor / 2)
           if success
             pbDisplayPaused(_INTL("You call out to {1}. {1} hesitates!", pkmn.name))
             battler.escapeFactor -= rand(10..20)
             battler.attackFactor -= rand(5..10)
             battler.catchFactor += rand(5..10)
           else
             pbDisplayPaused(_INTL("You call out to {1}. {1} ignores your call and flees!", pkmn.name))
             @decision = 3
           end
	    when cmdBait
		   #Add impact from Nature.
		   random = rand(100)
           success = random < (battler.catchFactor / 4)
           $bag.remove(:BAIT, 1)
           if success
             pbDisplayPaused(_INTL("You throw down some bait. {1} hesitates!", battler.pokemon.name))
             battler.escapeFactor -= rand(20..40)
             battler.attackFactor -= rand(10..20)
             battler.catchFactor += rand(10..20)
           else
             pbDisplayPaused(_INTL("You throw down some bait. {1} ignores your challenge and flees!", battler.pokemon.name))
             @decision = 3
           end
	    when cmdChase
		   #Add impact from Nature.
		   random = rand(100)
           success = random < (battler.escapeFactor / 2)
           
           if success
             pbDisplayPaused(_INTL("You chase after {1}. {1} can't escape fast enough!", battler.pokemon.name))
             battler.catchFactor -= rand(10..20)
             battler.attackFactor -= rand(10..20)
             battler.escapeFactor += rand(5..10)
           else
             pbDisplayPaused(_INTL("You chase after {1}. {1} is running too fast!", battler.pokemon.name))
             @decision = 3
           end
	    when cmdNothing
         pbDisplayPaused(_INTL("{1} fled from battle!", pkmn.name))
         @decision = 3
	  
	  
	  end 
 
 end 


  def damage_unit(battle, user, target, amount)
  
     target.damageState.hpLost       = amount
     target.damageState.totalHPLost += amount
	 battle.pbInflictHPDamage(target)
	 battle.pbAnimateHitAndHPLost(user, [target])
	   battle.runrate -= 5
  end
 
 
   def calculate_damage_pokemon(pkmn) 
	 move = Pokemon::Move.new(:TACKLE)
	 move_damage = move.base_damage/3
	 pkmn_damage = pkmn.attack
     low = [pkmn_damage, move_damage].min
	 high = [pkmn_damage, move_damage].max
	 amount = rand(low..high)
	 return amount
  end 
  
 def enemy_turn(battler)
     pkmn = battler.pokemon
    intent = choose_intent(battler)
  attack = battler.attackFactor
  escape = battler.escapeFactor
  calm   = battler.catchFactor
 #    puts "Attack: #{attack}"
 #    puts "Escape: #{escape}"
 #    puts "Calm: #{calm}"
#     puts "Intent: #{intent}"
	if battler.flinch
      pbDisplay(_INTL("{1} flinched!", pkmn.name))
	  battler.flinch = false
	  return
	end 
    if @battlers[0].approach_offer == true && @battlers[0].offered_approach_last_turn == false
	  if intent == :calm
	   pbDisplayPaused(_INTL("The {1} carefully approached {2}.", battler.pokemon.name, $player.name))
	   battler.approached=true
	  else
	   pbDisplayPaused(_INTL("{1} doesn't seem very willing to approach.", battler.pokemon.name)) 
	    battler.catchFactor -= rand(10..20)
	  end 
	  @battlers[0].approach_offer = false
	  @battlers[0].offered_approach_last_turn = true
	  return 
	end
	case intent
	when :attack
	  if pbCanAttackPlayer2?(pkmn)
	      pbDisplayPaused(_INTL("{1} lunged at {2}!", pkmn.name, $player.name))
	      amount = calculate_damage_pokemon(pkmn) 
		  amount = [$player.playerhealth - 1,amount].min if @battlers[0].endure
		  amount = amount - (amount/3) if @battlers[0].braced
		  damage_unit(self, battler, @battlers[0], amount)
		  if @battlers[0].counter
		   act = SafariBattle::Acts::Attack::Punch.new(_INTL("PUNCH"), _INTL("Strike at your enemy with your fist."), 4)
		   act.act(self, battler) if act.can_add?
		  end
	  else
        pbDisplayPaused(_INTL("{1} seems ready to jump at you.", pkmn.name))
	  end

	when :flee
	  if @scene.pbCanSafariRun?(battler)
	    prevent_flee(battler)
	  else
        pbDisplayPaused(_INTL("{1} tried to escape, but couldn't find a way out!", pkmn.name))
	  end

	when :calm
	  result = rand(10)+1
	  case result 
	   when 1
	    pbDisplayPaused(_INTL("{1} seems willing to approach more.", pkmn.name)) 
		battler.catchFactor += rand(1..5)
	   when 2
	    pbDisplayPaused(_INTL("{1} looks like they are debating something.", pkmn.name)) 
		battler.escapeFactor -= rand(1..5)
	   when 3
	    pbDisplayPaused(_INTL("{1} looks like they are debating something.", pkmn.name)) 
		battler.attackFactor -= rand(1..5)
	   when 4
	     if battler.hp < battler.totalhp
	      pbDisplayPaused(_INTL("{1} is nursing it's wounds.", pkmn.name)) 
		 else
	      pbDisplayPaused(_INTL("{1} is studying you quietly.", pkmn.name)) 
		 end 
	   when 5
	     if battler.hp < battler.totalhp
	      pbDisplayPaused(_INTL("{1} is nursing it's wounds.", pkmn.name)) 
		 else
	      pbDisplayPaused(_INTL("{1} is studying you quietly.", pkmn.name)) 
		 end 
	   when 6
	     calm     = battler.catchFactor
         escape     = battler.escapeFactor
         attack = battler.attackFactor

         if calm > attack && calm > escape
	       pbDisplayPaused(_INTL("{1} looks quite calm.", pkmn.name)) 
         elsif attack > escape && attack > calm
	       pbDisplayPaused(_INTL("{1} looks ready to jump you.", pkmn.name)) 
         elsif escape > attack && escape > calm
	       pbDisplayPaused(_INTL("{1} looks ready to run.", pkmn.name)) 
		 else 
	       pbDisplayPaused(_INTL("{1} is studying you quietly.", pkmn.name)) 
         end
	   when 7
	    pbDisplayPaused(_INTL("{1} is studying you quietly.", pkmn.name)) 
	   when 8
	    pbDisplayPaused(_INTL("{1} is studying you quietly.", pkmn.name)) 
	   when 9
	    pbDisplayPaused(_INTL("{1} is studying you quietly.", pkmn.name)) 
	   when 10
	    pbDisplayPaused(_INTL("{1} is studying you quietly.", pkmn.name)) 
	  end 

	when :recover
    #  pbDisplay(_INTL("{1} tries to recover.", pkmn.name))
      # recovery logic here
      pbDisplayPaused(_INTL("{1} watches you carefully.", pkmn.name))

	when :observe
      pbDisplayPaused(_INTL("{1} watches you carefully.", pkmn.name))
	end

		  @battlers[0].counter = false
		  @battlers[0].braced = false
		  @battlers[0].endure = false
 end 

 def enemy_turn_old(battler)
   return false if @cmd == -1
   pkmn = battler.pokemon
   tryFlee= (battler.escapeFactor * 5 > pbRandom(100)) && battler.escapeFactor > battler.attackFactor
   if (tryFlee || self.rules["alwaysflee"]) && @scene.pbCanSafariRun?(battler)
      pbDisplayPaused(_INTL("{1} fled from battle!", pkmn.name))
      @decision = 3
    return true
   end

   if pbCanAttackPlayer2?(pkmn) && battler.attackFactor > battler.escapeFactor
      pbDisplay(_INTL("{1} lunged at #{$player.name}!", pkmn.name))
        pbAttackPlayer2(pkmn)
        return true
    end
   if @cmd == 2 && pbCanAttackPlayer2?(pkmn)
      pbDisplay(_INTL("{1} lunged at #{$player.name}!", pkmn.name))
        pbAttackPlayer2(pkmn)
        return true
   elsif @cmd == 2 
      pbDisplay(_INTL("{1} is angry!", pkmn.name))
   end
   if @cmd == 3 && pbCanAttackPlayer2?(pkmn)
      pbDisplay(_INTL("{1} lunged at #{$player.name}!", pkmn.name))
        pbAttackPlayer2(pkmn)
        return true
   elsif @cmd == 3 
      pbDisplay(_INTL("{1} is watching carefully!", pkmn.name))
   end
   if @cmd == 5
      pbDisplay(_INTL("{1} is watching carefully!", pkmn.name))
   end
   if @cmd == 7
   tryFlee= (battler.escapeFactor * 5 > pbRandom(100)) && battler.escapeFactor > battler.attackFactor
     if @scene.pbCanSafariRun?(battler) && tryFlee
      pbDisplayPaused(_INTL("{1} limped away from battle!", pkmn.name))
      @decision = 3
		 return true
	  else
      pbDisplay(_INTL("{1} is nursing their wounds!", pkmn.name))
	  end
   end
   if @cmd == 0
   tryFlee= (battler.escapeFactor * 5 > pbRandom(100)) && battler.escapeFactor > battler.attackFactor
     randomized = pbRandom(100)
     if @scene.pbCanSafariRun?(battler) && tryFlee
      pbDisplayPaused(_INTL("{1} limped away from battle!", pkmn.name))
      @decision = 3
		 return true
	 elsif pbCanAttackPlayer2?(pkmn)
      pbDisplay(_INTL("{1} lunged at #{$player.name}!", pkmn.name))
        pbAttackPlayer2(pkmn)
		 return true
	  else
      pbDisplay(_INTL("{1} is nursing their wounds!", pkmn.name))
	  end
   end
   if @cmd == 1
     if $shifted2==1 #Be nice
       pbDisplay(_INTL("{1} looks at you curiously!", pkmn.name))
     
	  else #Bait
       pbDisplay(_INTL("{1} is eating!", pkmn.name))
	  
     end
   end

   return true
end



 def player_turn
    needs_target = [0, 1, 2].include?(@index) && @party2.length>1
    if needs_target
	  value = pbShowCommands("Who do you want to attack?", @party2.map { |pkmn| _INTL(pkmn.name) }, -1)
      @target = @battlers[value + 1]
    else
      @target = @battlers[1]
    end
	
	@cmd.act(self, @target)
	@scene.closeBriefMessage
	if false
	case @index
      when 0   # Attack
		attacking
	  when 1 # Catch
		catching
	  when 2 #Appeal
		appealing
	  when 3 #Defend
		defending
	end
	end 
 end

 #Command -1 == do not perform enemy turn
 #Command 0 == Catch
 #Command 1 == Appeal
 #Command 2 == Attack
 #Command 3 == defend
 #Command 5 == did nothing to enemy
 #Command 7 == Heavy Damage Reaction




end


def pbSafariBattle(species=nil, level=nil,pkmn=nil)
	  $game_temp.in_safari = true
    $PokemonGlobal.nextBattleBGM = "tight spot"
  # Generate a wild Pokémon based on the species and level
  
  pkmn = pbGenerateWildPokemon(species, level) if pkmn.nil?
  foeParty = [pkmn] if pkmn.is_a?(Pokemon)
  # Calculate who the trainer is
  playerTrainer = $player
  # Create the battle scene (the visual side of it)
  scene = BattleCreationHelperMethods.create_battle_scene
  # Create the battle class (the mechanics side of it)
  battle = SafariBattle.new(scene, playerTrainer, foeParty)
  BattleCreationHelperMethods.prepare_battle(battle)
  # Perform the battle itself
  decision = 0
  pbBattleAnimation(pbGetWildBattleBGM(foeParty), 0, foeParty) {
    pbSceneStandby {
      decision = battle.pbStartBattle
    }
  }
  Input.update
  # Save the result of the battle in Game Variable 1
  #    0 - Undecided or aborted
  #    1 - Pokemon KOed
  #    2 - Player KOed
  #    3 - Player or wild Pokémon ran from battle, or player forfeited the match
  #    4 - Wild Pokémon was caught
  pbSet(1, decision)
  EventHandlers.trigger(:on_wild_battle_end, species, level, decision)
  # Used by the Poké Radar to update/break the chain
  # Return the outcome of the battle
  $game_temp.in_safari = false
  return decision
end