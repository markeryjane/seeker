extends Node2D


# Called when the node enters the scene tree for the first time.
var desired_volume = 2.4

func start_bgm():
	$BGM.volume_db = -80
	$BGM.play()
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($BGM, "volume_db", desired_volume, 8)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pause_bgm():
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($BGM, "volume_db", -80, .4)

func unpause_bgm():
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($BGM, "volume_db", desired_volume, .9)
