extends AnimatedSprite2D

# 加载所有的动作
# 注册到Animation中
# Player 帧变换信号回调，进行重新绘制
@onready var player = get_parent() as Charactor
@onready var WZLib = get_node("/root/MapleWz") as MapleResource

func _ready():
	# 注册，并加载数据
	var wznode = WZLib.get_by_path("Character/%s.img" % [player.body_skin])
	for motion in wznode.data._keys:
		if motion == "info":
			continue
		create_animation(motion, wznode.children[motion])

func create_animation(animation_name, wznode):
	print("action: ", animation_name)
	self.sprite_frames.add_animation(animation_name)
	self.sprite_frames.set_animation_speed(animation_name, 30)
	var fps = self.sprite_frames.get_animation_speed(animation_name)
	var player_speed = self.get_playing_speed()
	for _frame in wznode.data._keys:
		var node = wznode.children[_frame].data as Dictionary
		var texture = Texture2D.new()
		var _delay = node.get("delay", 1000)
		var action = node.get("action", animation_name)
		var action_frame = node.get("frame", _frame)
		texture.resource_name = "%s#%s"%[action, action_frame]
		
		var relation_duration = fps / (1000.0 / abs(_delay))
#		print("relation duration: ", relation_duration, " delay:", _delay, " fps: ", fps)
		# TODO 需要校准 delay 的动画时延
		self.sprite_frames.add_frame(animation_name, texture, relation_duration)
