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
var spawned_players # ! Set by Game Scene
var _current_boss_player: Player
var _is_countdown_active = false
var _win_screen
var _game_scene: GameScene
var _hud: Hud
#endregion
#region @onready Variables
#endregion

#region Event Methods
func _ready() -> void:
	MultiplayerInputSetup.setup_multiplayer_input(MAX_PLAYERS)
#endregion
#region Signal Handlers
func _on_player_knocked():
	if _is_win_condition_active() and _current_boss_player != null: _trigger_win(_current_boss_player)


func _on_player_recovered():
	if _is_countdown_active: _stop_win()


func _on_player_spawned():
	spawned_players += 1


func _on_knock_out_shown():
	_game_scene.audio_stream_player["parameters/switch_to_clip"] = "Ost 4 Outro"


func _on_player_corner_entered():
	if spawned_players < 2: return
	
	var active_corners = get_tree().get_nodes_in_group("PlayerCorner").filter(func(p: PlayerCorner): return p.is_player_inside) as Array
	if active_corners.size() == spawned_players:
		_game_scene.spawn_belt()
		_game_scene.hide_tutorial()
		_game_scene.audio_stream_player["parameters/switch_to_clip"] = "Ost 2 Transition"
		for corner in get_tree().get_nodes_in_group("PlayerCorner"):
			if !corner.is_player_inside: _hud.hide_join_ui(corner.player.player_num)
			
			corner.disable_collision()
#endregion
#region Regular Methods
func register_player_signals():
	for player in get_tree().get_nodes_in_group("Player"):
		player.knocked_out.connect(_on_player_knocked.unbind(1))
		player.recovered.connect(_on_player_recovered)
		player.upgraded.connect(func(p):
			_current_boss_player = p
			if _is_win_condition_active(): _trigger_win(_current_boss_player)
		)
		player.downgraded.connect(func(p):
			if p == _current_boss_player: _current_boss_player = null
		)
		player.spawned.connect(_on_player_spawned)


func register_player_corners():
	for corner in get_tree().get_nodes_in_group("PlayerCorner"):
		corner.player_entered.connect(_on_player_corner_entered)


func register_game_scene(game_scene: GameScene):
	_game_scene = game_scene


func register_hud(hud: Hud):
	_hud = hud


func register_win_screen(win_screen: WinScreen):
	_win_screen = win_screen
	_win_screen.ko_label_shown.connect(_on_knock_out_shown)


func _is_win_condition_active():
	if spawned_players < 2: return
	
	var knocked_players = get_tree().get_nodes_in_group("Player").filter(func(p: Player): return p.is_knocked_out) as Array
	var knocked_count = knocked_players.size()
	return knocked_count == (spawned_players - 1)


func _trigger_win(winning_player):
	_is_countdown_active = true
	_win_screen.set_winning_player(winning_player)
	_win_screen.start_countdown()

func _stop_win():
	_win_screen.stop_countdown()
	_is_countdown_active = false
#endregion
