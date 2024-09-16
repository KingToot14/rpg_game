class_name BattleActionButton
extends BaseButton

# --- Variables --- #
@export var normal_texture: Texture2D
@export var hovered_texture: Texture2D

@export var backing_rect: TextureRect
var origin: float
var tween_duration := 0.15
var tween: Tween

# --- Functions --- #
func _ready() -> void:
	origin = position.y

func _on_mouse_entered() -> void:
	backing_rect.texture = hovered_texture

func _on_mouse_exited() -> void:
	backing_rect.texture = normal_texture

func show_button() -> void:
	if tween:
		tween.kill()
	tween = create_tween().set_parallel()
	
	show()
	tween.tween_property(self, 'modulate:a', 1.0, tween_duration)
	tween.tween_property(self, 'position:y', origin, tween_duration).from(origin + 8)

func hide_button() -> void:
	if tween:
		tween.kill()
	tween = create_tween().set_parallel()
	
	tween.tween_property(self, 'modulate:a', 0.0, tween_duration)
	tween.tween_property(self, 'position:y', origin + 8, tween_duration)
	tween.finished.connect(hide)
