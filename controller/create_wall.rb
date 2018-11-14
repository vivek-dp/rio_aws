require_relative 'tt_bounds.rb'

module Decor_Standards
	def self.decor_create_wall
		dialog = UI::HtmlDialog.new({:dialog_title=>"#{TITLE}", :preferences_key=>"com.sample.plugin", :scrollable=>true, :resizable=>true, :width=>600, :height=>420, :style=>UI::HtmlDialog::STYLE_DIALOG})
		html_path = File.join(WEBDIALOG_PATH, 'create_wall.html')
		dialog.set_file(html_path)
		dialog.set_position(0, 150)
		dialog.show

		dialog.add_action_callback("clickcancel") { |action_context, param1|
		  dialog.close
		}

		dialog.add_action_callback("submitval"){|ac, params|
			#puts JSON.parse(params)
			#puts "------------------------------"
			inp_h =	JSON.parse(params)
			return nil if inp_h.empty?
			#create walls
			puts inp_h
			mod 	= Sketchup.active_model
			zvector	= Geom::Vector3d.new(0, 0, 1)
			
			wwidth 	= inp_h['wall1'].to_f.mm.to_inch
			wlength = inp_h['wall2'].to_f.mm.to_inch
			wheight = inp_h['wheight'].to_f.mm.to_inch
			thick	= inp_h['wthick'].to_f.mm.to_inch
			active_layer = Sketchup.active_model.active_layer.name
			pts = [Geom::Point3d.new(0,0,0), Geom::Point3d.new(wwidth,0,0), Geom::Point3d.new(wwidth,wlength,0), Geom::Point3d.new(0,wlength,0)]
			Sketchup.active_model.active_layer='DP_Floor'
			floor_face = Sketchup.active_model.entities.add_face(pts)
			
			floor_face.edges.each{ |edge|
				verts 	= edge.vertices
				pt1   	= verts[0]
				pt2   	= verts[1]
				pt3		= pt2.position.offset(zvector, wheight)
				pt4		= pt1.position.offset(zvector, wheight)
				puts pt1, pt2, pt3, pt4
				face 	= mod.entities.add_face(pt1, pt2, pt3, pt4)
				fcolor    			= Sketchup::Color.new "Green"
				#fcolor.alpha 		= 0.5

				face.material 		= fcolor
				face.back_material 	= fcolor
				face.material.alpha	= 0.5
			}

			if inp_h["door"] && !inp_h["door"].empty?
				door_h 			= inp_h["door"]
				door_view 		= door_h['door_view'].to_sym
				door_position	= door_h['door_position'].to_f.mm.to_inch
				door_height		= door_h['door_height'].to_f.mm.to_inch
				door_width		= door_h['door_length'].to_f.mm.to_inch
				

				case door_view
				when :front	
					vector 		= Geom::Vector3d.new(-1, 0, 0)
					start_point = TT::Bounds.point(floor_face.bounds, 1) 
					
					door_start_point 	= start_point.offset(vector, door_position)
					door_end_point		= start_point.offset(vector, door_position+door_width)
					door_left_point		= door_start_point.offset(zvector, door_height)
					door_right_point	= door_end_point.offset(zvector, door_height)
					
					door = mod.entities.add_face(door_start_point, door_end_point, door_right_point, door_left_point)
					Sketchup.active_model.entities.erase_entities door
					
				when :back
					vector = Geom::Vector3d.new(1, 0, 0)
					start_point = TT::Bounds.point(floor_face.bounds, 2)
					
					door_start_point 	= start_point.offset(vector, door_position)
					door_end_point		= start_point.offset(vector, door_position+door_width)
					door_left_point		= door_start_point.offset(zvector, door_height)
					door_right_point	= door_end_point.offset(zvector, door_height)
					
					door = mod.entities.add_face(door_start_point, door_end_point, door_right_point, door_left_point)
					Sketchup.active_model.entities.erase_entities door
				when :left
					vector = Geom::Vector3d.new(0, 1, 0)
					start_point = TT::Bounds.point(floor_face.bounds, 0)
					
					door_start_point 	= start_point.offset(vector, door_position)
					door_end_point		= start_point.offset(vector, door_position+door_width)
					door_left_point		= door_start_point.offset(zvector, door_height)
					door_right_point	= door_end_point.offset(zvector, door_height)
					
					door = mod.entities.add_face(door_start_point, door_end_point, door_right_point, door_left_point)
					Sketchup.active_model.entities.erase_entities door
				when :right
					vector = Geom::Vector3d.new(0, -1, 0)
					start_point = TT::Bounds.point(floor_face.bounds, 3)
					
					door_start_point 	= start_point.offset(vector, door_position)
					door_end_point		= start_point.offset(vector, door_position+door_width)
					door_left_point		= door_start_point.offset(zvector, door_height)
					door_right_point	= door_end_point.offset(zvector, door_height)
					
					door = mod.entities.add_face(door_start_point, door_end_point, door_right_point, door_left_point)
					Sketchup.active_model.entities.erase_entities door
				end
			end
			
			faces =[]
			floor_face.edges.each{|ed| faces<<ed.faces}
			mod.selection.clear
			faces.flatten.uniq.each{|f| Sketchup.active_model.selection.add f}
			mod.entities.add_group(Sketchup.active_model.selection)
		}
		
	end
end