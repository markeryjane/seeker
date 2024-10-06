extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#SceneTransition.goToScene(load("res://scenes/main_scene.tscn"))
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		SceneTransition.goToScene(load("res://scenes/main_scene.tscn"))
		AudioManager.start_bgm()
