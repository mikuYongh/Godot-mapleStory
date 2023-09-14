extends Container
class_name MapleTab;
#使用Tab控件不能满足需求 所以重写
@export var style="Tab2";
@export var iconPath="";
@onready var wzTool:MapleWz=MapleWz;
var styleNode;
var iconNode;
var tabCount=0;
var tabWidth=30;
var selectTabIndex=-1;
var tabButtonInfo={}
# Called when the node enters the scene tree for the first time.
func _ready():
	self.z_as_relative=true;
	if iconPath=="":return;
	styleNode=wzTool.get_by_path("UI/Basic.img/"+style).data;
	
	iconNode=wzTool.get_by_path("UI/"+iconPath).data;
	var enabled=iconNode.get("enabled");
	var disabled=iconNode.get("disabled");
	var num=enabled.get("_keys").size();
	tabCount=num;
	var tabOffset=0;
	for i in num:
		var left0=styleNode.get("left0");
		var left1=styleNode.get("left1");
		var middle0=styleNode.get("middle0");
		var middle1=styleNode.get("middle1");
		var middle2=styleNode.get("middle2");
		var right0=styleNode.get("right0");
		var right1=styleNode.get("right1");
		var fill0=styleNode.get("fill0");
		var fill1=styleNode.get("fill1");
		var enableIcon=enabled.get(str(i));
		var disableIcon=disabled.get(str(i));
		var button_enabled = Button.new();
		button_enabled.size.x=tabWidth;
		button_enabled.position.x=tabOffset;
		button_enabled.visible=false;
		var button_disabled = Button.new();
		button_disabled.size.x=tabWidth;
		button_disabled.position.x=tabOffset;
		var left_sprite=TextureRect.new();
		var right_sprite=TextureRect.new();
		var middle_sprite=TextureRect.new();
		var fill_sprite=TextureRect.new();
		var icon_sprite=TextureRect.new();
		var left2_sprite=TextureRect.new();
		var right2_sprite=TextureRect.new();
		var middle2_sprite=TextureRect.new();
		var fill2_sprite=TextureRect.new();
		var icon2_sprite=TextureRect.new();
		left_sprite.texture=left0._image.texture;
		icon_sprite.texture=disableIcon._image.texture;
		icon_sprite.position=Vector2(disableIcon._image.width/8,disableIcon._image.height/8)
		
		fill_sprite.texture=fill0._image.texture;
		fill_sprite.size=Vector2(tabWidth,left0._image.height)
		right_sprite.texture=right0._image.texture;
		right_sprite.position.x=tabWidth;
		middle_sprite.texture=middle0._image.texture;
		middle_sprite.position.x=tabWidth;
		button_disabled.flat=true;
		button_disabled.add_child(fill_sprite)
		button_disabled.add_child(left_sprite);
		
		button_disabled.add_child(right_sprite);
		if i!=num-1:
			button_disabled.add_child(middle_sprite);	
		button_disabled.add_child(icon_sprite)
		add_child(button_disabled)
		#enable
		left2_sprite.texture=left1._image.texture;
		icon2_sprite.texture=enableIcon._image.texture;
		icon2_sprite.position=Vector2(enableIcon._image.width/8,enableIcon._image.height/8)
		
		fill2_sprite.texture=fill1._image.texture;
		fill2_sprite.size=Vector2(tabWidth,left1._image.height)
		right2_sprite.texture=right1._image.texture;
		right2_sprite.position.x=tabWidth;
		middle2_sprite.texture=middle1._image.texture;
		middle2_sprite.position.x=tabWidth;
		button_enabled.flat=true;
		button_enabled.add_child(fill2_sprite)
		button_enabled.add_child(left2_sprite);
		
		button_enabled.add_child(right2_sprite);
		if i!=num-1:
			button_enabled.add_child(middle2_sprite);	
		button_enabled.add_child(icon2_sprite)
		add_child(button_enabled)
		tabOffset+=tabWidth+middle0._image.width/2;
		tabButtonInfo[str(i)]={"enabled":button_enabled,"disabled":button_disabled};
		button_enabled.button_down.connect(Callable(self,"selectTab").bind(i))
		button_disabled.button_down.connect(Callable(self,"selectTab").bind(i))
	selectTab(0,false);
	
	
	
	pass # Replace with function body.
func selectTab(index=0,playSound=true):
	selectTabIndex=index;
	if playSound:
		AduioBGM.playBGM("UI/Tab")
	for i in tabButtonInfo.size():	
		var enabled:Button=tabButtonInfo[str(i)].enabled;
		var disabled:Button=tabButtonInfo[str(i)].disabled;
		enabled.visible=false;
		disabled.visible=false;
		if i==index:
			enabled.visible=true;
		else:
			disabled.visible=true;
	
func tabButton_click(index):
	selectTab(index)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _exit_tree():
	self.queue_free();
	
func _process(delta):
	pass
