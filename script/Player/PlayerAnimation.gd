extends AnimationPlayer

# 加载所有的动作
# 注册到Animation中
# Player 帧变换信号回调，进行重新绘制
@onready var player = get_parent() as Charactor
@onready var WZLib = get_node("/root/MapleWz") as MapleResource

# Called when the node enters the scene tree for the first time.
func _ready():
	# 注册，并加载数据
	var wznode = WZLib.get_by_path("Character/%s.img" % [player.body_skin])
	for motion in wznode.children:
		create_animation(motion, wznode.children[motion])
	return

func create_animation(animation_name, wznode):
	print(animation_name, wznode)
	pass
