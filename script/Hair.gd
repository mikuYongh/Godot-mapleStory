extends CharacterSprite

class_name HairSprite

var head : HeadSprite

# 监听节点的事件，以删除部分数据

func _ready():
	head = get_parent()

func draw(draw_map):
	draw_map = super.draw(draw_map)
	var capSprite = find_child("Cap") as CapSprite
	draw_map = capSprite.draw(draw_map)
	
	match head.capvslot:
		"":
			pass
		"CpH5":
			pass
		"CpH1H5":
			free_sprite_by_part("hairOverHead")
			free_sprite_by_part("backHair")
		_:
			free_sprite_by_part("hair")
			free_sprite_by_part("hairOverHead")
			free_sprite_by_part("backHair")

	return draw_map
