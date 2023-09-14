@tool
class_name VirtualCamera2D
extends Node2D


@icon("res://addons/cinematic_camera_2d/icons/virtual_camera_2d.svg")


## A virtual camera works as a logic camera to be used in combination with a
## cinematic camera. A VirtualCamera2D can be assigned to a CinematicCamera2D,
## all the parameters of the camera will then smoothly transition to the
## paramters of the virtual camera.


## Path to the node that the camera should follow. If this is set to a Node2D,
## the camera will keep the same position as this node. If this is unset,
## the camera will keep the same position as the virtual camera.
@export_node_path(Node2D) var _follow_node: NodePath:
	set(value):
		_follow_node = value
		# Allows to see the change without reloading the scene in the editor.
		if Engine.is_editor_hint():
			follow_node = get_node_or_null(_follow_node)
## Reference to the node that the camera should follow. If this is set to a Node2D,
## the camera will keep the same position as this node. If this is unset,
## the camera will keep the same position as the virtual camera.
@onready var follow_node: Node2D = get_node_or_null(_follow_node)

## Camera offset. The offset of the cinematic camera will transition smoothly
## to this value, according to its 'smoothing_speed'.
@export var offset: Vector2 = Vector2.ZERO

## Camera zoom. The zoom of the cinematic camera will transition smoothly
## to this value, according to its 'smoothing_speed'.
@export var zoom: Vector2 = Vector2.ONE:
	set(value):
		zoom = value
		# Redraw gizmos.
		if Engine.is_editor_hint():
			queue_redraw()

## Smoothing speed. Used as the position, offset and zoom smoothing speed.
@export var smoothing_speed: float = 5.0

## Left limit of the virtual camera. Note that this does not affect the limit
## of the actual camera to allow for transitions between cameras with
## different limits.
@export var limit_left: int = -10000000:
	set(value):
		limit_left = value
		# Redraw gizmos.
		if Engine.is_editor_hint():
			queue_redraw()
## Top limit of the virtual camera. Note that this does not affect the limit
## of the actual camera to allow for transitions between cameras with
## different limits.
@export var limit_top: int = -10000000:
	set(value):
		limit_top = value
		# Redraw gizmos.
		if Engine.is_editor_hint():
			queue_redraw()
## Right limit of the virtual camera. Note that this does not affect the limit
## of the actual camera to allow for transitions between cameras with
## different limits.
@export var limit_right: int = 10000000:
	set(value):
		limit_right = value
		# Redraw gizmos.
		if Engine.is_editor_hint():
			queue_redraw()
## Bottom limit of the virtual camera. Note that this does not affect the limit
## of the actual camera to allow for transitions between cameras with
## different limits.
@export var limit_bottom: int = 10000000:
	set(value):
		limit_bottom = value
		# Redraw gizmos.
		if Engine.is_editor_hint():
			queue_redraw()


## Draws the canvas item.
## Used while in the editor to draw gizmos.
func _draw() -> void:
	if Engine.is_editor_hint():
		# Draw camera limits
		var width = limit_right - limit_left
		var height = limit_bottom - limit_top
		var limits = Rect2(limit_left, limit_top, width, height)
		draw_rect(limits, Color.YELLOW, false)


## Called from the cinematic camera script to the position of the camera.
func update_position(camera: Node2D) -> void:
	# Update camera position.
	if is_instance_valid(follow_node) and follow_node.is_inside_tree():
		camera.global_position = follow_node.global_position
	else:
		camera.global_position = global_position
	# Make came stay within its limits.
	var bounds = get_viewport_rect().size * 0.5 * Vector2(1 / zoom.x, 1 / zoom.y)
	var min_x = global_position.x + limit_left + bounds.x - offset.x
	var min_y = global_position.y + limit_top + bounds.y - offset.y
	var max_x = global_position.x + limit_right - bounds.x - offset.x
	var max_y = global_position.y + limit_bottom - bounds.y - offset.y
	camera.global_position.x = clamp(camera.global_position.x, min_x, max_x)
	camera.global_position.y = clamp(camera.global_position.y, min_y, max_y)
