@tool
extends Tree

signal rendered

const EditInfo := preload("edit_info.gd")

@export var edittable_items := false


func _ready() -> void:
	reset_size()


func render(editor_plugin: EditorPlugin, anim_player: AnimationPlayer) -> void:
	clear()

	# Get paths
	var animations = anim_player.get_animation_list()
	var root_node := anim_player.get_node(anim_player.root_node)

	var track_paths := {}  # Dictionary[NodePath, Dictionary[NodePath, EditInfo]]

	# Get EditInfo data
	for anim_name in animations:
		var animation := anim_player.get_animation(anim_name)

		for i in animation.get_track_count():
			var path := animation.track_get_path(i)
			var type := animation.track_get_type(i)

			var node_path := NodePath(path.get_concatenated_names())
			var property_path := path.get_concatenated_subnames()
			var node := root_node.get_node_or_null(node_path)

			var edit_infos: Array[EditInfo] = []

			if not node_path in track_paths:
				track_paths[node_path] = {}
			match type:
				Animation.TYPE_METHOD:
					for j in animation.track_get_key_count(i):
						var method_path = NodePath(
							(
								path.get_concatenated_names()
								+ ":"
								+ animation.method_track_get_name(i, j)
							)
						)

						var edit_info = EditInfo.new(
							EditInfo.Type.METHOD_TRACK, method_path, node_path, node, [anim_name]
						)

						edit_infos.append(edit_info)
				_:
					if not property_path.is_empty():
						var edit_info = EditInfo.new(
							EditInfo.Type.VALUE_TRACK, path, node_path, node, [anim_name]
						)

						edit_infos.append(edit_info)
			
			# Combine
			for info in edit_infos:
				if not StringName(info.path) in track_paths[node_path]:
					track_paths[node_path][StringName(info.path)] = info
				else:
					for name in info.animation_names:
						if name in track_paths[node_path][StringName(info.path)].animation_names: continue
						track_paths[node_path][StringName(info.path)].animation_names.append(name)

	# Sort
	var paths := track_paths.keys()
	paths.sort()

	var tree_root: TreeItem = create_item()
	hide_root = true

	# Get icons
	var gui := editor_plugin.get_editor_interface().get_base_control()

	# Render
	for path in paths:
		var node := root_node.get_node_or_null(path)
		var icon := gui.get_theme_icon(node.get_class() if node != null else "", "EditorIcons")

		var path_item = create_item(tree_root)
		path_item.set_editable(0, edittable_items)
		if edittable_items:
			path_item.set_text(0, path)
			if path.get_concatenated_names() == ".." and node:
				path_item.set_suffix(0, "(" + node.name + ")")
		else:
			path_item.set_text(0, node.name if node else path)
		path_item.set_icon(0, icon)
		path_item.set_metadata(0, EditInfo.new(EditInfo.Type.NODE, path, path, node, []))
		path_item.add_button(0, gui.get_theme_icon("Edit", "EditorIcons"))
		path_item.add_button(0, gui.get_theme_icon("Remove", "EditorIcons"))

		var property_paths: Array = track_paths[path].keys()
		property_paths.sort()

		for property_path in property_paths:
			var info: EditInfo = track_paths[path][property_path]
			var edit_type = EditInfo.Type.VALUE_TRACK
			var icon_type = "KeyValue"
			var invalid = false
			var property := info.path.get_concatenated_subnames()
			if node == null:
				invalid = true
				icon_type = ""
			elif node.has_method(StringName(property)):
				icon_type = "KeyCall"
			elif str(info.path) in node or node.get_indexed(NodePath(property)) != null:
				pass
			else:
				invalid = true
				icon_type = ""

			var property_item = create_item(path_item)
			property_item.set_editable(0, edittable_items)
			property_item.set_text(0, property)
			property_item.set_icon(0, gui.get_theme_icon(icon_type, "EditorIcons"))
			property_item.set_metadata(0, info)
			property_item.add_button(0, gui.get_theme_icon("Edit", "EditorIcons"))
			property_item.add_button(0, gui.get_theme_icon("Remove", "EditorIcons"))

			if invalid:
				property_item.set_custom_color(0, Color.RED)
				property_item.set_tooltip_text(0, "Possibly invalid value: %s" % info.path)
	rendered.emit()


func set_filter(filter: String):
	var item_stack := []
	var visited := []

	item_stack.append(get_root())

	# Post-order traversal
	while not item_stack.is_empty():
		var current: TreeItem = item_stack[item_stack.size() - 1]
		var children = current.get_children() if current else []

		var children_all_visited := true
		var child_visible := false

		for child in children:
			children_all_visited = children_all_visited and child in visited
			child_visible = child_visible or child.visible

		if children_all_visited:
			item_stack.pop_back()
			if current:
				if current == get_root() or filter.is_empty() or child_visible:
					current.visible = true
				else:
					current.visible = current.get_text(0).to_lower().contains(filter.to_lower())
			visited.append(current)
		else:
			item_stack += children


## Class to cache heirarchy of nodes
## Unused
class TreeNode:
	var node: Node
	var path: String
	var children: Dictionary
	var parent: TreeNode

	func debug(level = 0):
		print(" - ".repeat(level) + node.name)
		for name in children:
			children[name].debug(level + 1)
