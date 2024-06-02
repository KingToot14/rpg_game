class_name ObjectPool
extends Node2D

# --- Variables --- #
@export var inital_items: Array[String]

var items: Dictionary

# --- Functions --- #
func _ready() -> void:
	Globals.object_pool = self
	
	for item in inital_items:
		var parts = item.split("|")
		add_new_item(parts[2], int(parts[1]), parts[0])

func add_new_item(item_path: String, count: int, key: String) -> void:
	AsyncLoader.new(item_path, populate_pool.bind(count, key))

func populate_pool(item_scene: PackedScene, count: int, key: String) -> void:
	var array: Array[Node] = []
	
	for i in range(count):
		var scene := item_scene.instantiate() as Node
		scene.visible = false
		array.append(scene)
		add_child(scene)
	
	# Add to dictionary
	items[key] = array

func get_item(key: String) -> Node:
	var array = items[key] as Array[Node]
	
	for item in array:
		if item.visible:
			return item
	
	return array[0]
