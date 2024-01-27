extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = get_node_or_null("Player")
	var butters = get_node_or_null("Butters")
	var honey = get_node_or_null("Honey")
	var raspby = get_node_or_null("Raspby")
	var player_position = player.position
	if butters != null:
		butters.escape(player_position, delta)
	if honey != null:
		honey.escape(player_position, delta)
	if raspby != null:
		raspby.escape(player_position, delta)
	pass
