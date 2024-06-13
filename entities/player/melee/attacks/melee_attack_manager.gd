class_name MeleeAttackManager
extends Node2D

# --- Variables --- #
@export var falling_objects: Array[Node2D] = [null, null, null, null, null]

# --- Functions --- #
func set_falling_object_targets() -> void:
	var enemies = TargetingHelper.get_alive_entities(&'enemy')
	
	for enemy in enemies:
		var object = falling_objects[enemy.spawn_index]
		
		var mode = randi_range(0, 2)
		
		object.set_target(enemy)
		if mode == 0:
			object.set_sprite_frame(0)
			object.play_animation(&"fall_light")
		elif mode == 1:
			object.set_sprite_frame(1)
			object.play_animation(&"fall_normal")
		else:
			object.set_sprite_frame(2)
			object.play_animation(&"fall_heavy")
