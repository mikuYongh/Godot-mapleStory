extends Node2D
signal Anifinish;
signal finish;
# Called when the node enters the scene tree for the first time.
func _ready():
	AduioBGM.playBGM("Game/Portal")	
	var tween=get_tree().create_tween()
	
	tween.tween_property($CanvasLayer/ColorRect, "color", Color.BLACK,0.5) ;
	tween.tween_callback(Callable(self,"runAniFinish"))
	tween.tween_interval(1)
	
	tween.chain().tween_property($CanvasLayer/ColorRect, "color", Color(0,0,0,0.1),0.3) ;
	await tween.finished
	
	emit_signal("finish")
	self.queue_free();
	pass # Replace with function body.

func runAniFinish():
	emit_signal("Anifinish")
func runFinish():
	emit_signal("finish")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
