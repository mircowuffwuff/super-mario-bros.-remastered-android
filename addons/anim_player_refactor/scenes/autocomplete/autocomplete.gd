extends CodeEdit


func _ready() -> void:
	code_completion_enabled = true
	add_code_completion_option(CodeEdit.KIND_MEMBER, "Test", "test")
	add_code_completion_option(CodeEdit.KIND_MEMBER, "Boo", "boo")
	code_completion_prefixes = ["t", "b"]

	code_completion_requested.connect(func(): 
		add_code_completion_option(CodeEdit.KIND_MEMBER, "Test", "test")
		add_code_completion_option(CodeEdit.KIND_MEMBER, "Boo", "boo")
		update_code_completion_options(true)
	)
	
	text_changed.connect(func(): request_code_completion(true))

