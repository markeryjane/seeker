extends CenterContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "position:x", 0, 1.3)
	#$AnimationPlayer.play("title")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
