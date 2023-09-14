extends Node
var ViewPortWidth;
var ViewPortHeight;
var footholdNode;
var footholds={};
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _StartLoad(map,footholds):
	footholdNode=CanvasLayer.new();
	footholdNode.name="foothold";
	footholdNode.follow_viewport_enabled=true
	footholdNode.add_to_group("load")
	ViewPortWidth=map.get_viewport_rect().size.x;
	ViewPortHeight=map.get_viewport_rect().size.y;
	#npcNode.position.x=get_viewport_rect().size.x/2;
	#npcNode.position.y=get_viewport_rect().size.y/2;
	map.add_child(footholdNode,true,2)
	self.footholds=footholds;
	loadFootHold()
func loadFootHold():
	var keys=footholds.keys();
	for key in keys:	
		var foothold=footholds[key];
		if ((foothold.layer==0 or foothold.layer==2)&&foothold.x1==foothold.x2):continue
		var staticBody=StaticBody2D.new();
		
		staticBody.set_collision_layer_value(11,true)
		staticBody.set_collision_mask_value(11,true)
		var collision=CollisionShape2D.new();
		collision.one_way_collision_margin=4;
		var shape2D=SegmentShape2D.new();
		staticBody.position=Vector2(foothold.x1,foothold.y1)
		#if foothold.x1==foothold.x2:
		#	shape2D.size=Vector2(1,abs(foothold.y1-foothold.y2))
		#if foothold.y1==foothold.y2:
		#	shape2D.size=Vector2(abs(foothold.x1-foothold.x2),1)
		shape2D.a=Vector2(foothold.x1+ViewPortWidth/2-staticBody.position.x,foothold.y1+ViewPortHeight/2-staticBody.position.y);
		shape2D.b=Vector2(foothold.x2+ViewPortWidth/2-staticBody.position.x,foothold.y2+ViewPortHeight/2-staticBody.position.y);
		collision.shape=shape2D
		#collision.debug_color="#00000000"
		if foothold.x1!=foothold.x2:
			collision.one_way_collision=true
		staticBody.add_child(collision)
		footholdNode.add_child(staticBody)
	pass;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func load(map,footholds):
	_StartLoad(map,footholds)
	

func _process(delta):
	pass
