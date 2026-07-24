@tool
extends Tree

var _editor_plugin: EditorPlugin
var _gui: Control

func init(editor_plugin: EditorPlugin):
	_editor_plugin = editor_plugin
	_gui = editor_plugin.get_editor_interface().get_base_control()

func render(anim_player: AnimationPlayer):
	clear()
	
	_create_items(null, anim_player, anim_player.owner)
	

func _create_items(parent: TreeItem, anim_player: AnimationPlayer, node: Node):
	var icon := _gui.get_theme_icon(node.get_class(), "EditorIcons")
	
	var item := create_item(parent)
	item.set_text(0, node.name)
	item.set_icon(0, icon)
	item.set_metadata(0, anim_player.get_path_to(node))
	
	if anim_player.get_path_to(node) == anim_player.root_node:
		item.select(0)
		scroll_to_item(item)
	
	for child in node.get_children():
		_create_items(item, anim_player, child)
