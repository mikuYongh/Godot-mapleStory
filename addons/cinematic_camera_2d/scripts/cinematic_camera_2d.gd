@tool
class_name CinematicCamera2D
extends Camera2D


@icon("res://addons/cinematic_camera_2d/icons/cinematic_camera_2d.svg")


## Cinematic camera 2D node.
## Uses a CameraData2D to create smooth transitions between cameras.


## Node path to the virtual camera to use.
@export var _virtual_camera: NodePath:
	set(value):
		_virtual_camera = value
		if Engine.is_editor_hint():
			virtual_camera = get_node_or_null(_virtual_camera)
## Reference to virtual camera node.
## Change this value to transition to another camera.
@onready var virtual_camera: VirtualCamera2D = get_node_or_null(_virtual_camera)


## Called every frame.
func _process(delta: float) -> void:
	if is_instance_valid(virtual_camera) and virtual_camera.is_inside_tree():
		# Update camera position.
		if not Engine.is_editor_hint():
			virtual_camera.update_position(self)
		# Set camera smoothing.
		position_smoothing_speed = virtual_camera.smoothing_speed
		# Update camera zoom.
		if virtual_camera.zoom.x != 0.0:
			zoom.x = lerp(zoom.x, virtual_camera.zoom.x, delta * virtual_camera.smoothing_speed)
		if virtual_camera.zoom.y != 0.0:
			zoom.y = lerp(zoom.y, virtual_camera.zoom.y, delta * virtual_camera.smoothing_speed)
		# Update camera offset.
		offset = lerp(offset, virtual_camera.offset, delta * virtual_camera.smoothing_speed)
