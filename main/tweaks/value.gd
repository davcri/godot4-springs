extends Label


func _ready():
	text = str(get_node("../HSlider").value)


func _on_h_slider_value_changed(value):
	text = str(value)
