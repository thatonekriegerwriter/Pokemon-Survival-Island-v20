#------------------------------------------------------------------------------
#Change BGMs script by aiyinsi
#Version: 1.0
#For Essentials V19
#------------------------------------------------------------------------------
####################################SETTINGS###################################
#------------------------------------------------------------------------------
#
#This script allows you to change the bgm that is played naturaly on maps.
#
#------------------------------------------------------------------------------
#SETUP INSTRUCTIONS:
#
# 1. Make a new script section somewhere above [[ Compiler ]] and paste this 
#    script in there
# 2. Alter the REPLACE_BGMS Array to what you need. The structure is the following:
#    -Each Entry represents one BGM that can replace the usual bgm on maps under 
#     certain conditions
#    -Each Entry is made up out of 5 elements. The last 3 being optional.
#     [identifier, bgm_name, map_selector, volume, pitch] Leaving out optional
#     elements will treat those as nil.
#       -identifier: The key that you are going to use to turn that bgm on or off.
#       -bgm_name: The name of the BGM file in Audio/BGM.
#       -map_selector: Used to tell the script on what maps the bgm is supposed 
#        to play. The following filters are possible:
#         -An Array of Integers. The BGM will be played on the maps with those 
#          IDs. It still needs to in an array even if it is only a single map id.
#          For Example: [1,2,3] or [69]
#         -"indoor" or "outdoor" will play the bgms either on all indoor or 
#          outdoor maps.
#         -nil will make the bgm play on all maps.
#       -volume: sets the volume to the given number. Sets it to the maps native
#        volume if nil.
#       -pitch: sets the pitch to the given number. Sets it to the maps native
#        pitch if nil.
#     If multiple Entries are activated the higher one in the list will be
#     prioritised.
# 3. Call playSpecialBGM(identifier) to activate the BGM being played under the
#    conditions set in REPLACE_BGMS. If the bgm on the map the player is on
#    meets the conditions set in REPLACE_BGMS the bgm will change to the new one.
# 4. Call deactivateSpecialBGM(identifier) to deactivate the BGM being played 
#    under the conditions set in REPLACE_BGMS. If the bgm on the map the player 
#    is on meets the conditions set in REPLACE_BGMS the bgm will change to the 
#    new one.
#
#
#------------------------------------------------------------------------------
#EXAMPLE:
#REPLACE_BGMS = [  
#                 ["Pitched", "Battle Elite", [3, 8, 5], 95, 200],
#                 ["Quiet", "Battle Elite", "outdoor" , 50],
#                 ["Loud", "Battle Elite", nil , 80],
#                 ["Best Song", "Poke Mart"]
#               ]
#
#To activate the Poke Mart music playing on all maps you'd need to call
#playSpecialBGM("Best Song") in an event or script.
#To turn it off again you call deactivateSpecialBGM("Best Song")
#
#If you call playSpecialBGM("Loud") the Battle Elite bgm will start playing on 
#all maps. Calling playSpecialBGM("Quiet") will overwrite the "Loud" bgm
#because it is higher up on the REPLACE_BGMS array. Therefore the Battle Elite
#theme will play with 50 volume outdoors and with 80 volume indoors.
#
#------------------------------------------------------------------------------
#EDIT THIS ARRAY:
REPLACE_BGMS = [
				
               ]