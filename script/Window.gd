extends UI
class_name MapleWindow
#基于UI库的Windows类
var WindowNode:Dictionary;
@export var path ="" as String;
@export var isCentre =true;
var canDrap=false;
var background:Sprite2D;
var dragoffset=Vector2.ZERO;
signal ui_process;
signal ui_input;
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func init2(width,heigh,canDrap=false):
	focus_mode=Control.FOCUS_ALL
	var z=get_parent().get_child_count(false);
	self.z_index=z;
	self.canDrap=canDrap;
	if path=="":return;
	var result=wzTool.get_by_path("UI/"+path);
	var data=result.data;
	var border=data.get("Border");
	var title=data.get("title");
	addEightImage(path+"/"+"Border",0,0,width,heigh);
	size=Vector2(width,heigh)
	if isCentre:
		position=Vector2(get_viewport_rect().size.x/2-size.x/2,get_viewport_rect().size.y/2-size.y/2)
	
	
func init(canDrap=false):
	focus_mode=Control.FOCUS_ALL
	var z=get_parent().get_child_count(false);
	self.z_index=z;
	self.canDrap=canDrap;
	if path=="":return;
	var result=wzTool.get_by_path("UI/"+path);
	var WindowNode=result.data;
	if !WindowNode.has("backgrnd"):return;
	if !WindowNode.is_empty():
		#首先加载background	
		background=addImage(path+"/backgrnd",0,0)
		##background.z_index=-1;
		if background:
			size=background.get_rect().size;
			if isCentre:
				position=Vector2(get_viewport_rect().size.x/2-size.x/2,get_viewport_rect().size.y/2-size.y/2)
		pass
func changeBackground(brd="backgrnd2"):
	if background:
		background.queue_free();
	background=addImage(path+"/"+brd,0,0)
	if background:
			background.z_index=-1;
			size=background.get_rect().size;

func _process(_delta):
	emit_signal("ui_process",_delta)
	if dragging:
		var mousepos = get_viewport().get_mouse_position()
		self.position = Vector2(mousepos.x, mousepos.y)-dragoffset;

func _set_drag_pc():
	dragging=!dragging
func close():
	self.queue_free();
func _gui_input(event):
	emit_signal("ui_input",event)
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			dragoffset=event.position
			if dragoffset.y<=25:
					dragging=true
		elif event.button_index == 1 and !event.pressed:
			dragging=false;
	
func setSizeByNode(node):
	if !node:return;
	size=node.size;
func showWindow(parentNode:Node):
	if !parentNode:return;
	var name=self.name;
	var find=parentNode.find_child(name,true,false);
	if !find:
		parentNode.add_child(self)
		pass;
	else:
		find.queue_free();
		
	
	
