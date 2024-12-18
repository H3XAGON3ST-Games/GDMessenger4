extends Control
class_name MessengerWSRTCClient


var _client := WebSocketClient.new()

# Connect client's signal to callable
func _init() -> void:
	_client.message_received.connect(message_received_handler)
	_client.connected_to_server.connect(client_connected_handler)
	_client.connection_closed.connect(client_disconnected_handler)


# Configure server
func _ready() -> void:
	Global.is_server = false
	
	start_listen_websocket_server()


# Listening to the server with a periodic frequency every max_count frames
@export_range(1, 30) var max_count: int = 1
var count = 0
func _physics_process(_delta) -> void:
	count += 1
	if count >= max_count and _client.socket.get_ready_state() != _client.socket.STATE_CLOSED:
		_client.external_process_poll()
		count = 0
		print("poll")
	pass


func start_listen_websocket_server() -> void:
	var err = _client.connect_to_url("%s:%s" % [Global.ip_server, str(Global.port_server)])
	
	if err != OK:
		printerr("A client server listening error was received. Client has been stopped")
		return
	
	print("Client listening has been started")


func _exit_tree():
	pass


func message_received_handler(peer_id: int, message: String):
	pass

func client_connected_handler():
	print("Client connected")

func client_disconnected_handler(peer_id: int):
	print("Client disconnected/Peer id: %s" % [peer_id])
