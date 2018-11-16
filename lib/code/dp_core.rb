#-----------------------------------------------
#
#Decorpot Sketchup Core library
#
#-----------------------------------------------


module DP
	def self.mod
		Sketchup.active_model
	end
	
	def self.ents
		Sketchup.active_model.entities
	end
	
	def self.comps
		Sketchup.active_model.entities.grep(Sketchup::ComponentInstance)
	end
	
	def self.sel
		Sketchup.active_model.selection
	end
	
	def self.fsel
		Sketchup.active_model.selection[0]
	end
	
	def self.fpid
		compn = Sketchup.active_model.selection[0]
		return compn.persistent_id if compn.is_a?(Sketchup::ComponentInstance)
		return nil
	end
	
	def self.current_file_path
		Sketchup.active_model.path
	end
	
	def self.open_folder folder_path
		UI.openURL("file:///#{folder_path}")
	end
	
	def self.get_plugin_folder
		Sketchup.find_support_file("Plugins")
	end
	
	def self.simple_encrypt text, shift=7
		alphabet = [*('a'..'z'), *('A'..'Z')].join
		cipher = alphabet.chars.rotate(shift).join
		return text.tr(alphabet, cipher)
	end
	
	def self.simple_decrypt text, shift=7
		alphabet = [*('a'..'z'), *('A'..'Z')].join
		cipher = alphabet.chars.rotate(shift).join
		return text.tr(cipher, alphabet)
	end
	
	def self.backup_current_file
		backup_folder 	= get_plugin_folder
		backup_file 	= current_file_path
		file_name		= File.basename(backup_file, '.skp')
		
		
		FileUtils.cp(current_file_path, backup_folder)
	end
	
	def self.pid entity
		return entity.persistent_id if entity.is_a?(Sketchup::ComponentInstance)
		return nil
	end
	
	def self.lower_bounds e; 
		return e.bounds.corner(0), e.bounds.corner(1), e.bounds.corner(3), e.bounds.corner(2);
	end
	
	def self.get_comp_pid id;
		Sketchup.active_model.entities.each{|x| return x if x.persistent_id == id};
		return nil;
	end
    
    def self.get_state
        @state
    end
    
    def self.comp_clicked_id
        @comp_id
    end
    
    def self.set_state status
        @state=status
    end
	
	#Input 	:	Face, offset distance
	#return :	Array of offset points
	def self.face_off_pts(face, dist)
		pi = Math::PI
		
		return nil unless face.is_a?(Sketchup::Face)
		if (not ((dist.class==Fixnum || dist.class==Float || dist.class==Length) && dist!=0))
			return nil
		end
		
		verts=face.outer_loop.vertices
		pts = []
		
		# CREATE ARRAY pts OF OFFSET POINTS FROM FACE
		
		0.upto(verts.length-1) do |a|
			vec1 = (verts[a].position-verts[a-(verts.length-1)].position).normalize
			vec2 = (verts[a].position-verts[a-1].position).normalize
			vec3 = (vec1+vec2).normalize
			if vec3.valid?
				ang = vec1.angle_between(vec2)/2
				ang = pi/2 if vec1.parallel?(vec2)
				vec3.length = dist/Math::sin(ang)
				t = Geom::Transformation.new(vec3)
				if pts.length > 0
					vec4 = pts.last.vector_to(verts[a].position.transform(t))
					if vec4.valid?
						unless (vec2.parallel?(vec4))
							t = Geom::Transformation.new(vec3.reverse)
						end
					end
				end
				
				pts.push(verts[a].position.transform(t))
			end
		end
		duplicates = []
		pts.each_index do |a|
			pts.each_index do |b|
				next if b==a
				duplicates<<b if pts[a]===pts[b]
			end
			break if a==pts.length-1
		end
		duplicates.reverse.each{|a| pts.delete(pts[a])}
		return pts
	end
	
	def self.get_view_face view
		ent	  = Sketchup.active_model.entities
		l,x,y,z = 1000, 500, 500, 500
		
		case view
		when "top"
			pts = [[-l,-l,z], [l,-l,z], [l,l,z], [-l,l,z]]
			hit_face = ent.add_face pts
		when "right"
			pts = [[x,-l,-l], [x,l,-l], [x,l,l], [x,-l,l]]
			hit_face = ent.add_face pts
		when "left"
			pts = [[-x,-l,-l], [-x,l,-l], [-x,l,l], [-x,-l,l]]
			hit_face = ent.add_face pts
		when "front"
			pts = [[-l,-y,-l], [l,-y,-l], [l,-y,l], [-l,-y,l]]
			hit_face = ent.add_face pts
		when "back"
			pts = [[-l,y,-l], [l,y,-l], [l,y,l], [-l,y,l]]
			hit_face = ent.add_face pts
		end
		return hit_face
	end
	
	def self.get_points comp, view
		hit_pts = []
		mod	  = Sketchup.active_model
		ent	  = mod.entities
		
		bounds = comp.bounds
		case view
		when "top"
			indexes = [4,5,7,6,10,11,13,15,24]
			vector 	= Geom::Vector3d.new(0,0,1)
		when "right"
			indexes = [1,3,7,5,14,15,17,19,21]
			vector 	= Geom::Vector3d.new(1,0,0)
		when "left"
			indexes = [0,2,6,4,12,13,16,18,20]
			vector 	= Geom::Vector3d.new(-1,0,0)
		when "front"
			indexes = [0,1,5,4,8,10,16,17,22]
			vector 	= Geom::Vector3d.new(0,-1,0)
		when "back"
			indexes = [2,3,7,6,9,11,18,19,23]
			vector 	= Geom::Vector3d.new(0,1,0)
		end
		indexes.each { |i|
			hit_pts << TT::Bounds.point(bounds, i)
		}
        temp_face = ent.add_face(hit_pts[0],hit_pts[1],hit_pts[2],hit_pts[3])
		hit_pts = face_off_pts temp_face, -2
		#temp_face = ent.add_face(hit_pts[0],hit_pts[1],hit_pts[2],hit_pts[3])
		del_comps = [temp_face, temp_face.edges]
		del_comps.flatten.each{|x| ent.erase_entities x unless x.deleted?}
		
		return hit_pts, vector
	end
	
	#Get visible decorpot components from the view
	# floor = Sketchup.active_model.entities.select{|c| c.layer.name == 'DP_Floor'}[0]
	# pts = face_off_pts floor, 50
	# (pts.length).times{|i| pts[i].z = 200}
	# hit_face = Sketchup.active_model.entities.add_face(pts)
	def self.get_visible_comps view='top'
		mod	  = Sketchup.active_model
		ent	  = mod.entities
				
		comps = ent.grep(Sketchup::ComponentInstance)
        comps = comps.select{|x| x.hidden? == false}
		
		#comps = Sketchup.active_model.selection
		['DP_Floor', 'DP_Wall'].each{|layer| Sketchup.active_model.layers[layer].visible=false}
		
		hit_face = get_view_face view
		visible_comps = []
		comps.each{|comp|
			pts, nor_vector = get_points comp, view
			#ent.add_face(pts)
			pts.each { |pt|
				hit_item = mod.raytest(pt, nor_vector)
				if hit_item && hit_item[1][0] == hit_face
					visible_comps << comp
					mod.selection.add comp
					break
				end
			}
		}
		del_comps = [hit_face, hit_face.edges]
		del_comps.flatten.each{|x| 
            unless x.deleted?
                ent.erase_entities x 
            end
        }
		['DP_Floor', 'DP_Wall'].each{|layer| Sketchup.active_model.layers[layer].visible=true}
		return visible_comps
	end
	
	#Get the intersection of two components
	def self.get_xn_pts c1, c2
		xn = c1.bounds.intersect c2.bounds
		corners = []
		(0..7).each{|x| corners<<xn.corner(x)}
		arr = corners.inject([]){ |array, point| array.any?{ |p| p == point } ? array : array << point }
		return arr
	end

	
	def self.check_adj c1, c2
		return 0 unless (c1.bounds.intersect c2.bounds).valid?
		corners=[];
		intx=c1.bounds.intersect c2.bounds;
		(0..7).each{|x| corners<<intx.corner(x)}
		#puts corners
		return corners.map{|x| x.to_s}.uniq.length
	end
	
	def self.get_schema comp_arr
		comps = {}
		comp_arr.each {|comp| 
			next if comp.definition.name == 'region'
			pid = DP::pid comp;
			comps[pid] = {:type=>false, :adj=>[] , :row_elem=>false}
		}
		comps
	end
    
    def self.del_face face
        face.edges.each{|x| Sketchup.active_model.entities.erase_entities x unless x.deleted?}
    end
	
	#Parse the components and get the hash.
	def self.parse_components comp_arr
		comp_list = get_schema comp_arr
		corners = []
		comp_list.keys.each { |id|
			#lb_curr = lower_bounds id 
			adj_comps = []
			outer_comp = DP.get_comp_pid id
			#DP.comps.each{|inner_comp| # Just delete this line.........Not needed
            comp_arr.each{|inner_comp|    
				next if inner_comp.definition.name == 'region'
				next if outer_comp == inner_comp 
				alen = check_adj outer_comp, inner_comp
				type = :single
				if alen > 2
					next if inner_comp.definition.name == 'region'
					adj_comps << inner_comp.persistent_id
					if adj_comps.length > 1
                        adj = DP.get_comp_pid adj_comps[0]
                        #vec1    = outer_comp.bounds.center.vector_to adj.bounds.center
                        min_vec1    = outer_comp.bounds.min.vector_to adj.bounds.min
                        #max_vec1    = outer_comp.bounds.max.vector_to adj.bounds.max
                        type    = :double
                        #adj_face    = Sketchup.active_model.entities.add_face(xn_pts) 
                        (1..adj_comps.length-1).each{ |i|
                            adj_c   = DP.get_comp_pid adj_comps[i]
                            #vec2    = outer_comp.bounds.center.vector_to adj_c.bounds.center
                            min_vec2    = outer_comp.bounds.min.vector_to adj_c.bounds.min
                            #max_vec2    = outer_comp.bounds.max.vector_to adj_c.bounds.max
                            type = :corner if min_vec1.perpendicular?(min_vec2)
                            #type = :corner if max_vec1.perpendicular?(max_vec2)
                        }
                    end
					comp_list[id][:type] = type
					#corners << inner_comp.persistent_id) if adj_comps.length > 1
				end
			}

			comp_list[id][:adj] = adj_comps
		}
		return comp_list
	end
	
	#Create layers for multi components
	def self.create_layers
		layers = ['DP_Floor', 'DP_Dimension_layer', 'DP_Comp_layer', 'DP_lamination', 'DP_Wall']
		layers.each { |name|
			Sketchup.active_model.layers.add(name) if Sketchup.active_model.layers[name].nil?
		}
	end
	
	def self.corners b
		arr=[];(0..7).each{|i| arr<<b.bounds.corner(i)}
		return arr
	end
	
	#------------------------------------------------------------------------------------
	#This test checks if the objects are in the room based on the raytest with the floor.
	#------------------------------------------------------------------------------------
	def self.visibility_raytest_floor
		comps = Sketchup.active_model.entities.grep(Sketchup::ComponentInstance)
		floor_face = fsel

		puts "floor_face not selected " if floor_face.nil?
		Sketchup.active_model.selection.clear
		if !floor_face.nil?
			zvector = Geom::Vector3d.new(0, 0, -1)
			visible_ents = []

			comps.each{ |comp|
				visible_ents = Sketchup.active_model.entities.select{|x| x.hidden? == false} 
				visible_ents.each{|ent| 
					next if ent == comp 
					next if ent == floor_face
					ent.hidden=true 
				}
				(0..3).each{|i| 
					pt 			= comp.bounds.corner(i);
					hit_item	= Sketchup.active_model.raytest(pt, zvector);
					#puts hit_item
					if hit_item && hit_item[1][0] == floor_face
						#puts "floor_face"
					else
						puts "Exterior : #{pt}"
						Sketchup.active_model.selection.add(comp)
						visible_ents.each{|x| x.hidden=false}
						#return false
					end
				}
				visible_ents.each{|x| x.hidden=false}
			}
		end
		#return true
	end

	#------------------------------------------------------------------------------------
	#This test checks for the bounds of every object to be within the bounds of the room.
	#------------------------------------------------------------------------------------
	def self.check_room_bounds
		Sketchup.active_model.selection.clear
		comps 		= Sketchup.active_model.entities.grep(Sketchup::ComponentInstance) #change to rio comp test
		get_room = comps.select{|x| x.definition.name=='room_bounds'}
		if get_room.empty?
			puts "room_bounds object not found"
		else
			room_bounds = get_room[0]
			comps = comps - [room_bounds]
			comps.each{|comp|
				if room_bounds.bounds.contains?(comp.bounds)
					puts "true"
				else
					puts "false"
					Sketchup.active_model.selection.add comp
				end
			}
		end
	end
    
    def self.create_wall inp_h
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
            
            position = get_position edge, floor_face
            face.set_attribute :rio_atts, 'position', position if position

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
        floor_verts = []
        (0..3).each{|i| floor_verts << floor_face.bounds.corner(i)}
        
        floor_face.edges.each{|ed| 
            faces<<ed.faces
        }
        mod.selection.clear
        
        #----------makes all the faces to single component.....
        #faces.flatten.uniq.each{|f| Sketchup.active_model.selection.add f}
        #mod.entities.add_group(Sketchup.active_model.selection)
        
        faces.flatten.uniq.each { |face|  
            position = face.get_attribute :rio_atts, 'position'
            gp = mod.entities.add_group(face)
            gp.set_attribute :rio_atts, 'position', position if position
        }
    end
    
    def self.get_position edge, face
        return nil if edge.nil?
        return nil if face.nil?

        floor_verts = []
        (0..3).each{|i| floor_verts << face.bounds.corner(i).to_s}

        edge_pts = []
        edge.vertices.each{|ver| 
            edge_pts << ver.position.to_s
        }
        if ([floor_verts[0], floor_verts[1]] & edge_pts).length == 2
            return "front"
        elsif ([floor_verts[3], floor_verts[1]] & edge_pts).length == 2
            return "right"
        elsif ([floor_verts[2], floor_verts[3]] & edge_pts).length == 2
            return "back"
        elsif ([floor_verts[0], floor_verts[2]] & edge_pts).length == 2
            return "left"
        end
        return nil
    end
	
	def self.test_mod_fun
		puts "test_mod_fun"
	end
	
	def self.test_fun
		test_mod_fun
		puts "test fun"
	end
end