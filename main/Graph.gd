extends Path2D

var samples = []
var scale_y = 100
var scale_x = 2

func _draw():
	var i = 0
	draw_char(SystemFont.new(), Vector2(180, -120), "1", 24)
	draw_dashed_line(Vector2(0 * scale_x, -1 * scale_y), Vector2(100 * scale_x, -1 * scale_y), Color.DARK_GRAY, 2, 6)
	for sample in samples:
		var next
		if i < samples.size() - 1:
			next = samples[i + 1]
		else:
			return
		draw_line(sample, next, Color.FLORAL_WHITE, 2)
		i += 1

func update_graph(points):
	var i = 0
	curve.clear_points()
	for p in points:
		curve.add_point(Vector2(i * scale_x, -p * scale_y))
		i += 1
	samples = curve.get_baked_points()
	queue_redraw()
