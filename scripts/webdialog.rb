@dialog 	= UI::WebDialog.new("My Title", false, "my_key", 1, 1, 1, 1, false)
@dialog.set_size(510, 380)
@dialog.set_file File.dirname(__FILE__) + "/web_dialog.html"

@dialog.add_action_callback("create_room_space") {|dialog, param| 
	puts "params"+param.to_s 
}
@dialog.show