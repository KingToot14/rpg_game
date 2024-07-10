extends Node2D

# --- Variables --- #
@export var horizontal_padding := 10.0
@export var vertical_padding := 10.0

@export var tooltip_rect: Control
@export var pointer_rect: Control

@export var title_label: RichTextLabel
@export var body_label: RichTextLabel

var title_size := 9
var body_size := 18

@export var fade_time := 0.10

# --- Functions --- #
func _ready() -> void:
	modulate.a = 0.0

func _process(_delta: float) -> void:
	position = get_viewport().get_mouse_position()
	
	update_position()

func set_title_text(text: String) -> void:
	title_label.text = text
	
	title_size = title_label.get_line_count() * 7 + 2
	
	if text.is_empty():
		title_size = 0
	
	update_size()

func set_body_text(text: String) -> void:
	body_label.text = text
	
	body_size = body_label.get_line_count() * 7 + 2
	
	if text.is_empty():
		body_size = 0
	
	update_size()

func set_width(width: int) -> void:
	tooltip_rect.size.x = width

func update_size() -> void:
	tooltip_rect.size.y = title_size + body_size + 5
	
	if title_size > 0 and body_size > 0:
		tooltip_rect.size.y += 1

func update_position() -> void:
	# horizontal
	if position.x > 480 - tooltip_rect.size.x - vertical_padding:
		tooltip_rect.position.x = -tooltip_rect.size.x - 2
		pointer_rect.position.x = -pointer_rect.size.x - 1
	else:
		tooltip_rect.position.x = 2
		pointer_rect.position.x = 1
	
	tooltip_rect.position.y = -tooltip_rect.size.y - 2
	
	#tooltip_rect.global_position.x = clamp(global_position.x, 0, 480 - tooltip_rect.size.x)

func show_tooltip() -> void:
	var tween = create_tween()
	
	tween.tween_property(self, 'modulate:a', 1.0, fade_time)

func hide_tooltip() -> void:
	var tween = create_tween()
	
	tween.tween_property(self, 'modulate:a', 0.0, fade_time)
