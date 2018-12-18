require_relative './multi_room.rb'

class RoomTool
	include Singleton	
	
	def initialize
		@count = 1
		@colors = Sketchup::Color.names
		puts "@count : #{@count}"
	end
	
	def activate
		puts 'Your tool has been activated.'
	end
	
	def deactivate(view)
		puts "deactivate"
	end
	
	def onCancel(flag, view)
		puts "onCancel"
		Sketchup.active_model.select_tool(nil)
	end
	
	def reduce_count
		@count-=1
	end
	
	def clicked_face view, x, y
		ph = view.pick_helper
		ph.do_pick x, y
		face = ph.best_picked
		return nil unless face.is_a?(Sketchup::Face)
		return face
	end
	
	def get_space_inputs face
		edges 		= face.edges
		door_flag 	= false
		window_flag	= false

		edges.each { |edge|
			layer_name	= edge.layer.name
			if layer_name == 'Door'
				door_flag 	= true
			elsif layer_name == 'Window'
				window_flag = true
			end
		}
		
		prompts 	= ["Space Type","Name","Wall height"]
		defaults 	= ["Kitchen"]
		defaults << "Room#"+@count.to_s
		defaults << 2000
		list 		= ["Kitchen|Wash Room|Bed Room|Living Room|Balcony"]
		
		if door_flag
			prompts << "Door height" 
			defaults << 1200
		end
		if window_flag
			prompts	<< "Window height" 
			prompts	<< "Window offset(from floor)"
			defaults << 600
			defaults << 600
		end
		
		input 		= UI.inputbox(prompts, defaults, list, "Space Type.")
		if input
			name 	= input[1].start_with?('Room#')
			puts "name : #{name} : #{input[1]}"
			@count+=1 if name
			return input
		end
		return false
	end
	
	def onLButtonDown(flags,x,y,view)
		#@count+=1
		wall_color = @colors.shuffle.last
		puts "wall_color : #{wall_color}"
		@colors.delete wall_color
		
		input_point = view.inputpoint x, y
		face 		= clicked_face view, x, y
		puts "onLButtonDown : #{@count} : #{face}"
		if face
			inputs 		= get_space_inputs face 
			if inputs
				Sketchup.active_model.selection.clear
				Sketchup.active_model.selection.add face
				MultiRoomLib::create_spacetype face, inputs
			end
		end	
	end
	
end

