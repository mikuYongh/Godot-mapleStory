extends Node
class_name BgmManager
var lastMapBGM=null;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func playByMapBGM(bgm:String):
	if bgm==null:return;
	if lastMapBGM:
		lastMapBGM.stop();
	var arr=bgm.split("/")
	var has=self.has_node(arr[0]+"_"+arr[1]);
	var node;
	if has:
		node=self.get_node(arr[0]+"_"+arr[1]);
	else:
		node=AudioStreamPlayer.new();
		node.name=arr[0]+"_"+arr[1];
		add_child(node)
		var audio_stream:AudioStreamMP3=load("res://wz_client/Sound/"+arr[0]+".img"+"/"+arr[0]+".img"+"/"+arr[1]+".mp3");
		if audio_stream!=null:
			audio_stream.loop=true
			node.stream=audio_stream;
	self.lastMapBGM=node;
	node.play()
	pass;
func playBGM(bgm:String):
	if bgm==null:return;
	var arr=bgm.split("/")
	var has=self.has_node(arr[0]+"_"+arr[1]);
	var node;
	if has:
		node=self.get_node(arr[0]+"_"+arr[1]);
	else:
		node=AudioStreamPlayer.new();
		node.name=arr[0]+"_"+arr[1];
		add_child(node)
		var audio_stream:AudioStreamMP3=load("res://wz_client/Sound/"+arr[0]+".img"+"/"+arr[0]+".img"+"/"+arr[1]+".mp3");
		if audio_stream!=null:
			node.stream=audio_stream;
	node.play()
	pass;

func clear():
	self.remove_from_group("Bgmload")

func _exit_tree():
	self.queue_free();
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
