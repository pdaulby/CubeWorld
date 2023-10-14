class_name Util extends Node

static func is_int(f: float):
	return f - int(f) == 0

static func is_v2i(v: Vector2):
	return v.distance_to(Vector2i(v)) == 0
	
static func is_v3i(v: Vector3):
	return v.distance_to(Vector3i(v)) == 0

static func last(arr: Array):
	return arr[arr.size()-1]
