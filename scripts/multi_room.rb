prompts = ["Space Type","Name","Wall height", "Thickness"]
defaults = ["Kitchen"]
list = ["Kitchen|Wash Room|Bed Room|Living Room|Balcony"]
#input = UI.inputbox(prompts, defaults, list, "Space Type.")

$count = 1



layer_name = 'Wall'
model		= Sketchup.active_model
ents 		= model.entities
puts "start #{ents.length}"
layer_ents 	= ents.select{|ent| ent.layer.name == layer_name}

layer_ents.each{|edge|
	edge.find_faces
}

module MultiRoomLib
	def self.add_text_to_face face, text
		temp_group 			= Sketchup.active_model.entities.add_group
		temp_entity_list 	= temp_group.entities
		text_scale 			= face.bounds.height/50
		temp_entity_list.add_3d_text(text,  TextAlignCenter, "Arial", false, false, text_scale)
		text_component 		= temp_group.to_component
		text_definition 	= text_component.definition
		text_component.erase!

		text_inst 			= Sketchup.active_model.entities.add_instance text_definition, Geom::Transformation.new(face.bounds.center)
		text_inst
	end

	def self.create_spacetype space_inputs, create_face_flag=false
		Sketchup.active_model.start_operation '2d_to_3d'
		if space_inputs.is_a?(Array)
			space_type 		= space_inputs[0]
			space_name		= space_inputs[1]
			wall_height		= space_inputs[2].to_i.mm
			door_height		= space_inputs[3].to_i.mm
			window_height	= space_inputs[4].to_i.mm
			window_offset	= space_inputs[5].to_i.mm
		else
			space_type 		= space_inputs['space_type']
			space_name		= space_inputs['space_name']
			wall_height		= space_inputs['wall_height'].to_i.mm
			wall_thickness  = space_inputs['wall_thickness'].to_i.mm
			door_height		= space_inputs['door_height'].to_i.mm
			window_height	= space_inputs['window_height'].to_i.mm
			window_offset	= space_inputs['window_offset'].to_i.mm
		end
	
		
		zvector 		= Geom::Vector3d.new(0, 0, 1)
		model			= Sketchup.active_model
		ents			= model.entities
		seln 			= model.selection
		layers			= model.layers

		if seln.length == 0
			Sketchup.active_model.abort_operation
			puts "No Component selected" 
			return false
		end
		space_face 		= seln[0]
		space_face.set_attribute :rio_atts, 'floor_name', space_name
		floor_layer		= Sketchup.active_model.layers.add 'DP_Floor_'+space_name
		wall_layer		= Sketchup.active_model.layers.add 'DP_Wall_'+space_name
		space_face.layer= floor_layer
		text_inst 		= add_text_to_face space_face, space_name
		
		space_edges		= space_face.outer_loop.edges 
		#Add walls
		wall_faces_group	= Sketchup.active_model.entities.add_group
		temp_entity_list 	= wall_faces_group.entities

		puts "#{space_edges} : #{space_face}"
		wall_faces 	= []
		space_edges.each{ |edge|
			if edge.layer.name == 'Wall' 
				vertices	= edge.vertices
				pt1 		= vertices[0].position
				pt2			= vertices[1].position

				pt3			= pt2.offset(zvector, wall_height)
				pt4			= pt1.offset(zvector, wall_height)
				
				wall_face 	= ents.add_face pt1, pt2, pt3, pt4
				wall_face.layer = 'DP_Wall'
				wall_faces << wall_face
			end
		}

		#----------------------------Add door top face-----------------------------
		if door_height
			space_edges.each {|edge|
				if edge.layer.name == 'Door' 
					vertices	= edge.vertices
					pt1 		= vertices[0].position.offset(zvector, door_height)
					pt2			= vertices[1].position.offset(zvector, door_height)

					pt3			= vertices[1].position.offset(zvector, wall_height)
					pt4			= vertices[0].position.offset(zvector, wall_height)

					wall_face 	= ents.add_face pt1, pt2, pt3, pt4
					wall_face.layer = 'DP_Wall'
					wall_faces << wall_face
				end
				
			}
		else
			#Create walls for windows and doors
			if edge.layer.name == 'Door' 
				vertices	= edge.vertices
				pt1 		= vertices[0].position
				pt2			= vertices[1].position

				pt3			= pt2.offset(zvector, wall_height)
				pt4			= pt1.offset(zvector, wall_height)
				
				wall_face 	= ents.add_face pt1, pt2, pt3, pt4
				wall_face.layer = 'DP_Wall'
				wall_faces << wall_face
			end
		end

		#----------------------------Add door top face-----------------------------
		if window_height
			space_edges.each {|edge|
				if edge.layer.name == 'Window' 
					vertices	= edge.vertices
					pt1 		= vertices[0].position
					pt2			= vertices[1].position

					pt3			= pt2.offset(zvector, window_offset)
					pt4			= pt1.offset(zvector, window_offset)

					puts "Window pts : #{pt1} : #{pt2} : #{pt3} : #{pt4} " 
					wall_face 	= ents.add_face pt1, pt2, pt3, pt4
					wall_face.layer = 'DP_Wall'
					wall_faces << wall_face

					#Extra face for window only when the combined height is less than Wall height
					if (window_offset+window_height < wall_height)
						pt1 		= vertices[0].position.offset(zvector, window_offset+window_height)
						pt2			= vertices[1].position.offset(zvector, window_offset+window_height)

						pt3			= vertices[1].position.offset(zvector, wall_height)
						pt4			= vertices[0].position.offset(zvector, wall_height)

						wall_face 	= ents.add_face pt1, pt2, pt3, pt4
						wall_face.layer = 'DP_Wall'
						wall_faces << wall_face
					end
				end
				
			}
		else
			#Create walls for windows and doors
			if edge.layer.name == 'Door' 
				vertices	= edge.vertices
				pt1 		= vertices[0].position
				pt2			= vertices[1].position

				pt3			= pt2.offset(zvector, wall_height)
				pt4			= pt1.offset(zvector, wall_height)
				
				wall_face 	= ents.add_face pt1, pt2, pt3, pt4
				wall_face.layer = 'DP_Wall'
				wall_faces << wall_face
			end
		end



		#pre processingo
		prev_active_layer 	= Sketchup.active_model.active_layer.name
		model.active_layer 	= floor_layer
		floor_group 		= model.active_entities.add_group(space_face, text_inst)

		model.active_layer 	= wall_layer
		color_array 		= Sketchup::Color.names
		wall_color			= color_array[rand(140)]
		wall_faces.each{|wall|
			wall.material 		= wall_color
			wall.back_material 	= wall_color
		}
		wall_group 			= model.active_entities.add_group(wall_faces)

		model.active_layer 	= prev_active_layer
	end
end

class MyTool
	include Singleton	
	
	def initialize
		@count = 1
		puts "@count : #{@count}"
	end
	
	def activate
		puts 'Your tool has been activated.'
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
	
	def get_space_inputs
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
		list 		= ["Kitchen|Wash Room|Bed Room|Living Room|Balcony", "gfdjgjds"]
		
		prompts << "Door height" if door_flag
		prompts	<< "Window height, Window offset(from floor)" if window_flag
		defaults << "Room#"+@count
		
		input 		= UI.inputbox(prompts, defaults, list, "Space Type.")
		if input
			name 	= input[1].starts_with?('Room#')
			@count+=1 if name
		end
	end
	
	def onLButtonDown(flags,x,y,view)
		puts "onLButtonDown : #{@count}"
		input_point = view.inputpoint x, y
		face 		= clicked_face view, x, y
		get_space_inputs face if face
	end
	
end

space_inputs = {'space_type'=>'kitchen',
				'space_name'=>'kitchen#1',
				'wall_height'=>'2000',
				'wall_thickness'=>'200',
				'door_height'=>'1400',
				'window_height'=>'600',
				'window_offset'=>'700'
			}

#MultiRoomLib::create_spacetype space_inputs,  ct

