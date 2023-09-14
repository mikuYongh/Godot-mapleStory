extends ScrollContainer
class_name MapleGridView;
@export var VscrStyle="VScr4";
@export var width=0;
@export var heigh=0;
@export var cell_width=29;
@export var cell_heigh=29;
@export var margin=4;
@export var type="";
@export var canDrap=false;
@onready var wzTool:MapleWz=MapleWz;
signal put_cell;
var gridView;
var vBox;
var styleNode;
var columns=4;
var row=6;
# Called when the node enters the scene tree for the first time.
func _ready():
	self.focus_mode=Control.FOCUS_ALL;
	get_v_scroll_bar().step=(cell_heigh+margin+1)
	self.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED
	self.size.y=(cell_heigh+margin)*row;
	
	styleNode=wzTool.get_by_path("UI/Basic.img/"+VscrStyle).data;
	var enabled=styleNode.get("enabled");
	var disable=styleNode.get("disabled");
	vBox=VBoxContainer.new();
	gridView=GridContainer.new();
	gridView.columns=columns;
	var entered=func():
		Cursor._play("catch");
		pass
	var exited=func():
		Cursor._play("normal");
		pass
	gridView.mouse_entered.connect(entered)
	gridView.mouse_exited.connect(exited)
	
	
	setStyle(enabled)
	vBox.add_child(gridView)
	add_child(vBox)	
	pass # Replace with function body.

func addNode(node,data):
	node.set_meta("data",data)
	gridView.add_child(node)
func cellclick(event,node,innode:TextureRect):
	if event as InputEventMouseButton:
		var data=node.get_meta("data")
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)&&event.pressed:
			var a={};
			var index=node.get_index(false)
			if canDrap:
				if Cursor.getData.is_empty():
					Cursor.setGetData({"type":type,"img":innode.texture,"index":index,"node":node,"data":data})
					AduioBGM.playBGM("UI/DragStart")
				else:
					emit_signal("put_cell",node,index)
					var type=Cursor.getData.get("type");
					var i=Cursor.getData.get("index",-1);
					var n=Cursor.getData.get("node")
					Cursor.setGetData({})
					if !n:return;
					if  i<0:return;
					if type==self.type:
						var findnode=gridView.get_child(i);
						gridView.move_child(node,i)
						gridView.move_child(n,index)
						AduioBGM.playBGM("UI/DragEnd")
					
					
		pass
func addCellNode(node):
	var entered=func():
		if canDrap:
			Cursor.canPut=true;
		pass
	var exited=func():
		Cursor.canPut=false;
		pass
	node.mouse_entered.connect(entered)
	node.mouse_exited.connect(exited)
	var con=Container.new()
	con.custom_minimum_size=Vector2(cell_width+margin,cell_heigh+1);
	
	con.add_child(node);
	gridView.add_child(con)
	if node as TextureRect:
		con.gui_input.connect(Callable(self,"cellclick").bind(con,node));
		pass;

func setStyle(node):
	var thumb0=node.get("thumb0")
	var thumb0_t=StyleBoxTexture.new();
	thumb0_t.draw_center=true;
	thumb0_t.texture=thumb0._image.texture;
	#thumb0_t.axis_stretch_vertical=StyleBoxTexture.AXIS_STRETCH_MODE_TILE_FIT
	#thumb0_t.set_texture_margin_all(-5)
	
	
	var thumb1=node.get("thumb1")
	var thumb1_t=StyleBoxTexture.new();
	thumb1_t.draw_center=true;
	thumb1_t.texture=thumb1._image.texture
	#thumb1_t.set_texture_margin_all(-5)
	
	var thumb2=node.get("thumb2")
	var thumb2_t=StyleBoxTexture.new();
	thumb2_t.draw_center=true;
	thumb2_t.texture=thumb2._image.texture
	#thumb2_t.set_texture_margin_all(-5)
	
	var prev0=node.get("prev0")
	var prev1=node.get("prev1")
	var prev2=node.get("prev2")
	
	var next0=node.get("next0")
	var next1=node.get("next1")
	var next2=node.get("next2")
	
	get_v_scroll_bar().add_theme_stylebox_override("grabber",thumb0_t)
	get_v_scroll_bar().add_theme_stylebox_override("grabber_highlight",thumb0_t)
	get_v_scroll_bar().add_theme_stylebox_override("grabber_pressed",thumb1_t)
	get_v_scroll_bar().add_theme_icon_override("decrement",prev0._image.texture)
	get_v_scroll_bar().add_theme_icon_override("decrement_highlight",prev1._image.texture)
	get_v_scroll_bar().add_theme_icon_override("decrement_pressed",prev2._image.texture)
	get_v_scroll_bar().add_theme_icon_override("increment",next0._image.texture)
	get_v_scroll_bar().add_theme_icon_override("increment_highlight",next1._image.texture)
	get_v_scroll_bar().add_theme_icon_override("increment_pressed",next2._image.texture)
	get_v_scroll_bar().add_theme_stylebox_override("scroll",StyleBoxLine.new())
	pass;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#get_v_scroll_bar().page=get_v_scroll_bar().max_value/5
	pass
