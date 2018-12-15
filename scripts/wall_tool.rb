class MyTool
	include Singleton	
	
	def initialize
		@count = 1
		puts "@count : #{@count}"
	end
	
	def activate
		puts 'Your tool has been activated.'
	end
	
	def set_start_point ip
		@start_point = ip
	end
	
	def get_start_point
		@start_point
	end
	
	def onKeyUp(key, repeat, flags, view)
		puts "onKeyUp: key = #{key}"
		puts "      repeat = #{repeat}"
		puts "       flags = #{flags}"
		puts "        view = #{view}"
		if(key == VK_SHIFT)
			@shift_flag = false
		end
	end
	
	def onKeyDown(key, repeat, flags, view)
		puts "On Key Down"
		if(key == VK_SHIFT)
			@shift_flag = true
		end
	end
	
	def deactivate(view)
		puts "deactivate"
	end
	
	def onCancel(flag, view)
		puts "onCancel"
		Sketchup.active_model.select_tool(nil)
	end
	
	def onLButtonDown(flags,x,y,view)
		puts "onLButtonDown"
		puts "onLButtonDown: flags = #{flags}"
		puts "                 x = #{x}"
		puts "                 y = #{y}"
		puts "              view = #{view.center}"
		ip = view.inputpoint x, y
		puts "point : #{ip.position} : #{@count}"
		@count+=1
	end
	
	def onLButtonUp(flags, x, y, view)
		puts "onLButtonUp: flags = #{flags}"
		puts "                 x = #{x}"
		puts "                 y = #{y}"
		puts "              view = #{view}"

		thickness 	= 200.mm
		height 		= 2000.mm
		start_pt 	= get_start_point
		
		xvector		= Geom::Vector3d.new(1,0,0)
		zvector 	= Geom::Vector3d.new 0,0,1
		ip 			= view.inputpoint x, y
		puts "point : #{ip.position}"
		
		if start_pt.nil?
			set_start_point ip.position
			@direction_set 	= false
			@line_added		= false
			@reverse_vector = true
		else
			pt1 		= start_pt
			pt2 		= ip.position
			vector 		= pt1.vector_to pt2
			perp_vector	= vector * zvector
			perp_vector	= perp_vector.reverse if @reverse_vector
			
			pt3			= pt2.offset(perp_vector, thickness)
			pt4			= pt1.offset(perp_vector, thickness)
			
			#@direction_set = true if @line_added
			puts pt1, pt2, pt3, pt4, perp_vector
			begin
				if @direction_set #rest of points
					wall_face	= Sketchup.active_model.entities.add_face(pt1, pt2, pt3, pt4)
					wall_face.pushpull -height 
				else
					if @line_added #Find the vector #3rd point click
						@reverse_vector = false if @perp_vector == perp_vector
						@direction_set	= true
						wall_face 		= Sketchup.active_model.entities.add_face(@face_pts[0],@face_pts[1],@face_pts[2],@face_pts[3])
						wall_face.pushpull -height
						
						wall_face		= Sketchup.active_model.entities.add_face(pt1, pt2, pt3, pt4)
						wall_face.pushpull -height
					else #Second point click
						@face_pts		= [pt1, pt2, pt3, pt4]
						@line_added 	= Sketchup.active_model.entities.add_line pt1, pt2
						@perp_vector 	= perp_vector
					end
				end
				
			rescue ArgumentError
				puts "points are not planar"
			end
			
			set_start_point ip.position
		end
		pt = get_start_point
		puts pt
	end
	
	def onLButtonDown_undo(flags, x, y, view)
		puts "onLButtonDown_undo"
	end
	
	def onLButtonDown_draw(flags, x, y, view)
		puts "onLButtonDown_draw"
	end
end

my_tool 	= MyTool.instance
Sketchup.active_model.select_tool(my_tool)