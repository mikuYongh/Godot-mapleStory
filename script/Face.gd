extends CharacterSprite

class_name FaceSprite

@export var motion = "default"
@export var frame = 0 

var head : HeadSprite
var self_draw_map = {}

func _ready():
	head = find_parent("Head") as HeadSprite
	$BlinkTimer.wait_time = 1 

func draw(draw_map):
	reset()
	var parent = get_parent() as HeadSprite
	if parent.is_back:
		return draw_map
	if head.capvslot.contains("Hd") or head.capvslot.contains("Hb"):
		return draw_map

	var wznode = null
	if self.motion == "default":
		wznode = WZLib.get_by_path("Character/%s/%s" % [self.img, self.motion])
	else:
		wznode = WZLib.get_by_path("Character/%s/%s/%d" % [self.img, self.motion, self.frame])
	# 绘制
	# var data = wznode.data
	# 循环贴图集合
	if typeof(wznode) == TYPE_INT and wznode == MapleResource.NO_FOUND:
		return draw_map
	
	# Face 都是通过 brow 和 Head 进行映射的。因此此处只需要和 Head 进行处理就可以了。
	for key in wznode.children:
		var node = wznode.children[key]
		do_draw(draw_map, node)
			
	self.self_draw_map = draw_map
	return draw_map

func do_draw(draw_map, node):
	if node == null: return
	var value = node.data
	if (MapleResource.is_canvas(value)):
		# 绘制
		var sprite = WZLib.create_sprite(draw_map, value) as Sprite2D
		part_to_sprite[value.z] = sprite
		self.add_child(sprite)


	

	

func _on_face_animation_animation_looped():
	# blink 动作， 20% 的概率会连续眨眼两次
	if self.motion == "blink" and randf() < 0.3:
		return;
	
	$FaceAnimation.stop()
	self.motion = "default"
	if not self.self_draw_map.is_empty():
		draw(self.self_draw_map)
	


func _on_blink_timer_timeout():
	$FaceAnimation.play("blink")
	$BlinkTimer.start(randf_range(4,6))
	pass # Replace with function body.





func _on_face_animation_frame_changed():
	var anim = $FaceAnimation
	var frame = anim.frame
	var anim_name = anim.animation
	var texture = anim.sprite_frames.get_frame_texture(anim_name, frame) as Texture2D
	var motion_frame = texture.resource_name
	self.motion = motion_frame.split("#")[0]
	self.frame = int(motion_frame.split("#")[1])
	if not self.self_draw_map.is_empty():
		draw(self.self_draw_map)
	pass # Replace with function body.
	pass # Replace with function body.
