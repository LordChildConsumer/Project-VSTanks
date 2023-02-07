extends CanvasLayer;

### Node Refs ###
@onready var _anim := $AnimationPlayer;
@onready var _progress := $M/C/ProgressBar;


### Variables ###
var progress := [];
var load_status := 0;


### Load Scene ###
func load_new_scene(scene: String) -> void:
	print("%s: Loading '%s'" % [scene_file_path, scene]);
	
	## Fade to loading screen
	_anim.play("fade-to-load");
	await _anim.animation_finished;
	_anim.play("loading");
	
	## Actually load the scene
	var error = ResourceLoader.load_threaded_request(scene, "", true);
	var loading := true;
	
	while loading:
		## Get the load status and update the progress bar
		load_status = ResourceLoader.load_threaded_get_status(scene, progress);
		_progress.set_value(progress[0] * 100);
		
		match load_status:
			ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				print("%s: INVALID RESOURCE (Did you pass in the correct path?)" % scene_file_path);
				return;
			ResourceLoader.THREAD_LOAD_FAILED:
				print("%s: LOAD FAILED (idk man look at the code ig)" % scene_file_path);
				return;
			ResourceLoader.THREAD_LOAD_LOADED:
				print("%s: LOADING COMPLETED" % scene_file_path);
				continue;
		
		## The scene has finished loading
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(scene));
		
		_anim.play("fade-to-game");
	
	
	
