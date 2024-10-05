extends Control

var months_played = [false, false, false, false, false, false, false, false, false, false, false, false]
@onready var month_container: HBoxContainer = %MonthContainer

var month_colors = ["#0091de", "#ff8ec0", "#ff7a69", "#61f2ce", "#f5d67d", "#ff0a37", "#3284ff", "#a88246", "#7d4f4e", "#d06900", "#b63900", "#2a4fff"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var _index = 0
	for label in month_container.get_children():
		if months_played[_index]:
			label.modulate =Color.html(month_colors[_index])
		else:
			label.modulate = Color.DIM_GRAY
		_index += 1

func activate_month(month:int) -> void:
	months_played[month-1] = true
