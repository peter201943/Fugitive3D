extends Spatial

var update_threshold := Threshold.new(Utils.COMMON_NETWORK_UPDATE_THRESHOLD)

var is_on := true

func _ready():
	if Utils.renderer_is_gles2():
		$SpotLight.visible = false
		$LightBeam.alpha = 0.05
	else:
		$SpotLight.visible = true
		$LightBeam.alpha = 0.004


func toggle_on():
	GameAnalytics.design_event("toggle_flashlight")
	set_on(not is_on)


func set_on(on: bool):
	rpc("on_set_on", on)


remotesync func on_set_on(on: bool):
	is_on = on
	
	if not Utils.renderer_is_gles2():
		$SpotLight.visible = is_on
	
	$LightBeam.visible = is_on


puppet func network_update(networkPosition: Vector3, networkRotation: Vector3):
	translation = networkPosition
	rotation = networkRotation


func _physics_process(delta):
	if get_tree().network_peer != null and is_network_master() and update_threshold.is_exceeded() and not GameData.currentGame.is_game_over():
		rpc_unreliable("network_update", translation, rotation)


func get_ray_caster():
	return $RayCast
