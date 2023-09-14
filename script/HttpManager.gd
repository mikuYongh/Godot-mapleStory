extends CanvasLayer

func _ready():
	$HTTPTool.connect("request_completed",Callable(self,"_on_request_completed"))
	#send("http://127.0.0.1:8082/assert/wz/Character/Shoes/01070003.img.xml")

func _on_request_completed(result, response_code, headers, body):
	#var test_json_conv = JSON.new()
	#test_json_conv.parse(body.get_string_from_utf8())
	#var json = test_json_conv.get_data()
	#writeLog("acess ")
	pass;
	
func _process(delta):
	#writeLog("6666666")
	pass;
	
	

func send(path):	
	var sc:String ="";
	var scarr=path.split("/")
	for a in scarr:
		sc+=a+"_";
	sc=sc.substr(0,sc.length()-1)
	#if FileAccess.file_exists("user://"+sc+".json"):
	#	var js=FileAccess.open("user://"+sc+".json",FileAccess.READ)
	#	var s=js.get_as_text()
	#	js.close();
	#	js=null;
	#	return JSON.parse_string(s);
	
	var newPath="http://192.168.123.137:8082/assert/wz/"+path+".xml";
	#print(path,$HTTPTool.is_processing_internal())

	
	while $HTTPTool.is_processing_internal():
		await get_tree().create_timer(0.1).timeout
	$HTTPTool.request(newPath)

	var c=await $HTTPTool.request_completed
	if c&&c.size()>0:
		var body=c[3];
		var test_json_conv = JSON.new()
		test_json_conv.parse(body.get_string_from_utf8())
		var json = test_json_conv.get_data()
	
		return json;
	else : return null;
	
func writeLog(message):
	$Label.text+="\n"+message;
