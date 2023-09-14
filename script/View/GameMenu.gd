extends UI
@export var path="GameMenu"
var gameMenuPos=Vector2(800,600);
var offsetY=28;
var back:Sprite2D;
var backgroundRect;
var backgroundSize=Vector2.ZERO;
var gamMenuArray=["BtChannel","BtGameOpt","BtSysOpt","BtJoyPad","BtQuit"];
var shortCutArray=["BtItem","BtEquip","BtStat","BtSkill","BtComm","BtQuest","BtMobbook","BtMessenger"];
signal item_click_event;
# Called when the node enters the scene tree for the first time.
func _ready():
	self.z_index=1000;
	self.visible=false;
	top_level=true;
	var gameMenuPos;
	if path=="GameMenu":
		gameMenuPos=Vector2(775,565);
	if path=="ShortCut":
		gameMenuPos=Vector2(800,565);
	#var node=MapleWz.get_by_path("UI/UIWindow.img/"+path)
	#if !node:return;
	#var data=node.data;

	back=addImage("UIWindow.img/"+path+"/backgrnd",gameMenuPos.x,gameMenuPos.y,true)
	backgroundRect=back.get_rect();
	backgroundSize=back.get_rect().size;
	if path=="GameMenu":
		for key in gamMenuArray:
			var button=addButton("UIWindow.img/"+path+"/"+key,gameMenuPos.x-4-backgroundSize.x/2,gameMenuPos.y+offsetY-backgroundSize.y,false);
			offsetY+=button.size.y-6;
			button.pressed.connect(Callable(self,"item_click").bind(key))
			
	if path=="ShortCut":
		for key in shortCutArray:
			var button=addButton("UIWindow.img/"+path+"/"+key,gameMenuPos.x-4-backgroundSize.x/2,gameMenuPos.y+offsetY-backgroundSize.y,false);
			offsetY+=button.size.y-6;
			button.pressed.connect(Callable(self,"item_click").bind(key))
		
			
	pass # Replace with function body.
func item_click(key):
	emit_signal("item_click_event",key)

func _input(event):
	if event as InputEventMouseButton:
		
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and !backgroundRect.has_point(event.position-back.position):
			self.visible=false;
			pass;

func _process(delta):
	pass
	
func setPath(path):
	self.path=path;
