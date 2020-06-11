extends Spatial


var effects := []

func _ready():
	for child in get_children():
		if child is AmbientEffect:
			effects.push_back(child);


func calculate_bounding_box(roads) -> AABB:
	var bb := AABB()
	
	for road in roads:
		var colShape = road.get_node("CollisionShape")
		var aabb := Utils.aabb_from_shape(colShape)
		bb = bb.merge(aabb)
	
	return bb


func get_effects_position() -> Vector3:
	return to_local(GameData.currentGame.localPlayer.global_transform.origin)


func _physics_process(delta):
	var effect_position := get_effects_position()
	for effect in effects:
		var chance := randf()
		if chance < effect.frequency:
			effect.play(effect_position)