extends Node2D

@onready var bgm: AudioStreamPlayer2D = %BGM

# Called when the node enters the scene tree for the first time.


func start_bgm():
	bgm.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
