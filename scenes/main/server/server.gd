extends Control
class_name MessengerWSRTCServer


# PostgreSQL Database instance 
@onready var database := preload("res://addons/postgre-sql/database.gd").new()


# Base server WebSocket 
var websocket_server := WebSocketServer.new()
var _clients: Dictionary = {}
var _nickname_to_id = {}

# Base server WebRTC for VOIP
var webrtc_server := WebRTCServer.new()


# Connect server's signal to callable
func _init() -> void:
	websocket_server.message_received.connect(message_received_handler)
	websocket_server.client_connected.connect(client_connected_handler)
	websocket_server.client_disconnected.connect(client_disconnected_handler)


# Configure server
func _ready() -> void:
	Global.is_server = true
	
	start_listen_websocket_server()

func _exit_tree():
	websocket_server.stop()
	print("Server: Server has been stopped")


# Listening to the server with a periodic frequency every max_count frames
@export_range(1, 30) var max_count: int = 1
var count = 0
func _physics_process(_delta) -> void:
	count += 1
	if count >= max_count and websocket_server.tcp_server.is_listening():
		websocket_server.external_process_poll()
		database.external_process_poll()
		count = 0
		#print("poll")
	pass
	#webrtc_server.external_process_poll()


func start_listen_websocket_server() -> void:
	var err := websocket_server.listen(Global.port_server)
	
	if err != OK:
		printerr("Server: A server listening error was received. Server has been stopped")
		return
	
	print("Server: Server has been started")


func message_received_handler(peer_id: int, message: String):
	pass

func client_connected_handler(peer_id: int):
	
	print("Server: Client connected/Peer id: %s" % [peer_id])

func client_disconnected_handler(peer_id: int):
	print("Server: Client disconnected/Peer id: %s" % [peer_id])

func send_to_peer_id(peer_id, data) -> void:
	if _clients.has(peer_id):
		websocket_server.send(peer_id, data)
	else: 
		printerr("Server: Client with peer_id: %s doesn't exists" % [peer_id])
