extends Node
#模拟上方黄色通知滚动条
var label:Label;
var offsetX=0;
var scrollSpeed=60;
var size;
# Called when the node enters the scene tree for the first time.
func _ready():
	label=$ColorRect/label
	label.add_theme_font_size_override("font_size",13)
	var font=label.get_theme_default_font();
	size=font.get_string_size(label.text,HORIZONTAL_ALIGNMENT_LEFT,-1,13,TextServer.JUSTIFICATION_NONE,TextServer.DIRECTION_AUTO,TextServer.ORIENTATION_HORIZONTAL)
	label.position.x=800;
	label.position.y=-size.y/8
	label.add_theme_color_override("font_color", Color(255,255,0,1))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var ox=delta*scrollSpeed;
	var font:Font=label.get_theme_default_font();
	label.position.x-=ox;
	if label.position.x<=-size.x:
		label.position.x=800
	pass
