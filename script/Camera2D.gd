extends Camera2D
# 存储相机移动速度的变量
var camera_speed = 1000

# 存储相机目标位置的变量
var target_position = Vector2.ZERO
@onready var player=self.get_parent() as Charactor;
@onready var ViewPortSize=self.get_viewport_rect().size;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position=player.getPos();
	# 获取用户输入的方向向量
	
