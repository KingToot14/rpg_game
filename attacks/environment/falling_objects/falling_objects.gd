class_name FallingObjects
extends AttackObject

# --- Variables --- #
@export var object_delay := 0.25

var objects: Array[AnimationExposer] = []

# --- Functions --- #
func setup(params: Dictionary) -> void:
	super(params)
	
	for child in get_children():
		if child is AnimationExposer:
			child.set_entity(entity)
			objects.append(child)

func perform_attack() -> void:
	var enemies = TargetingHelper.get_alive_entities(&'enemy' if attack.side == Attack.TargetSide.ENEMY else &'player')
	
	for i in range(len(enemies)):
		var object = objects[enemies[i].spawn_index]
		
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
		
		if i == len(enemies) - 1:
			object.queue_method(queue_free)
		
		await get_tree().create_timer(object_delay).timeout
