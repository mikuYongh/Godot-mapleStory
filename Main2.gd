extends Node



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _init():
	var background=Sprite2D.new();
	var result = Image.new()
	var b_data="iVBORw0KGgoAAAANSUhEUgAAAB0AAAAdCAYAAABWk2cPAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAADZSURBVEhL7ZNtEYMwEESxgIVYwAIWYiEWYqEWsIAFLNRTypJs5yglFIZcf8DOvBk+7ni5AJVCQkIt4elN6J2eOJg6oiWdJqQU5/Fyuby31LX1LTwlFxAOwzB9oWrCxsTfwnuvJwQ4ThTNp7B4/icE1tri4oUQeOeKiVeFBDWx9JxkhX3X6QrvCY8kK7zchPUBFskKxYRmpEm0O2AP+mcL2JrQJbzg8QV5X4JeOwL5XLwyIZr40G4DuQCSlSK/TLgGaykg3OLF9spQiCL5HiXyXUnYQyAhKVX1Aj3dVLrPsvB9AAAAAElFTkSuQmCC"
	var a=Marshalls.base64_to_raw(b_data)
	
	#var binary_data =PackedByteArray(a)
	result.load_png_from_buffer(a)
	#result.save_png("res://2.png")
	var t=ImageTexture.new()
	t.create_from_image(result) #,7;
	
	background.texture=t;
	#background.position.x+=background.texture.get_width()/2;
	#background.position.y+=background.texture.get_height()/2;
	add_child(background,true);


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
