class_name ResponseButton
extends BaseButton

# --- Variables --- #
@export var label: RichTextLabel
@export var outline_rect: ColorRect

@export var tween_time := 0.15
@export var hover_offset := 4.0
var curr_pos: float

@export var normal_key: StringName
@export var hover_key: StringName

var tween

# --- Functions --- #
func _ready() -> void:
	outline_rect = $"outline"
	curr_pos = position.x

func _on_mouse_entered() -> void:
	highlight(true)

func _on_mouse_exited() -> void:
	highlight(false)

func highlight(hovered: bool) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	
	tween.tween_property(self, 'position:x', curr_pos - (hover_offset if hovered else 0), tween_time)
	outline_rect.update_theme(hover_key if hovered else normal_key)

func set_response(response) -> void:
	label.text = "[center]" + response.text + "[/center]"
