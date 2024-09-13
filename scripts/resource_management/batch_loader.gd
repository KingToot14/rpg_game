class_name BatchLoader
extends Node

# --- Signals --- #
signal done_loading(objs)

# --- Variables --- #
var objs: Array[Resource] = []
var loaded := 0
var target := 0

# --- Functions --- #
func _init(load_paths: Array[String], callback: Callable):
	SceneManager.add_child(self)
	
	done_loading.connect(callback, CONNECT_ONE_SHOT)
	
	target = len(load_paths)
	
	for i in range(target):
		objs.append(null)
		if load_paths[i] != "":
			AsyncLoader.new(load_paths[i], single_done_loading.bind(i))
		else:
			loaded += 1

func single_done_loading(obj: Resource, index: int) -> void:
	objs[index] = obj
	
	loaded += 1
	if loaded >= target:
		done_loading.emit(objs)
