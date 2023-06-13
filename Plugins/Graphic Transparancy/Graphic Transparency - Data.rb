#---------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------#
#----------------------------------------------Graphic Transparency---------------------------------------------#
#--------------------------------------------------Made by Arcky------------------------------------------------#
#--------------Contact Arcky#1021 on Discord if you got any bugs or future improvements suggestions-------------#
#-----------------------------------------------Only edit this file!--------------------------------------------#
#---------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------#
#@eventIDs = [
#    [21,
#        [3, 5, 6, 8, 9, 11]
#    ],
#    [23,
#        [11, 12]
#    ]
#]
#add here the event ID's for each event you want to use the transparancy on. First number is the map ID, the next numbers are the event ID's in an array format, see example above.
#Please follow the guide on the recource page if you are unsure how to edit this.
#make sure this is never empty or it'll throw an error saying it is empty. (The script can't run in any possible way if this is empty anyways)
@eventIDs = [
#    [338,[4, 5]]
]
#@eventPositionsToIgnore = [
#    [23,
#        [5, 14],
#        [7, 14]
#    ],
#]
#add here the positions for the script to ignore that you don't want to trigger the transparency when the player is on that specific position on the map.
#First number is the map ID, the second and third number are respectivly the x and y position on the game map. See example above.
#unlike @eventIDs, @eventPositionsToIgnore may be empty if you don't need it.
#If you don't need this feature, just add a # before every line or make it completely empty but keep the brackets like this @eventPositionsToIgnore = [[[]]]
@eventPositionsToIgnore = [
#    [map ID,
#        [position X, position Y],
#        [position X, position Y]
#    ]
]