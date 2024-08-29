extends Node

# --- Variables --- #
@export var horizontal_padding := 10.0
@export var vertical_padding := 10.0

# --- References --- #
@onready var tooltip_rect := %'tooltip' as Control
@onready var text_rect := %'text' as Control
@onready var pointer_rect := %'pointer' as Control

@onready var title_label := %'title_label' as RichTextLabel
@onready var body_label := %'body_label' as RichTextLabel

var title_size := 9
var body_size := 18

@export var fade_time := 0.10

# --- Functions --- #
func _ready() -> void:
	tooltip_rect.modulate.a = 0.0

func _process(_delta: float) -> void:
	tooltip_rect.position = get_viewport().get_mouse_position()
	
	update_position()

func set_title_text(text: String) -> void:
	title_label.text = text
	
	title_size = title_label.get_line_count() * 8 + 2
	
	if text.is_empty():
		title_size = 0
	
	update_size()

func set_body_text(text: String) -> void:
	body_label.text = text
	
	body_size = body_label.get_line_count() * 8 + 2
	
	if text.is_empty():
		body_size = 0
	
	update_size()

func clear_tooltip() -> void:
	set_title_text("")
	set_body_text("")

func set_width(width: int) -> void:
	text_rect.size.x = width

func has_title(text: String) -> bool:
	return title_label.text == text

func has_body(text: String) -> bool:
	return body_label.text == text

func update_size() -> void:
	text_rect.size.y = title_size + body_size + 5
	
	if title_size > 0 and body_size > 0:
		text_rect.size.y += 1

func update_position() -> void:
	# horizontal
	if tooltip_rect.position.x > 480 - text_rect.size.x - vertical_padding:
		text_rect.position.x = -text_rect.size.x - 2
		pointer_rect.position.x = -pointer_rect.size.x - 1
	else:
		text_rect.position.x = 2
		pointer_rect.position.x = 1
	
	text_rect.position.y = -text_rect.size.y - 2
	
	#text_rect.global_position.x = clamp(global_position.x, 0, 480 - text_rect.size.x)

func show_tooltip() -> void:
	var tween = create_tween()
	
	tween.tween_property(tooltip_rect, 'modulate:a', 1.0, fade_time)

func hide_tooltip() -> void:
	var tween = create_tween()
	
	tween.tween_property(tooltip_rect, 'modulate:a', 0.0, fade_time)
