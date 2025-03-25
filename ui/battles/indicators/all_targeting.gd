class_name AllTargeting
extends BaseButton

# --- Variables --- #
@export var start_pos := 0
@export var tween_pos := -4

@export var normal_texture: Texture2D
@export var hovered_texture: Texture2D

var tween: Tween

# --- Functions --- #
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	pressed.connect(_on_pressed)
	
	hide()

func _on_mouse_entered() -> void:
	$'texture'.texture = hovered_texture
	
	tween = create_tween().set_loops(0)
	tween.tween_property($'texture', 'position:x', tween_pos, 0.75)
	tween.tween_property($'texture', 'position:x', start_pos, 0.0)

func _on_mouse_exited() -> void:
	$'texture'.texture = normal_texture
	
	if tween:
		tween.stop()
		$'texture'.position.x = start_pos

func _on_pressed() -> void:
	for entity in TargetingHelper.get_alive_entities(&'player'):
		entity.brain._on_entity_selected(null)
