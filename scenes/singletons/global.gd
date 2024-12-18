extends Node

const version : String = "0.3.0-beta"

var is_server: bool

var ip_server: String = "localhost"
var port_server: int = 2000
var port_rtc_server: int = 2001

var global_username := "postgres"
var global_password := "1234"
var global_host := "localhost"
var global_port := 5432
var global_database_name := "gmessenger"


func save_and_exit():
	#save_data()
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()


class ClientServerData:
	var nickname
