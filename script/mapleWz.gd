extends Node
class_name MapleResource

enum {LOAD_OK, LOAD_FAIL,NO_FOUND}

# Member variable
var WZ = WZNode.new(null, "", {})
var z_map = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	# test code
	print("ready for MapleResources.")
	load_z_map()

func load_z_map():
	load_wz_file("zmap")
	
	var array = WZ.children.zmap.data._keys
	var total = z_map.size()
	var index = 0
	for key in array:
		z_map[key] = total - index
		index += 1
	
	print("load zmap sort success")

func get_by_path(path: String):
	# path example: Character/00002000.img/motion/index
	# 判断缓存是否有，有则直接索引返回；
	# 缓存上没有，则加载文件，并初始化；
	if not path.contains(".img"):
		return NO_FOUND
	
	var ss = path.split(".img")
	var file_path = ss[0]
	var sub_path = ss[1]
	if WZ.children.has(file_path):
		var data = WZ.children.get(file_path) as WZNode
		var result =  find_for_sub_path(data, sub_path)
		if result != null:
			return result.resolve_uol()
		else:
			return NO_FOUND
	else:
		if (load_wz_file(file_path) == LOAD_OK):
			return get_by_path(path)
		else:
			printerr("get wz path fail: ", path)
			return NO_FOUND


func load_wz_file(file_path):
	var path = "res://wz_client/"+ file_path + ".img.xml.json"
	var file = FileAccess.open(path, FileAccess.READ)
	var error = FileAccess.get_open_error()
	if error != OK:
		printerr("Load wz file fail ", file_path, " reason: ", error)
		return LOAD_FAIL
	var data = JSON.parse_string(file.get_as_text())
	WZ.children[file_path] = create_wz_node(WZ, data)
	print("Load wz file success ", path)
	return OK
func get_sprite_z_index(part):
	if z_map.has(part):
		return z_map[part]
	else:
		printerr("warn: no part in z map: ", part)
		return 0
	
static func find_for_sub_path(data: WZNode, sub_path: String):
	# TODO
	# 拆解 sub_path
	# 循环获取 sub_path 的数据
	var path = sub_path.split("/", false)
	return data.find(path)

static func create_wz_node(parent, data):
	# if data["type"] != 'object'
	if typeof(data) != TYPE_DICTIONARY:
		return null;
		
	var name = data["name"]
	var type = data.get("type",null)
	if str(type)== "uol":
		var path = data["path"]
		return UOLWZNode.new(parent, name, data, path)
	
	var result = WZNode.new(parent, name, data)	
	for sub_name in data.get("_keys", {}):
		if !data.has(sub_name):continue;
		result.children[sub_name] = create_wz_node(result, data[sub_name])
		
	return result
	
static func is_canvas(data):
	return typeof(data) == TYPE_DICTIONARY and data.has("type") and data.type == "canvas"
static func create_sprite(draw_map, data):
	if (is_canvas(data)):
		
		var sprite = Sprite2D.new()
		sprite.texture = data._image.texture
		var origin = off_set(draw_map, data)
		sprite.position = origin
		sprite.offset += (sprite.texture.get_size() / 2)
		return sprite
	else:
		printerr("error, no canvas found for sprite")
		print_stack()
		return null

static func off_set(draw_map, data):
	var origin = Vector2(-data.origin.X, -data.origin.Y)
	var name = data.name
	var map = data.map as Dictionary
	var result
	
	for key in map["_keys"]:
		var m = map[key]
		draw_map["%s/%s"%[name, key]] = Vector2(-m.X, -m.Y)
	
	if map.has("brow"):
		var brow = Vector2(-map.brow.X, -map.brow.Y)
		result = origin + get_or(draw_map, "head/neck") - get_or(draw_map, "body/neck") - get_or(draw_map, "head/brow") + brow
	
	if  map.has("neck"):
		var neck = Vector2(-map.neck.X, -map.neck.Y)
		result = origin + get_or(draw_map, "head/neck") - get_or(draw_map, "body/neck")
	
	if map.has("hand"):
		var hand = Vector2(-map.hand.X, -map.hand.Y)
		result = origin + get_or(draw_map, "arm/navel") - get_or(draw_map, "body/navel") - get_or(draw_map, "arm/hand") + hand
	
	if map.has("handMove"):
		var handMove = Vector2(-map.handMove.X, -map.handMove.Y)
		result = origin - get_or(draw_map, "lHand/handMove") + handMove
	
	if map.has("navel"):
		var navel = Vector2(-map.navel.X, -map.navel.Y)
		result = origin - get_or(draw_map, "body/navel") + navel
	
	draw_map["%s/origin"%[name]] = result 
	return result
			
static func get_or(map, key):
	if map.has(key): 
		return map[key]
	else:
		return Vector2()	
class WZNode:
	var parent = null
	var name = null
	var data = {}
	var children = {}
	
	func _init(parent, name, data):
		# 递归构建 WZNode 对象
		self.parent = parent
		self.name = name
		self.data = resolve_data(data)
	
	func find(path: Array):
		# 索引查找数据
		var next = path.pop_front()
		match next:
			"..": 
				return parent.find(path)
			".": 
				return self
			null: 
				return self
			_:
				if children.has(next):
					return children[next].find(path) 
		
		printerr("can not find wznode path: ", path, " current node: ", self)
		return null
	
	func is_type(type): return type == "WZNode"
		
	func resolve_uol():
		# 递归解析 uol 引用
		var children_resolved = {}
		for name in children:
			var child = children[name] as WZNode
			if child != null and child.is_type("UOLWZNode"):
				child = child.resolve_uol()
			children_resolved[name] = child
		self.children = children_resolved
		return self
		
	# 数据转换方法
	static func resolve_data(data):
		match data.get("type"):
			# 图片
			"canvas": 
				# 将数据转化为 texture
				var image_source = data["_image"]
				var image_ = Image.new()
				image_.load_png_from_buffer(Marshalls.base64_to_raw(image_source.uri))
				var texture = ImageTexture.create_from_image(image_)
				data._image.texture = texture
				data._image.uri = null
				return data
			# 音频等数据结构 TODO
			_: 
				return data
		
class UOLWZNode extends WZNode:
	var uol_path: String
	
	func _init(parent, name, data, path):
		self.name = name
		self.parent = parent
		self.data = resolve_data(data)
		self.uol_path = path
	
	func find(path: Array):
		path.append_array(self.uol_path.split("/", false))
		return self.parent.find(path)
	
	func is_type(type): return type == "UOLWZNode"

	func resolve_uol():
		var node = find([]) as WZNode
		return node.resolve_uol()
