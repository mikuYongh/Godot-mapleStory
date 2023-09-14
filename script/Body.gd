extends Container

class_name CharacterSprite

@export var img = "00012000.img"
@onready var WZLib = get_node("/root/MapleWz") as MapleResource
@onready var charactor = find_parent("Player") as Charactor

var part_to_sprite = {}

func reset():
	for part in part_to_sprite:
		var child = part_to_sprite[part] as Sprite2D
		child.queue_free()
	part_to_sprite = {}

func free_sprite_by_part(part):
	if part_to_sprite.has(part):
		var sprite = part_to_sprite[part] as Sprite2D
		sprite.queue_free()
		part_to_sprite.erase(part)

func draw(draw_map):
	
	# 读取 body 的数据；
	# 渲染 body 数据中的 贴图集 
	# 计算 body 的偏移
	var wznode = WZLib.get_by_path("Character/%s/%s/%d" % [self.img, charactor.motion, charactor.frame])
	
	# 绘制
	# var data = wznode.data
	# 循环贴图集合
	reset()
	if typeof(wznode) == TYPE_INT and wznode == MapleResource.NO_FOUND:
		return draw_map
		
	for key in wznode.children:
		var node = wznode.children[key]
		if node == null: continue
		var value = node.data
		if (MapleResource.is_canvas(value)):
			# 绘制
			var sprite = WZLib.create_sprite(draw_map, value) as Sprite2D
			sprite.z_index = WZLib.get_sprite_z_index(value.z)
			part_to_sprite[value.z] = sprite
			self.add_child(sprite)
			
	return draw_map
