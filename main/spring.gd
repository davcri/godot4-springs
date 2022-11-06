extends Node
class_name Spring

var f = 2: set=set_f # frequency
var z = 1: set=set_z  # damping. z=1 critical damping
var r = 0: set=set_r  # initial response. https://github.com/godotengine/godot/issues/41183
var physically_accurate = false

# https://www.youtube.com/watch?v=KPoeNZZ6H4s
# x dynamic input (from gameplay)
# y dynamic (adjusted) output
var y
var yd = 0 # derivative
var x0 = 0 # initial state
var xp
var target = 0.1
var k1
var k2
var k3
var delta_critical


func set_f(v):
	f = v
	init(0)

func set_z(v):
	z = v
	init(0)

func set_r(v):
	r = v
	init(0)

func init(value, accurate = false):
	physically_accurate = accurate
	x0 = value
	xp = x0
	y = x0
	# calculate constants
	k1 = z / (PI * f)
	k2 =  1 / (2 * PI * f) ** 2
	k3 = r * z / (2 * PI * f)
	delta_critical = sqrt(4 * k2 + k1 * k1) - k1
	delta_critical *= 0.8
	graph()

func reset():
	yd = 0

func compute(delta, x, xd = null):
	if xd == null:
		xd = (x - xp) / delta
		xp = x
	if physically_accurate:
		var iterations = ceil(delta / delta_critical)
		delta = delta / iterations
		for i in iterations:
			y = y + delta * yd # integrate value by velocity
			yd = yd + delta * (x + k3*xd - y -k1 * yd) / k2 # integrete value by acceleration
	else:
		# TODO: fix jitter
		var k2_stable = max(k2, 1.1 * (delta ** 2 / 4 + delta * k1/2))
		y = y + delta * yd # integrate value by velocity
		yd = yd + delta * (x + k3*xd - y -k1 * yd) / k2_stable # integrete value by acceleration
	return y

func graph():
	reset()
	var out = []
	for i in range(100):
		var new_sample = compute(0.016, 1)
		out.append(new_sample)
	spring_updated.emit(out)

signal spring_updated
