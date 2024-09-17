class_name MeleeAttackManager
extends Node2D

# --- Variables --- #
@export var falling_objects: Array[Node2D] = [null, null, null, null, null]
@export var object_delay := 0.25

# --- Functions --- #
func set_falling_object_targets() -> void:
	var enemies = TargetingHelper.get_alive_entities(&'enemy')
	
	for i in range(len(enemies)):
		var object = falling_objects[enemies[i].spawn_index]
		
		var mode = randi_range(0, 2)
		
		object.set_target(enemies[i])
		if mode == 0:
			object.set_sprite_frame(0)
			object.play_animation(&"fall_light")
		elif mode == 1:
			object.set_sprite_frame(1)
			object.play_animation(&"fall_normal")
		else:
			object.set_sprite_frame(2)
			object.play_animation(&"fall_heavy")
		
		await get_tree().create_timer(object_delay).timeout
