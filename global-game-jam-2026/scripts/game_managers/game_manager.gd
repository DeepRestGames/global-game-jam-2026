extends Node

#region Signals
#endregion
#region Enums
#endregion
#region Constants
var MAX_PLAYERS = 4
#endregion
#region Static Variables
#endregion
#region @export Variables
#endregion
#region Regular Variables
var _knocked_players = 0
var _current_boss_player: Player
#endregion
#region @onready Variables
#endregion

#region Event Methods
func _ready() -> void:
	MultiplayerInputSetup.setup_multiplayer_input(MAX_PLAYERS)
#endregion
#region Signal Handlers
func _on_player_knocked():
	_knocked_players += 1
	if _knocked_players == (MAX_PLAYERS - 1): _trigger_win()


func _on_player_recovered():
	_knocked_players -= 1
#endregion
#region Regular Methods
func register_player_signals():
	for player in get_tree().get_nodes_in_group("Player"):
		player.knocked_out.connect(_on_player_knocked.unbind(1))
		player.recovered.connect(_on_player_recovered)
		player.upgraded.connect(func(p): _current_boss_player = p)


func _trigger_win():
	#var win_screen = get_tree().get_first_node_in_group("WinScreen")
	#win_screen.setup(_current_boss_player)
	#win_screen.show()
	print("win %s" % _current_boss_player.player_name)
#endregion
