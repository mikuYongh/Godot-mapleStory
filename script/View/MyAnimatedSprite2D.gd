extends AnimatedSprite2D
class_name MyAnimatedSprite2D
signal clicked
var rect:Rect2;
var animKey;
var width;
var height


func getCurrentFrameRect():
	var sp=sprite_frames.get_frame_texture(self.animKey, frame);
	var size = sp.get_size()
	var pos = offset
	if centered:
		pos -= 0.5 * size
	self.width=size.x;
	self.height=size.y;
	rect=Rect2(pos,size)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func setAnimKey(animkey):
	self.animKey=animkey;
	getCurrentFrameRect();
	#rect=Rect2i(x,y,width,height)
	#queue_redraw();

func _draw():
	#if rect:
		#draw_rect(rect,Color.RED,false)
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event):
	if event is InputEventScreenTouch||event is InputEventMouseButton:
		var camera=get_viewport().get_camera_2d()
		var x=0;
		var y=0;
		if event is InputEventMouseButton:
			x=event.global_position.x;
			y=event.global_position.y;
		if event is InputEventScreenTouch:
			x=event.position.x;
			y=event.position.y;
		var pos=Vector2(x-400+camera.get_screen_center_position().x,y-300+camera.get_screen_center_position().y);
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and rect!=null and rect.has_point(to_local(pos)):
				emit_signal("clicked")
		if event is InputEventScreenTouch:
			if event.is_pressed()&&event.pressed and rect!=null and rect.has_point(to_local(pos)):
				emit_signal("clicked")

func _process(delta):
	pass
