extends Node


const USER := "Samuel"
const PASSWORD := "my_password"
const HOST := "localhost"
const PORT := 5432 # Default postgres port
const DATABASE := "postgres" # Database name

var database: PostgreSQLClient = PostgreSQLClient.new()

func _init():
	var _error = database.connect("connection_established", _connection_established)
	_error = database.connect("authentication_error", _authentication_error)
	_error = database.connect("connection_closed", _connection_close)
	_error = database.connect("data_received", _data_received)
	
	#Connection to the database
	_error = database.connect_to_host("postgresql://%s:%s@%s:%d/%s" % [USER, PASSWORD, HOST, PORT, DATABASE])
	print("Connection process error: ", _error)
	if _error == OK:
		print("Succeful connection to database")


func external_process_poll() -> void:
	database.poll()


func _connection_established() -> void:
	prints("Postgre: Connection established, Status:", database.parameter_status)


func _data_received(error_object: Dictionary, transaction_status: PostgreSQLClient.TransactionStatus, datas: Array) -> void:
	prints(error_object, transaction_status, datas)
	#match transaction_status:
		#database.TransactionStatus.NOT_IN_A_TRANSACTION_BLOCK:
			#print("NOT_IN_A_TRANSACTION_BLOCK")
		#database.TransactionStatus.IN_A_TRANSACTION_BLOCK:
			#print("IN_A_TRANSACTION_BLOCK")
		#database.TransactionStatus.IN_A_FAILED_TRANSACTION_BLOCK:
			#print("IN_A_FAILED_TRANSACTION_BLOCK")
	#
	## The datas variable contains an array of PostgreSQLQueryResult object.
	#for data in datas:
		##Specifies the number of fields in a row (can be zero).
		#print(data.number_of_fields_in_a_row)
		#
		## This is usually a single word that identifies which SQL command was completed.
		## note: the "BEGIN" and "COMMIT" commands return empty values
		#print(data.command_tag)
		#
		#print(data.row_description)
		#
		#print(data.data_row)
		#
		#prints("Notice:", data.notice)
	#
	#if not error_object.is_empty():
		#prints("Error:", error_object)
	#
	#database.close()


func _authentication_error(error_object: Dictionary) -> void:
	prints("Postgre: Error connection to database:", error_object["message"])


func _connection_close(clean_closure := true) -> void:
	prints("Postgre: Connection close.", "Clean closure:", clean_closure)


func _exit_tree() -> void:
	database.close()


func get_chat_list(nickname):
	var datas = database.execute("""
		SELECT user_has_chat.id_user, tchat.id_chat 
		FROM user_has_chat 
		JOIN (SELECT id_chat FROM get_user_chat_list('%s')) tchat on user_has_chat.id_chat = tchat.id_chat """ % [nickname] + """
		WHERE user_has_chat.id_user != '%s' """ % [nickname])
	#return datas[0].raw_data_row

#Custom function for interaction with database
func set_chat(chat_id, nicknames: Array):
	var datas = database.execute("""
		INSERT INTO chat 
		VALUES
		('%s', null); """ % [chat_id] + """
		INSERT INTO user_has_chat
		VALUES
		('%s', '%s'),
		('%s', '%s'); """ % [nicknames[0], chat_id, nicknames[1], chat_id]
		)
