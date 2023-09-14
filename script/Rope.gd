extends Node
var ViewPortWidth;
var ViewPortHeight;
var ropesNode;
var ropes={};
func _StartLoad(map,ropes):
	ropesNode=CanvasLayer.new();
	ropesNode.name="rope";
	ropesNode.follow_viewport_enabled=true
	ropesNode.add_to_group("load")
	ViewPortWidth=map.get_viewport_rect().size.x;
	ViewPortHeight=map.get_viewport_rect().size.y;
	#npcNode.position.x=get_viewport_rect().size.x/2;
	#npcNode.position.y=get_viewport_rect().size.y/2;
	map.add_child(ropesNode,true,2)
	self.ropes=ropes;
	loadRope()
func loadRope():
	var keys=ropes.keys();
	for key in keys:	
		var rope=ropes[key];
		var staticBody=StaticBody2D.new();
		staticBody.set_collision_layer_value(14,true)
		var collision=CollisionShape2D.new();
		var shape2D=SegmentShape2D.new();
		staticBody.position=Vector2(rope.x,rope.y1)
		shape2D.a=Vector2(ViewPortWidth/2,rope.y1+ViewPortHeight/2-staticBody.position.y);
		shape2D.b=Vector2(ViewPortWidth/2,rope.y2+ViewPortHeight/2-staticBody.position.y);
		staticBody.set_meta("start",Vector2(rope.x+ViewPortWidth/2,rope.y1+ViewPortHeight/2))
		staticBody.set_meta("end",Vector2(rope.x+ViewPortWidth/2,rope.y2+ViewPortHeight/2))
		collision.shape=shape2D
		#collision.debug_color="#00000000"
		staticBody.add_child(collision)
		ropesNode.add_child(staticBody)
	pass;
func load(map,ropes):
	_StartLoad(map,ropes)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
