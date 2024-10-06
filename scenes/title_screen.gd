extends Control
@onready var title_bgm: AudioStreamPlayer = %TitleBGM
@onready var start_game_sound: AudioStreamPlayer = %StartGameSound


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#SceneTransition.goToScene(load("res://scenes/main_scene.tscn"))
	title_bgm.volume_db = -80
	
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(title_bgm, "volume_db", 1.0, 5)
	title_bgm.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		start_game_sound.play()
		SceneTransition.goToScene(load("res://scenes/characterselect.tscn"))
		AudioManager.start_bgm() 
