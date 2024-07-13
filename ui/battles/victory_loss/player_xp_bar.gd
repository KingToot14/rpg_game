class_name PlayerXpBar
extends Control

# --- Signals --- #
signal done_adding()

# --- Variables --- #
var is_done_adding := false

@export var player_index: int

@export var melee_icon: Texture2D
@export var ranged_icon: Texture2D
@export var healer_icon: Texture2D
@export var magic_icon: Texture2D

@export var increment_duration := 5.0
@export var level_up_duration := 0.50

# --- References --- #
@onready var icon_rect := %'icon' as TextureRect
@onready var fill_rect := %'bar_fill' as Control
@onready var level_label := %'level_label' as RichTextLabel
@onready var xp_label := %'xp_label' as RichTextLabel

@onready var level_up_rect := %'level_up_bar' as Control

# --- Functions --- #
func _ready() -> void:
	load_player_info()

func load_player_info() -> void:
	var data = DataManager.players[player_index]
	
	if not (data and data.role != PlayerDataChunk.PlayerRole.NONE):
		hide()
		return
	
	# icon
	match data.role:
		PlayerDataChunk.PlayerRole.MELEE:
			icon_rect.texture = melee_icon
		PlayerDataChunk.PlayerRole.RANGED:
			icon_rect.texture = ranged_icon
		PlayerDataChunk.PlayerRole.HEALER:
			icon_rect.texture = healer_icon
		PlayerDataChunk.PlayerRole.MAGIC:
			icon_rect.texture = magic_icon
	
	# level
	level_label.text = "Level " + str(data.level)
	
	# xp
	xp_label.text = str(data.curr_xp) + "/" + str(data.xp_to_next)
	var prev_xp = data.get_xp_to_level(data.level - 1)
	var fill_size = floor(50 * (1.0 * (data.curr_xp - prev_xp) / (data.xp_to_next - prev_xp)))
	
	fill_rect.size.x = fill_size
	fill_rect.visible = fill_size >= 2

func set_xp(xp: int) -> void:
	if DataManager.players[player_index].set_xp(xp):
		level_up_rect.modulate.a = 1.0
		var tween = create_tween()
		
		tween.tween_interval(level_up_duration / 2.0)
		tween.tween_property(level_up_rect, ^'modulate:a', 0.0, level_up_duration / 2.0)
	
	load_player_info()

func add_xp(value: int, collected := 0) -> void:
	var xp = value - collected
	
	if xp <= 0:
		is_done_adding = true
		done_adding.emit()
		return
	
	var data = DataManager.players[player_index]
	
	if not (data and data.role != PlayerDataChunk.PlayerRole.NONE):
		is_done_adding = true
		done_adding.emit()
		return
	
	# get values
	var initial_xp = data.curr_xp
	var remaining_xp = data.get_remaining_xp()
	var to_xp = initial_xp + min(xp, remaining_xp)
	
	var tween = create_tween()
	
	tween.tween_method(set_xp, initial_xp, to_xp, increment_duration * (1.0 * min(xp, remaining_xp) / value))
	
	# level up occurred
	if xp - (collected + min(xp, remaining_xp)) > 0:
		tween.tween_interval(level_up_duration)
	
	tween.finished.connect(add_xp.bind(xp, collected + min(xp, remaining_xp)))
