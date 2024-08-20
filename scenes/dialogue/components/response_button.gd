class_name ResponseButton
extends BaseButton

# --- Variables --- #
@export var tween_time := 0.15
@export var hover_offset := 4.0
var curr_pos: float

@export var normal_key: StringName
@export var hover_key: StringName

var tween

# --- References --- #
@onready var label := %'label' as RichTextLabel
@onready var outline_rect := %'outline' as ColorRect

# --- Functions --- #
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
	label = %'label'
	
	label.text = response.text
	custom_minimum_size.x = label.get_content_width() + 7
	
	curr_pos = 100.0 - custom_minimum_size.x
