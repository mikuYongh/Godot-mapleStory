extends Control
class_name UI;
var wzTool:MapleWz;
var cursor:CursorCTRL=Cursor;
var bgmEF:BgmManager=AduioBGM;
var dragging=false;
func setWzTool(wzTool):
	self.wzTool=wzTool;

func _init():
	setWzTool(MapleWz)
func addThreeImage(path,x,y,width,height,pNode=null):
	#提供三方位图
	var node=Container.new();
	var result=wzTool.get_by_path("UI/"+path);
	var uiNode:Dictionary=result.data;
	if !uiNode.is_empty():
		var w=uiNode.get("w");
		var c=uiNode.get("c");
		var e=uiNode.get("e");
		var w_t=TextureRect.new();
		var c_t=TextureRect.new();
		var e_t=TextureRect.new();
		w_t.texture=w._image.texture;
		w_t.size.y=height;
		e_t.texture=e._image.texture;
		e_t.size.y=height;
		e_t.position.x=width+w._image.width;
		c_t.texture=c._image.texture;
		c_t.size=Vector2(width,height)
		c_t.position.x=w._image.width
		node.add_child(w_t);
		node.add_child(e_t);
		node.add_child(c_t)
		node.position=Vector2(x,y)
		if pNode:
			pNode.add_child(node)
		else:
			add_child(node)
		pass;
		return node;
		
func addEightImage(path,x,y,width,height,pNode=null):
	var node=Container.new();
	#提供九方位图
	var result=wzTool.get_by_path("UI/"+path);
	var uiNode:Dictionary=result.data;
	if !uiNode.is_empty():
		var nw=uiNode.get("0");
		var n=uiNode.get("1");
		var ne=uiNode.get("2");
		var w=uiNode.get("3");
		var e=uiNode.get("4");
		var sw=uiNode.get("5");
		var s=uiNode.get("6");
		var se=uiNode.get("7");
		var nw_t=TextureRect.new();
		var n_t=TextureRect.new();
		var ne_t=TextureRect.new();
		#中层		
		var w_t=TextureRect.new();
		var c_t=TextureRect.new();
		var e_t=TextureRect.new();
		#底层
		var sw_t=TextureRect.new();
		var s_t=TextureRect.new();
		var se_t=TextureRect.new();
		nw_t.texture=nw._image.texture;
		n_t.texture=n._image.texture;
		n_t.position=Vector2(nw._image.width,0)
		n_t.size.x=width;
		ne_t.texture=ne._image.texture;
		ne_t.position=Vector2(nw._image.width+width,0)
		
		
		
		sw_t.texture=sw._image.texture;
		sw_t.position=Vector2(0,height+nw._image.height-sw._image.height)
		s_t.texture=s._image.texture;
		s_t.position=Vector2(sw._image.width,height+n._image.height-s._image.height)
		s_t.size.x=width;
		se_t.texture=se._image.texture;
		se_t.position=Vector2(sw._image.width+width,height+ne._image.height-se._image.height+1)
		
		w_t.texture=w._image.texture;
		w_t.position=Vector2(0,nw._image.height)
		w_t.size.y=height-sw._image.height
		e_t.texture=e._image.texture;
		e_t.size.y=height-se._image.height+1
		e_t.position=Vector2(width+w._image.width,nw._image.height-1)
		
		node.add_child(nw_t)
		node.add_child(n_t)
		node.add_child(ne_t)
		
		node.add_child(w_t)
		node.add_child(e_t)
		node.add_child(c_t)
		
		node.add_child(sw_t);
		node.add_child(s_t);
		node.add_child(se_t);
		
		node.position=Vector2(x,y)
		if pNode:
			pNode.add_child(node)
		else:
			add_child(node)
		return node;

func addNineImage(path,x,y,width,height,pNode=null):
	var node=Container.new();
	#提供九方位图
	var result=wzTool.get_by_path("UI/"+path);
	var uiNode:Dictionary=result.data;
	if !uiNode.is_empty():
		var nw=uiNode.get("nw");
		var n=uiNode.get("n");
		var ne=uiNode.get("ne");
		var w=uiNode.get("w");
		var e=uiNode.get("e");
		var sw=uiNode.get("sw");
		var s=uiNode.get("s");
		var se=uiNode.get("se");
		var c=uiNode.get("c");
		var nw_t=TextureRect.new();
		var n_t=TextureRect.new();
		var ne_t=TextureRect.new();
		#中层		
		var w_t=TextureRect.new();
		var c_t=TextureRect.new();
		var e_t=TextureRect.new();
		#底层
		var sw_t=TextureRect.new();
		var s_t=TextureRect.new();
		var se_t=TextureRect.new();
		nw_t.texture=nw._image.texture;
		n_t.texture=n._image.texture;
		n_t.position=Vector2(nw._image.width,0)
		n_t.size.x=width;
		ne_t.texture=ne._image.texture;
		ne_t.position=Vector2(nw._image.width+width,0)
		
		
		
		sw_t.texture=sw._image.texture;
		sw_t.position=Vector2(0,height+nw._image.height-sw._image.height)
		s_t.texture=s._image.texture;
		s_t.position=Vector2(sw._image.width,height+n._image.height-s._image.height)
		s_t.size.x=width;
		se_t.texture=se._image.texture;
		se_t.position=Vector2(sw._image.width+width,height+ne._image.height-se._image.height)
		
		w_t.texture=w._image.texture;
		w_t.position=Vector2(0,nw._image.height)
		w_t.size.y=height-sw._image.height
		e_t.texture=e._image.texture;
		e_t.size.y=height-se._image.height
		e_t.position=Vector2(width+w._image.width,nw._image.height)
		c_t.texture=c._image.texture;
		c_t.size=Vector2(width,height-s._image.height)
		c_t.z_index=-1;
		c_t.position=Vector2(w._image.width,nw._image.height)
		node.add_child(nw_t)
		node.add_child(n_t)
		node.add_child(ne_t)
		
		node.add_child(w_t)
		node.add_child(e_t)
		node.add_child(c_t)
		
		node.add_child(sw_t);
		node.add_child(s_t);
		node.add_child(se_t);
		
		node.position=Vector2(x,y)
		if pNode:
			pNode.add_child(node)
		else:
			add_child(node)
		return node;
	
		
	
func addImage(path,x,y,autoPos=false,info={},pNode=null):
	var result=wzTool.get_by_path("UI/"+path);
	var uiNode:Dictionary=result.data;
	if !uiNode.is_empty():
		var texture=Sprite2D.new();
		var img=Game.Wz_getImage(uiNode,uiNode);
		texture.texture=img["img"];
		texture.position.x=x;
		texture.position.y=y;
		if autoPos==true:
			texture.position.x=texture.position.x-img["width"];
			texture.position.y=texture.position.y-img["height"]
		texture.centered=false;
		#texture.texture=img["img"]
		if pNode:
			pNode.add_child(texture)
		else:
			add_child(texture)
		return texture;
func addTab(x,y,iconPath,tabStyle="Tab2",pNode=null):
	var tab=MapleTab.new()
	tab.style=tabStyle;
	tab.iconPath=iconPath;
	tab.position=Vector2(x,y)
	if pNode:
		pNode.add_child(tab)
	else:
		add_child(tab)
	pass;
func addEditText(x,y,width,height,fontsize:int=12,texthelper="",pNode=null):
	var textedit=TextEdit.new()
	textedit.placeholder_text=texthelper
	textedit.position.x=x;
	textedit.position.y=y;
	textedit.add_theme_font_size_override("font_size",fontsize)
	textedit.size.x=width;
	textedit.size.y=height
	#textedit.add_theme_color_override("caret_background_color",Color(0,0,0,0))
	var npcStyleBox=StyleBoxFlat.new();
	npcStyleBox.bg_color=Color(0, 0, 0, 0.3);
	textedit.add_theme_stylebox_override("normal",npcStyleBox)
	if pNode:
		pNode.add_child(textedit)
	else:
		add_child(textedit)
	pass;
	return textedit;
	
			
func addButton(path,x,y,autoPos=false,info={},pNode=null):
	#用于添加节点
	var isCustorClickHover=info.get("isCustorClickHover",true);
	var isCustorGiftHover=info.get("isCustorGiftHover",false);
	var isMenu=info.get("isMenu",false);
	var uiNode:Dictionary=wzTool.get_by_path("UI/"+path).data;
	if !uiNode.is_empty():
		if uiNode.has("normal")&&uiNode["normal"].has("0"):
			var normal=uiNode["normal"]["0"];
			var mouseOver=uiNode["mouseOver"]["0"];
			var pressed=uiNode["pressed"]["0"];
			var disabled=uiNode["disabled"]["0"];
			var button=Button.new()
			#var texture=Sprite2D.new();
			var normal_img=Game.Wz_getImage(normal,uiNode);
			var mouseOver_img=Game.Wz_getImage(mouseOver,uiNode);
			var pressed_img=Game.Wz_getImage(pressed,uiNode);
			var disabled_img=Game.Wz_getImage(disabled,uiNode);
			button.flat=true;
			button.clip_contents=true;
			button.position.x=x-normal_img["width"]/2;
			button.position.y=y-normal_img["height"]/2;
			#button.set_color("icon_disabled_color","normal",Color(1,1,1,1))
			button.icon=normal_img["img"]
			
			if autoPos==true:
				button.position.x=button.position.x-normal_img["width"];
				button.position.y=button.position.y-normal_img["height"];
			#button.z_index=100
			var mouse_enter=func():
				if button.disabled:return;
				if self.dragging:return;
				print(button.pressed)
				button.icon=mouseOver_img["img"];
				if isCustorClickHover:
					cursor._play("hover");
					bgmEF.playBGM("UI/BtMouseOver")
				pass;
			var mouse_exit=func():
				if button.disabled:return;
				button.icon=normal_img["img"];
				cursor._play("normal")
				pass;
			var btn_down=func():
				if button.disabled:return;
				button.icon=pressed_img["img"];
				
				
			var btn_up=func():
				if button.disabled:return;
				button.icon=normal_img["img"];
				if isMenu:
					bgmEF.playBGM("UI/DlgNotice")
					return;
				bgmEF.playBGM("UI/BtMouseClick")
				
			var draw=func():
				var mode=button.get_draw_mode()
				if mode==Button.DRAW_DISABLED:
					button.icon=disabled_img["img"];
				else:
					button.icon=normal_img["img"];
			button.button_down.connect(btn_down)
			button.button_up.connect(btn_up)
			button.draw.connect(draw)
			button.mouse_entered.connect(mouse_enter);
			button.mouse_exited.connect(mouse_exit)
			#button.z_as_relative=false;
			#button.focus_entered.call()
			#texture.centered=false;
			#texture.texture=img["img"]
			if pNode:
				pNode.add_child(button)
			else:
				add_child(button)
			pass;
			return button;

func addLabel(x,y,info={
	"text":"",
	"color":Color(0,0,0),
	"size":12,
},pNode=null):
	var label=Label.new();
	label.text=info.text;
	label.add_theme_color_override("font_color", info.color)
	label.add_theme_font_size_override("font_size",info.get(size,12))
	label.position=Vector2(x,y)
	if pNode:
		pNode.add_child(label)
	else:
		add_child(label)
	pass;
	return label;
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func free_view(view):
	if view:
		view.queue_free();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
