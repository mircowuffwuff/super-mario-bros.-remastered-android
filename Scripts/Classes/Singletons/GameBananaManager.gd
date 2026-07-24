extends Node

enum Type{ALL, RESOURCE_PACK = 37941, CUSTOM_CHARACTER = 39525}
enum Sort{RECENT, DOWNLOADS, FEATURED}

signal response_recieved(response: Dictionary)
signal response_failed()

@onready var http = HTTPRequest.new()

const GAME_ID = 22798

var current_list := []

signal list_recieved

func _ready() -> void:
	add_child(http)
	http.request_completed.connect(on_request_completed)

func get_mod_list(page_num := 0, filter := Type.ALL, sort := Sort.FEATURED, search := "") -> Array:
	var url := generate_url(page_num, filter, sort, search)
	print(url)
	http.request(url)
	await list_recieved
	return current_list

## Credit - TekkaGB: PizzaOven, FeedGenerator.cs
func generate_url(page_num := 0, filter := Type.ALL, sort := Sort.FEATURED, search := "") -> String:
	var url := "https://gamebanana.com/apiv6/Mod/"
	
	if search != "":
		url += "ByName?_sName=*{search}*&_idGameRow={GAMEID}&".format({"search": search, "GAMEID": GAME_ID})
	else:
		url += "ByGame?_aGameRowIds[]={GAMEID}&".format({"GAMEID": GAME_ID})

	url += "_csvProperties=_sName,_sModelName,_aSubmitter,_tsDateUpdated,_tsDateAdded,_sDescription,_aCategory,_aRootCategory,_aFiles"
	
	match sort:
		Sort.RECENT:
			url += "&_sOrderBy=_tsDateUpdated,DESC"
		Sort.FEATURED:
			url += "&_aArgs[]=_sbWasFeatured%20=%20true&_sOrderBy=_tsDateAdded,DESC"
		Sort.DOWNLOADS:
			url += "&_sOrderBy=_nDownloadCount,DESC"
	
	if filter != Type.ALL:
		url += "&_aCategoryRowIds[]={ID}".format({"ID": filter})
	
	url += "&_nPage={PAGE}".format({"PAGE": page_num})
	return url

func on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == HTTPClient.RESPONSE_OK:
		var json = JSON.parse_string(body.get_string_from_utf8())
		current_list = json
		list_recieved.emit()
	else:
		print([result, response_code, headers, body.get_string_from_utf8()])
