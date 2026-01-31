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
var _is_countdown_active = false
#endregion
#region @onready Variables
#endregion

#region Event Methods
func _ready() -> void:
	MultiplayerInputSetup.setup_multiplayer_input(MAX_PLAYERS)
#endregion
#region Signal Handlers
func _on_player_knocked():
	if _current_boss_player:
		print("boss %s" % _current_boss_player.player_name)
	else:
		print("N/A")
	_knocked_players += 1
	if _is_win_condition_active() and _current_boss_player != null: _trigger_win()


func _on_player_recovered():
	print("boss %s" % _current_boss_player.player_name)
	_knocked_players -= 1
	if _is_countdown_active: _stop_win()
#endregion
#region Regular Methods
func register_player_signals():
	for player in get_tree().get_nodes_in_group("Player"):
		player.knocked_out.connect(_on_player_knocked.unbind(1))
		player.recovered.connect(_on_player_recovered)
		player.upgraded.connect(func(p):
			_current_boss_player = p
			if _is_win_condition_active(): _trigger_win()
		)
		player.downgraded.connect(func(p):
			if p == _current_boss_player: _current_boss_player = null
		)


func _is_win_condition_active():
	return _knocked_players == (MAX_PLAYERS - 1)


func _trigger_win():
	print("win %s" % _current_boss_player.player_name)
	_is_countdown_active = true
	var win_screen = get_tree().get_first_node_in_group("WinScreen") as WinScreen
	win_screen.start_countdown()

func _stop_win():
	var win_screen = get_tree().get_first_node_in_group("WinScreen") as WinScreen
	win_screen.stop_countdown()
	_is_countdown_active = false
#endregion
