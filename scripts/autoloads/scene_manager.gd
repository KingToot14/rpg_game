extends Node

# --- Variables --- #
var load_path: String

var scn_curr_level: PackedScene

# --- Functions --- #
func change_root_scene(scn: PackedScene):
	get_tree().change_scene_to_packed(scn)

func add_node(node: Node2D):
	get_tree().current_scene.add_child(node)

func instantiate_scene(scn: PackedScene) -> Node2D:
	var node = scn.instantiate()
	add_node(node)
	return node
	

func load_scene(path: String, callback: Callable = change_root_scene):
	AsyncLoader.new(path, callback)

func reload_root_scene():
	get_tree().reload_current_scene()

func quit_game():
	get_tree().quit()
