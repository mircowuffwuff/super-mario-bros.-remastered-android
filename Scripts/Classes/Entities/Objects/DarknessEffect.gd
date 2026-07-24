class_name DarknessEffect
extends Node2D

const LIGHT = preload("uid://c1plxbl04na5g")

var tracking_nodes := {}

static var current_effect: DarknessEffect = null

func _ready() -> void:
	current_effect = self

func _exit_tree() -> void:
	if current_effect == self:
		current_effect = null

func add_nodes() -> void:
	tracking_nodes.clear()
	for i in $CanvasLayer/CanvasGroup.get_children():
		if i.get_index() > 0:
			i.queue_free()
	for i in get_tree().get_nodes_in_group("Lights"):
		if i.is_inside_tree():
			add_light_to_node(i)
	$CanvasLayer/AnimationPlayer.play("Grow")

func _physics_process(_delta: float) -> void:
	$CanvasLayer/CanvasGroup/Darkness.size = get_viewport().get_visible_rect().size
	for i: Node2D in get_tree().get_nodes_in_group("Lights"):
		if tracking_nodes.has(i):
			tracking_nodes[i].global_position = i.get_global_transform_with_canvas().origin
			tracking_nodes[i].visible = i.is_visible_in_tree()
func add_light_to_node(node: LightBarer) -> void:
	var new_light = LIGHT.instantiate()
	tracking_nodes[node] = new_light
	new_light.scale = Vector2(node.size, node.size)
	$CanvasLayer/CanvasGroup.add_child(new_light)
	new_light.global_position = node.get_global_transform_with_canvas().origin
	new_light.reset_physics_interpolation()
	node.tree_exiting.connect(node_deleted.bind(node))

func node_deleted(node: LightBarer) -> void:
	if is_queued_for_deletion() or is_inside_tree() == false:
		return
	if tracking_nodes.has(node):
		tracking_nodes[node].queue_free()
	tracking_nodes.erase(node)
