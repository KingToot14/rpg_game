class_name EntityUi
extends Node

# --- Variables --- #
var targeting_marker: Node
var targeting_origin: float
var targeting_tween: Tween

@export var normal_texture: Texture2D
@export var hovered_texture: Texture2D

@onready var effect_icon_rect := %'effect_icon' as TextureRect
@onready var effect_list_rect := %'effect_list' as Control

var is_mouse_over := false
var is_over_effects := false

# --- References --- #
@onready var parent := $".." as Entity
@onready var effect_node := $"top_holder/effect_list/effect" as Control

# --- Functions --- #
func _ready() -> void:
	targeting_marker = %'targeting_marker'
	
	# setup targeting
	targeting_origin = targeting_marker.position.y
	targeting_marker.visible = true
	targeting_marker.modulate.a = 0
	
	# setup signals
	parent.mouse_entered.connect(_on_mouse_entered)
	parent.mouse_exited.connect(_on_mouse_exited)
	
	update_top()

func _on_targetable_set(targetable: bool) -> void:
	var tween = create_tween().set_parallel()
	
	if targetable:
		targeting_marker.modulate.a = 0
		targeting_marker.position.y = targeting_origin + 4
		tween.tween_property(targeting_marker, 'modulate:a', 1.0, 0.25)
		tween.tween_property(targeting_marker, 'position:y', targeting_origin, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	else:
		tween.tween_property(targeting_marker, 'modulate:a', 0.0, 0.25)
		tween.tween_property(targeting_marker, 'position:y', targeting_origin + 4, 0.25)
	
	update_top()

func _on_mouse_entered():
	targeting_marker.texture = hovered_texture
	
	targeting_tween = create_tween().set_loops(0)
	targeting_tween.tween_property(targeting_marker, 'position:y', targeting_origin - 4, 0.75)
	targeting_tween.tween_property(targeting_marker, 'position:y', targeting_origin, 0.0)
	
	update_top()

func _on_mouse_exited():
	targeting_marker.texture = normal_texture
	
	if targeting_tween:
		targeting_tween.stop()
		targeting_marker.position.y = targeting_origin
	
	update_top()

func _on_ui_entered() -> void:
	is_mouse_over = true
	update_top()

func _on_ui_exited() -> void:
	is_mouse_over = false
	update_top()

func update_top() -> void:
	if parent.targeting.targetable or len(parent.status_effects.status_effects) <= 0:
		effect_icon_rect.visible = false
		effect_list_rect.visible = false
		return
	
	effect_icon_rect.visible = not is_mouse_over
	effect_list_rect.visible = is_mouse_over

func _on_status_effect_added():
	update_effects()
	update_top()

func update_effects() -> void:
	var effects = parent.status_effects.status_effects
	
	# hide all effect buttons
	for child in effect_list_rect.get_children():
		child.set_effect(null)
	
	# enable effects that exist
	for i in range(len(effects)):
		if i >= effect_list_rect.get_child_count():
			effect_list_rect.add_child(effect_node.duplicate(0b0111))
		
		effect_list_rect.get_child(i).set_effect(effects[i])
