extends Node2D


# Called when the node enters the scene tree for the first time.


func start_bgm():
	$BGM.volume_db = -80
	$BGM.play()
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($BGM, "volume_db", 3.0, 8)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
