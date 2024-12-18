extends Node

enum OVERRIDE_TYPE {
	START_APP_WITHOUT_OVERRIDE,
	OVERRIDE_TO_SERVER,
	OVERRIDE_TO_CLIENT
}

@export var override_type : OVERRIDE_TYPE = OVERRIDE_TYPE.START_APP_WITHOUT_OVERRIDE

@export var client_scene : PackedScene # Exported client scene
@export var server_scene : PackedScene # Exported server scene

func _ready(): # Checking the condition for selecting the desired scene
	match override_type: 
		OVERRIDE_TYPE.START_APP_WITHOUT_OVERRIDE:
			print("Main: Start App / Scene Selection")
			print("DisplayServer type: %s" % [DisplayServer.get_name()])
			
			# Checking for DisplayServer name
			if DisplayServer.get_name() == "headless": 
				add_scene(server_scene)
				return
			add_scene(client_scene)
		OVERRIDE_TYPE.OVERRIDE_TO_SERVER:
			print("Main: OVERRIDE TO SERVER")
			print("Start Server...")
			add_scene(server_scene)
		OVERRIDE_TYPE.OVERRIDE_TO_CLIENT:
			print("Main: OVERRIDE TO CLIENT")
			print("Start Client...")
			add_scene(client_scene)
	

func add_scene(scene: PackedScene): # Adding a Scene to the Tree
	if scene == null:
		Global.save_and_exit()
		return
	add_child(scene.instantiate())
