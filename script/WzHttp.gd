class_name WzHttp
var httpRequest=null;
func _ready():
	httpRequest=HTTPRequest.new();
	
	httpRequest.connect("request_completed",Callable(self,"_on_request_completed"))
	#send("http://127.0.0.1:8082/assert/wz/Character/Shoes/01070003.img.xml")

func _on_request_completed(result, response_code, headers, body):
	#var test_json_conv = JSON.new()
	#test_json_conv.parse(body.get_string_from_utf8())
	#var json = test_json_conv.get_data()
	pass;
	
	
	
func send(path):
	var newPath="http://192.168.123.137:8082/assert/wz/"+path+".xml";
	httpRequest.request(newPath)
	var c=await httpRequest.request_completed
	if c&&c.size()>0:
		var body=c[3];
		var test_json_conv = JSON.new()
		test_json_conv.parse(body.get_string_from_utf8())
		var json = test_json_conv.get_data()
		return json;
	else : return null;


	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
