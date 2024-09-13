class_name AsyncLoader
extends Node

# --- Signals --- #
signal done_loading(obj: Resource)

# --- Variables --- #
var path: String

# --- Functions --- #
func _init(load_path: String, callback: Callable):
	if load_path == "":
		callback.call(null)
		queue_free()
		return
	
	SceneManager.add_child(self)
	
	path = load_path
	done_loading.connect(callback, CONNECT_ONE_SHOT)
	
	ResourceLoader.load_threaded_request(path)

func _process(_delta):
	var status = ResourceLoader.load_threaded_get_status(path)
	
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		done_loading.emit(ResourceLoader.load_threaded_get(path))
		queue_free()
