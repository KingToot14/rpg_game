class_name ReflectionTexture
extends Sprite2D

# --- Variables --- #
@export var image_size: Vector2
@export var bottom_pos: Node2D
@export var reflection_offset: float

@export_group("Sprites")
@export var sprites: Array[Sprite2D]

# --- Functions --- #
func _ready():
	generate_texture()

func generate_texture():
	texture = ImageTexture.new()
	var image := Image.create(int(image_size.x), int(image_size.y), false, Image.FORMAT_RGBA8)
	
	# Combine sprites
	for sprite in sprites:
		var sprite_pos = bottom_pos.global_position - sprite.global_position
		var pos = Vector2(image_size.x / 2.0 - sprite_pos.x, image_size.y - sprite_pos.y)
		var sprite_size = sprite.texture.get_size()
		pos -= sprite_size / 2.0
		
		image.blend_rect(sprite.texture.get_image(), Rect2(Vector2.ZERO, sprite_size), pos)
	
	position = bottom_pos.position + Vector2(0.0, image_size.y / 2.0 - reflection_offset)
	
	texture.set_image(image)
