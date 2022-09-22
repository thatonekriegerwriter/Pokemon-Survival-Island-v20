module Pokeathlon
	class Party_Scene_Athlon < PokemonParty_Scene

		def pbStartScene(party,starthelptext,annotations=nil,multiselect=false, medal=false)
			@sprites = {}
			@party = party

			# Show stats
			@show_athlon = ShowStatsInMenu.new

			@viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
			@viewport.z = 99999
			@multiselect = multiselect
			# New
			@sprites["partybg"] = Sprite.new(@viewport)
			@sprites["partybg"].bitmap = Bitmap.new("Graphics/Pictures/Party/bg")

			@sprites["messagebox"] = Window_AdvancedTextPokemon.new("")
			@sprites["messagebox"].viewport       = @viewport
			@sprites["messagebox"].visible        = false
			@sprites["messagebox"].letterbyletter = true
			pbBottomLeftLines(@sprites["messagebox"],2)
			@sprites["helpwindow"] = Window_UnformattedTextPokemon.new(starthelptext)
			@sprites["helpwindow"].viewport = @viewport
			@sprites["helpwindow"].visible  = true
			pbBottomLeftLines(@sprites["helpwindow"],1)
			pbSetHelpText(starthelptext)
			# Add party Pokémon sprites
			for i in 0...Settings::MAX_PARTY_SIZE
				if @party[i]
					@sprites["pokemon#{i}"] = PokemonPartyPanel.new(@party[i],i,@viewport)
				else
					@sprites["pokemon#{i}"] = PokemonPartyBlankPanel.new(@party[i],i,@viewport)
				end

				# New
				@sprites["pokemon#{i}"].x -= Settings::SCREEN_WIDTH / 2 * (i % 2) if SHOW_WIDTH

				@sprites["pokemon#{i}"].text = annotations[i] if annotations
			end
			if @multiselect
				@sprites["pokemon#{Settings::MAX_PARTY_SIZE}"] = PokemonPartyConfirmSprite.new(@viewport)
				@sprites["pokemon#{Settings::MAX_PARTY_SIZE + 1}"] = PokemonPartyCancelSprite2.new(@viewport)
			else
				@sprites["pokemon#{Settings::MAX_PARTY_SIZE}"] = PokemonPartyCancelSprite.new(@viewport)
			end
			# Select first Pokémon
			@activecmd = 0
			@sprites["pokemon0"].selected = true

			# Medal
			@medal = medal

			pbFadeInAndShow(@sprites) { update }

			# Create
			@show_athlon.create_custom(0, medal)
		end

		def pbEndScene
			@show_athlon.endScene
			super
		end

		def update
			super
			yield if block_given?
		end

		#---------------#
		# Create custom #
		#---------------#
		def custom_bottom_right(window)
			window.x = Settings::SCREEN_WIDTH  - window.width
			window.y = Settings::SCREEN_HEIGHT - window.height
		end

		def custom_bottom_left(window)
			window.x = 0
			window.y = Settings::SCREEN_HEIGHT - window.height
		end

		def pbShowCommands(helptext,commands,index=0, pkmn=nil)
			ret = -1
			helpwindow = @sprites["helpwindow"]
			helpwindow.visible = true
			using(cmdwindow = Window_CommandPokemonColor.new(commands)) {
				cmdwindow.z     = @viewport.z + 1
				cmdwindow.index = index

				# New
				custom_bottom_right(cmdwindow)

				# New
				helpwindow.resizeHeightToFit(helptext, Settings::SCREEN_WIDTH - cmdwindow.width)

				helpwindow.text = helptext

				# New
				custom_bottom_left(helpwindow)

				loop do
					Graphics.update
					Input.update
					cmdwindow.update

					# New
					self.update { @show_athlon.update_main(pkmn, @medal) }

					if Input.trigger?(Input::BACK)
						pbPlayCancelSE
						ret = -1
						break
					elsif Input.trigger?(Input::USE)
						pbPlayDecisionSE
						ret = cmdwindow.index
						break
					end
				end
			}
			return ret
		end

		def pbChoosePokemon(switching=false,initialsel=-1,canswitch=0)
			for i in 0...Settings::MAX_PARTY_SIZE
				@sprites["pokemon#{i}"].preselected = (switching && i==@activecmd)
				@sprites["pokemon#{i}"].switching   = switching
			end
			@activecmd = initialsel if initialsel>=0
			pbRefresh

			loop do
				Graphics.update
				Input.update

				oldsel = @activecmd
				key = -1
				key = Input::DOWN if Input.repeat?(Input::DOWN)
				key = Input::RIGHT if Input.repeat?(Input::RIGHT)
				key = Input::LEFT if Input.repeat?(Input::LEFT)
				key = Input::UP if Input.repeat?(Input::UP)
				if key>=0
					@activecmd = pbChangeSelection(key,@activecmd)
				end
				if @activecmd!=oldsel   # Changing selection
					pbPlayCursorSE
					numsprites = Settings::MAX_PARTY_SIZE + ((@multiselect) ? 2 : 1)
					for i in 0...numsprites
						@sprites["pokemon#{i}"].selected = (i==@activecmd)
					end
				end
				cancelsprite = Settings::MAX_PARTY_SIZE + ((@multiselect) ? 1 : 0)
				if Input.trigger?(Input::ACTION) && canswitch==1 && @activecmd!=cancelsprite
					pbPlayDecisionSE
					return [1,@activecmd]
				elsif Input.trigger?(Input::ACTION) && canswitch==2
					return -1
				elsif Input.trigger?(Input::BACK)
					pbPlayCloseMenuSE if !switching
					return -1
				elsif Input.trigger?(Input::USE)
					if @activecmd==cancelsprite
						(switching) ? pbPlayDecisionSE : pbPlayCloseMenuSE
						return -1
					else
						pbPlayDecisionSE
						return @activecmd
					end
				end

				# Change pokemon / New
				self.update { @show_athlon.update_main((@activecmd==cancelsprite ? nil : @activecmd), @medal) }

			end
		end

	end

	class PartyScreen_Athlon < PokemonPartyScreen

		# Choose multi pokemon
		def pbPokemonMultipleEntryScreenEx(number, medal)
			annot = []
			statuses = []
			ordinals  = [_INTL("INELIGIBLE"), _INTL("NOT ENTERED"), _INTL("BANNED")]
			positions = [_INTL("FIRST"), _INTL("SECOND"), _INTL("THIRD"), _INTL("FOURTH"),
									 _INTL("FIFTH"), _INTL("SIXTH"), _INTL("SEVENTH"), _INTL("EIGHTH"),
									 _INTL("NINTH"), _INTL("TENTH"), _INTL("ELEVENTH"), _INTL("TWELFTH")]
			for i in 0...Settings::MAX_PARTY_SIZE
				if i < positions.length
					ordinals.push(positions[i])
				else
					ordinals.push("#{i + 1}th")
				end
			end
			ret = nil
			addedEntry = false
			@party.each_with_index { |pkmn, i|
				statuses[i] = pkmn.able? ? 1 : 2
				annot[i]    = ordinals[statuses[i]]
			}

			# New
			@scene.pbStartScene(@party,_INTL("Choose Pokémon and confirm."), annot, true, medal)

			loop do
				realorder = []
				@party.each_with_index { |_, i|
					@party.each_with_index { |_, j|
						next if statuses[j] != i + 3
						realorder << j
						break
					}
				}
				realorder.each_with_index { |real, i| statuses[real] = i + 3 }
				@party.each_with_index { |_, i| annot[i] = ordinals[statuses[i]] }
				@scene.pbAnnotate(annot)
				@scene.pbSelect(Settings::MAX_PARTY_SIZE) if realorder.size == number && addedEntry
				@scene.pbSetHelpText(_INTL("Choose Pokémon and confirm."))
				pkmnid = @scene.pbChoosePokemon
				addedEntry = false
				# Confirm was chosen
				if pkmnid == Settings::MAX_PARTY_SIZE
					ret = {}
					realorder.each { |real| ret[@party[real]] = real }
					break
				end
				break if pkmnid < 0 # Cancelled
				cmdEntry   = -1
				cmdNoEntry = -1
				cmdSummary = -1
				commands = []
				if (statuses[pkmnid] || 0) == 1
					commands[cmdEntry = commands.length]   = _INTL("Entry")
				elsif (statuses[pkmnid] || 0) > 2
					commands[cmdNoEntry = commands.length] = _INTL("No Entry")
				end
				pkmn = @party[pkmnid]
				commands[commands.length] = _INTL("Cancel")

				# New
				command = @scene.pbShowCommands(_INTL("Do what with {1}?", pkmn.name), commands, 0, (@party.index(pkmn))) if pkmn

				if cmdEntry>=0 && command==cmdEntry
					if realorder.size >= number && number > 0
						pbDisplay(_INTL("No more than {1} Pokémon may enter.", ruleset.number))
					else
						statuses[pkmnid] = realorder.size + 3
						addedEntry = true
						pbRefreshSingle(pkmnid)
					end
				elsif cmdNoEntry >= 0 && command == cmdNoEntry
					statuses[pkmnid] = 1
					pbRefreshSingle(pkmnid)
				end
			end
			@scene.pbEndScene
			return ret
		end

	end

end