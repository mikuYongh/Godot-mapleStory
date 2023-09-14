extends CharacterSprite

class_name CapSprite

var head : HeadSprite

func _ready():
	head = find_parent("Head") as HeadSprite

func draw(draw_map):
	draw_map = super.draw(draw_map)
	
	# 将帽子的信息传到 head 中
	var wznode = WZLib.get_by_path("Character/%s/info"%[self.img])
	if typeof(wznode) == TYPE_INT and wznode == MapleResource.NO_FOUND:
		head.capvslot = ""
	else:
		# CpHdH1H2H3H4H5H6HsHfHbAfAyAsAe
		# 表示屏蔽以上的贴图
		# Hd 头部
		# H1-H6 头发
		# Af Ay As Ae 饰物相关 Af 脸饰 Ae 眼饰
		head.capvslot = wznode.data.vslot
	
	return draw_map
