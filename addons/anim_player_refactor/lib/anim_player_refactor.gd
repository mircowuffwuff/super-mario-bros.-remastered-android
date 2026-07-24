## Core utility class to handle all refactoring logic

const EditorUtil := preload("res://addons/anim_player_refactor/lib/editor_util.gd")

var _editor_plugin: EditorPlugin
var _undo_redo: EditorUndoRedoManager

func _init(editor_plugin: EditorPlugin) -> void:
	_editor_plugin = editor_plugin
	_undo_redo = editor_plugin.get_undo_redo()

# Nodes
func rename_node_path(anim_player: AnimationPlayer, old: NodePath, new: NodePath):
	if old == new:
		return

	_undo_redo.create_action("Refactor node tracks", UndoRedo.MERGE_ALL, anim_player)

	_foreach_animation(anim_player, func(animation: Animation):
		for i in animation.get_track_count():
			var path := animation.track_get_path(i)
			var node_path := path.get_concatenated_names()

			if node_path == old.get_concatenated_names():
				var new_path := new.get_concatenated_names() + ":" + path.get_concatenated_subnames()
				animation.track_set_path(i, NodePath(new_path))

				_undo_redo.add_do_property(animation, "tracks/%d/path" % i, new_path)
				_undo_redo.add_undo_property(animation, "tracks/%d/path" % i, path)
	)

	_undo_redo.commit_action()


func remove_node_path(anim_player: AnimationPlayer, node_path: NodePath):
	_undo_redo.create_action("Remove node tracks", UndoRedo.MERGE_ALL, anim_player)
	
	_foreach_animation_restore(anim_player, _undo_redo, func(animation: Animation):
		var removed_tracks = 0

		for i in range(animation.get_track_count() - 1, -1, -1):
			var path = animation.track_get_path(i)

			if NodePath(path.get_concatenated_names()) == node_path:
				removed_tracks += 1
				_undo_redo.add_do_method(animation, &'remove_track', i)

		return removed_tracks
	)

	_undo_redo.commit_action()


# Tracks
func rename_track_path(anim_player: AnimationPlayer, old: NodePath, new: NodePath):
	if old == new:
		return

	_undo_redo.create_action("Refactor track paths", UndoRedo.MERGE_ALL, anim_player)

	_foreach_animation(anim_player, func(animation: Animation):
		for i in animation.get_track_count():
			var path = animation.track_get_path(i)

			if path == old:
				animation.track_set_path(i, new)

				_undo_redo.add_do_property(animation, "tracks/%d/path" % i, new)
				_undo_redo.add_undo_property(animation, "tracks/%d/path" % i, old)
	)

	_undo_redo.commit_action()


func remove_track_path(anim_player: AnimationPlayer, property_path: NodePath):
	_undo_redo.create_action("Remove tracks", UndoRedo.MERGE_ALL, anim_player)

	_foreach_animation_restore(anim_player, _undo_redo, func(animation: Animation):
		var removed_tracks = 0

		for i in range(animation.get_track_count() - 1, -1, -1):
			var path = animation.track_get_path(i)

			if path == property_path:
				removed_tracks += 1
				_undo_redo.add_do_method(animation, &'remove_track', i)

		return removed_tracks
	)

	_undo_redo.commit_action()

# Method tracks
func rename_method(anim_player, old: NodePath, new: NodePath):
	if old == new:
		return

	var node_path := NodePath(old.get_concatenated_names())
	var old_method := old.get_concatenated_subnames()
	var new_method := new.get_concatenated_subnames()

	_undo_redo.create_action("Rename method keys", UndoRedo.MERGE_ALL, anim_player)

	_foreach_animation(anim_player, func(animation: Animation):
		for i in animation.get_track_count():
			if (animation.track_get_type(i) == Animation.TYPE_METHOD and animation.track_get_path(i) == node_path):
				for j in animation.track_get_key_count(i):
					var name := animation.method_track_get_name(i, j)
					if name == old_method:
						var old_method_params := {
							"method": old_method,
							"args": animation.method_track_get_params(i, j)
						}

						var method_params := {
							"method": new_method,
							"args": animation.method_track_get_params(i, j)
						}
						
						_undo_redo.add_do_method(animation, &'track_set_key_value', i, j, method_params)
						_undo_redo.add_undo_method(animation, &'track_set_key_value', i, j, old_method_params)
	)

	_undo_redo.commit_action()


func remove_method(anim_player: AnimationPlayer, method_path: NodePath):
	_undo_redo.create_action("Remove method keys", UndoRedo.MERGE_ALL, anim_player)
	
	_foreach_animation_restore(anim_player, _undo_redo, func(animation: Animation):
		for i in animation.get_track_count():
			if (
				animation.track_get_type(i) == Animation.TYPE_METHOD
				and StringName(animation.track_get_path(i)) == method_path.get_concatenated_names()
			):
				for j in range(animation.track_get_key_count(i) - 1, -1, -1):
					var name := animation.method_track_get_name(i, j)
					if name == method_path.get_concatenated_subnames():
						_undo_redo.add_do_method(animation, &'track_remove_key', i, j)
		return 0
	)

	_undo_redo.commit_action()


# Root
func change_root(anim_player: AnimationPlayer, new_path: NodePath):
	var current_root: Node = anim_player.get_node(anim_player.root_node)
	var new_root: Node = anim_player.get_node_or_null(new_path)

	if new_root == null:
		return

	_undo_redo.create_action("Change animation player root", UndoRedo.MERGE_ALL, anim_player)

	_foreach_animation(anim_player, func(animation: Animation):
		for i in animation.get_track_count():
			var path := animation.track_get_path(i)
			var node := current_root.get_node_or_null(NodePath(path.get_concatenated_names()))

			if node == null:
				push_warning("Invalid path: %s. Skipping root change." % path)
				continue
			
			var updated_path = str(new_root.get_path_to(node)) + ":" + path.get_concatenated_subnames()

			_undo_redo.add_do_property(animation, "tracks/%d/path" % i, updated_path)
			_undo_redo.add_undo_property(animation, "tracks/%d/path" % i, path)
	)

	_undo_redo.add_do_property(anim_player, "root_node", new_path)
	_undo_redo.add_undo_property(anim_player, "root_node", anim_player.root_node)

	_undo_redo.commit_action()
	


# Helper methods

## Iterates over all animations in the animation player
static func _foreach_animation(anim_player: AnimationPlayer, callback: Callable):
	for lib_name in anim_player.get_animation_library_list():
		var lib := anim_player.get_animation_library(lib_name)
		for animation_name in lib.get_animation_list():
			var animation := lib.get_animation(animation_name)
			callback.call(animation)


## Iterates over all animations in the animation player and adds a full revert to the undo stack
## Useful for do actions that remove tracks
static func _foreach_animation_restore(anim_player: AnimationPlayer, undo_redo: EditorUndoRedoManager, callback: Callable):
	for lib_name in anim_player.get_animation_library_list():
		var lib := anim_player.get_animation_library(lib_name)
		for animation_name in lib.get_animation_list():
			var animation := lib.get_animation(animation_name)
			
			var old_anim := animation.duplicate(true)
		
			var removed_tracked = callback.call(animation)

			for i in range(animation.get_track_count() - 1 - removed_tracked, -1, -1):
				undo_redo.add_undo_method(animation, &'remove_track', i)

			for i in range(old_anim.get_track_count()):
				undo_redo.add_undo_method(old_anim, &'copy_track', i, animation)
			
			undo_redo.add_undo_reference(old_anim)
