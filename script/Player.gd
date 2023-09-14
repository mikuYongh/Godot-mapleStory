extends Node2D

class_name Charactor

# 动作
@export var head_skin = "00012000"
@export var body_skin = "00002000"
@export var flip = true

@export var motion = "stand1" as String
# 动作帧
@export var frame = 0 as int
@export var isMainPlayer=false;#是否是主玩家
@export var fallSpeed =1.5 as int
@export var jumpSpeed =100 as int;
@export var moveSpeed =100 as int;
@onready var characterBody =self.get_node("RigidBody2D") as CharacterBody2D;
@onready var viewPortSize=self.get_viewport_rect().size;
@onready var maker2D=self.find_child("Marker2D")
enum STATE{
	STAND,WALK,JUMP,JUMP_DOWN,CLIMP,CLIMPING
}
enum STANCE{
	stand1,
	walk1,
	jump,
	rope
}
@export var state=STATE.STAND;
# 12 个绘制部分
var draw_part = [
	"Body", 
	"Head",
	"Coat", 
	"Pants", 
	"Shoes", 
	"Glove", # 手套
	"Weapon", 
	"Shield", 
	"Cape"
	]

func _ready():
	draw()
	
	$Animation.play(motion)

func _process(delta):
	if flip:
		maker2D.scale.x = -1
	else:
		maker2D.scale.x = 1
func draw():
	var draw_map = {}
	for part in draw_part:
		var node = find_child(part)
		draw_map = node.draw(draw_map)


func _on_charactor_animation_frame_changed():
	var anim = $Animation
	var frame = anim.frame
	var anim_name = anim.animation
	var texture = anim.sprite_frames.get_frame_texture(anim_name, frame) as Texture2D
	var motion_frame = texture.resource_name
	self.motion = motion_frame.split("#")[0]
	self.frame = int(motion_frame.split("#")[1])
	draw()
	#print("frame change!", anim_name, frame)
func setPos(v):
	characterBody.position=v;
func getPos():
	return characterBody.position
func getPosAtViewPort():
	var v=Vector2(characterBody.position.x+viewPortSize.x/2,characterBody.position.y+viewPortSize.y/2)
	return v
func setStance(stance=STANCE.stand1):
	var key=STANCE.find_key(stance);
	var body=find_child("Body")
	if key:
		$Animation.play_backwards(key)
func reset():
	var maker2D = find_child("Marker2D")
	var children=maker2D.get_children()
	for child in children:
		if child as Sprite2D:
			child.queue_free();
	
