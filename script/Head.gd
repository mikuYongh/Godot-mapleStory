extends CharacterSprite

class_name HeadSprite
@export var is_back : bool = false # 是否是背面

var capvslot : String # 帽子的类型

func draw(draw_map):
	self.is_back = false
	draw_map = super.draw(draw_map);
	var wznode = WZLib.get_by_path("Character/%s/%s/%d/head" % [self.img, charactor.motion, charactor.frame])
	if typeof(wznode) == TYPE_OBJECT:
		if wznode.data.z == "backHead":
			self.is_back = true
		# 先渲染头发和帽子
	draw_map = $Hair.draw(draw_map)
	
	return $Face.draw(draw_map)
