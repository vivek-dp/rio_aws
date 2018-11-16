#-------------------------------------------------------------------------------    
# 
# File containing code for working drawing
# #load 'E:\git\poc_demo\dp_library\working_drawing.rb'
# #DecorPot.new.working_drawing
#-------------------------------------------------------------------------------    

require_relative '../lib/code/dp_core.rb'
require "prawn"

module WorkingDrawing
    include DP
    
    def self.initialize
        DP::create_layers
        @add_menu = false
		add_lamination_menu
    end
    
    def self.get_outline_pts comp, view, offset
        return nil unless comp.valid?
        bounds = comp.bounds
        hit_pts = []
		case view
		when "top"
			indexes = [4,5,7,6]
			vector 	= Geom::Vector3d.new(0,0,1)
            offset  = offset - bounds.max.z 
		when "right"
			indexes = [1,3,7,5]
			vector 	= Geom::Vector3d.new(1,0,0)
            offset  = offset - bounds.max.x 
		when "left"
			indexes = [0,2,6,4]
			vector 	= Geom::Vector3d.new(-1,0,0)
            offset  = offset + bounds.min.x
		when "front"
			indexes = [0,1,5,4]
			vector 	= Geom::Vector3d.new(0,-1,0)
            offset  = offset + bounds.min.y
		when "back"
			indexes = [2,3,7,6]
			vector 	= Geom::Vector3d.new(0,1,0)
            offset  = offset - bounds.max.y
		end
		indexes.each { |i|
			hit_pts << TT::Bounds.point(bounds, i)
		}
        face_pts = []
        hit_pts.each{|pt| 
            face_pts << pt.offset(vector, offset)
        }
        face_pts
    end
    
    def self.set_lamination comp, value
		return nil unless comp.valid?
        dict_name = 'lamination_code'
        key = 'lamination'
        comp.set_attribute(dict_name, key, value)
    end

    def self.get_lamination comp
		return nil unless comp.valid?
        dict_name = 'lamination_code'
        key = 'lamination'
        lam_code = comp.get_attribute(dict_name, key)
        return lam_code
    end
    
	def self.add_lamination_menu
        puts "add_lamination_menu"
        if (!@add_menu)
            UI.add_context_menu_handler do |popup|
                sel = Sketchup.active_model.selection[0]
                if sel.is_a?(Sketchup::ComponentInstance)
                    lam_code = get_lamination sel
                    lam_code = "" unless lam_code
                    popup.add_item('Lamination Code') {
                        prompts = ["Enter lamination code"]
                        defaults = [lam_code]
                        input = UI.inputbox(prompts, defaults, "Lamination code.")
                        set_lamination sel, input[0] if input
                    }
                    popup.add_item('Add Rio component') {
                        prompts = ["Placement"]
                        defaults = ["Left"]
                        list = ["Left|Right|Top"]
                        input = UI.inputbox(prompts, defaults, list, "Lamination code.")

                        DP::set_state 'comp-clicked:'+input[0] if input
                        RioAWSComponent::decor_import_comp
                    }
                    posn = sel.get_attribute :rio_atts, "position"
                    if posn
                        popup.add_item('Add Rio component') {

                            posn = sel.get_attribute :rio_atts, "position"
                            DP::set_state 'wall-clicked:'+posn
                        }
                    end
                end
            end  
            @add_menu=true
        end
	end
    
	def self.add_dimension_pts pt1, pt2, vector
		dim_l 	= Sketchup.active_model.entities.add_dimension_linear(pt1, pt2, vector)
		dim_l.material.color = 'red'
		dim_l
	end
	
    def self.add_comp_dimension comp, view='top', show_dimension=true
        return nil unless comp.valid?
        bounds = comp.bounds
        
        layer_name = 'DP_dimension_'+view
        dim_off = 4*rand
        case view
        when 'top'   
            rotz = comp.transformation.rotz
            case rotz
            when 0
                st_index, end_index, vector, lvector = 2,3, Geom::Vector3d.new(0,dim_off,0), Geom::Vector3d.new(0,2*dim_off,0)
                pt1, pt2 = TT::Bounds.point(comp.bounds, st_index), TT::Bounds.point(comp.bounds, end_index)
                pt1.z=500;pt2.z=500
                mid_point = Geom.linear_combination( 0.5, pt1, 0.5, pt2 )
                dim_l = add_dimension_pts(pt1, pt2, vector)
                dim_l.layer = layer_name
                if show_dimension
                    st_index, end_index, vector = 0,2, Geom::Vector3d.new(-dim_off,0,0)
                    pt1, pt2 = TT::Bounds.point(comp.bounds, st_index), TT::Bounds.point(comp.bounds, end_index)
                    pt1.z=500;pt2.z=500
                    dim_l = add_dimension_pts(pt1, pt2, vector)
                    dim_l.layer = layer_name
                end
            when 90
                st_index, end_index, vector, lvector = 0,2, Geom::Vector3d.new(-dim_off,0,0), Geom::Vector3d.new(0,-dim_off*2,0)
                pt1, pt2 = TT::Bounds.point(comp.bounds, st_index), TT::Bounds.point(comp.bounds, end_index)
                pt1.z=500;pt2.z=500
                mid_point = Geom.linear_combination( 0.5, pt1, 0.5, pt2 )
                dim_l = add_dimension_pts(pt1, pt2, vector)
                dim_l.layer = layer_name
                if show_dimension
                    st_index, end_index, vector = 0,1, Geom::Vector3d.new(0,dim_off,0)
                    pt1, pt2 = TT::Bounds.point(comp.bounds, st_index), TT::Bounds.point(comp.bounds, end_index)
                    pt1.z=500;pt2.z=500
                    dim_l = add_dimension_pts(pt1, pt2, vector)
                    dim_l.layer = layer_name
                end
            when 180, -180
                st_index, end_index, vector, lvector = 0,1, Geom::Vector3d.new(0,-dim_off,0), Geom::Vector3d.new(0,-dim_off*2,0)
                pt1, pt2 = TT::Bounds.point(comp.bounds, st_index), TT::Bounds.point(comp.bounds, end_index)
                pt1.z=500;pt2.z=500
                mid_point = Geom.linear_combination( 0.5, pt1, 0.5, pt2 )
                dim_l = add_dimension_pts(pt1, pt2, vector)
                dim_l.layer = layer_name
                if show_dimension
                    st_index, end_index, vector = 0,2, Geom::Vector3d.new(-dim_off,0,0)
                    pt1, pt2 = TT::Bounds.point(comp.bounds, st_index), TT::Bounds.point(comp.bounds, end_index)
                    pt1.z=500;pt2.z=500
                    dim_l = add_dimension_pts(pt1, pt2, vector)	
                    dim_l.layer = layer_name
                end
            when -90
                st_index, end_index, vector, lvector = 1,3, Geom::Vector3d.new(dim_off,0,0), Geom::Vector3d.new(2*dim_off,0,0)
                pt1, pt2 = TT::Bounds.point(comp.bounds, st_index), TT::Bounds.point(comp.bounds, end_index)
                pt1.z=500;pt2.z=500
                mid_point = Geom.linear_combination( 0.5, pt1, 0.5, pt2 )
                dim_l = add_dimension_pts(pt1, pt2, vector)
                dim_l.layer = layer_name
                if show_dimension
                    st_index, end_index, vector = 0,1, Geom::Vector3d.new(0,-dim_off,0)
                    pt1, pt2 = TT::Bounds.point(comp.bounds, st_index), TT::Bounds.point(comp.bounds, end_index)
                    pt1.z=500;pt2.z=500
                    dim_l = add_dimension_pts(pt1, pt2, vector)
                    dim_l.layer = layer_name
                end
            end	
            lam_code = get_lamination comp
            text = Sketchup.active_model.entities.add_text lam_code, mid_point, lvector if lam_code && !lam_code.empty?
			if text
				text.layer = 'DP_lamination' 
				text.material.color = 'blue'
			end
        when 'left'
			if show_dimension
				st_index, end_index, vector = 2,6, Geom::Vector3d.new(0,dim_off,0)
				pt1, pt2 = TT::Bounds.point(comp.bounds, st_index), TT::Bounds.point(comp.bounds, end_index)
				pt1.x=-500;pt2.x=-500
				dim_l = add_dimension_pts(pt1, pt2, vector)
				dim_l.layer = layer_name
			end

			st_index, end_index, vector = 2,0, Geom::Vector3d.new(0,0,-dim_off)
			pt1, pt2 = TT::Bounds.point(comp.bounds, st_index), TT::Bounds.point(comp.bounds, end_index)
			pt1.x=-500;pt2.x=-500
			dim_l = add_dimension_pts(pt1, pt2, vector)
			dim_l.layer = layer_name
        when 'right'
			if show_dimension
				st_index, end_index, vector = 1,5, Geom::Vector3d.new(0,-dim_off,0)
				pt1, pt2 = TT::Bounds.point(comp.bounds, st_index), TT::Bounds.point(comp.bounds, end_index)
				pt1.x=500;pt2.x=500
				dim_l = add_dimension_pts(pt1, pt2, vector)
				dim_l.layer = layer_name
			end
			
			st_index, end_index, vector = 1,3, Geom::Vector3d.new(0,0,-dim_off)
			pt1, pt2 = TT::Bounds.point(comp.bounds, st_index), TT::Bounds.point(comp.bounds, end_index)
			pt1.x=500;pt2.x=500
			dim_l = add_dimension_pts(pt1, pt2, vector)
			dim_l.layer = layer_name
        when 'front'
			
			st_index, end_index, vector = 0,1, Geom::Vector3d.new(0,0,-dim_off)
			pt1, pt2 = TT::Bounds.point(comp.bounds, st_index), TT::Bounds.point(comp.bounds, end_index)
			pt1.y=-500;pt2.y=-500
			dim_l = add_dimension_pts(pt1, pt2, vector)
			dim_l.layer = layer_name
			
			if show_dimension
				st_index, end_index, vector = 0,4, Geom::Vector3d.new(-dim_off,0,0)
				pt1, pt2 = TT::Bounds.point(comp.bounds, st_index), TT::Bounds.point(comp.bounds, end_index)
				pt1.y=-500;pt2.y=-500
				dim_l = add_dimension_pts(pt1, pt2, vector)
				dim_l.layer = layer_name
			end
        when 'back'
            st_index, end_index, vector = 2,3, Geom::Vector3d.new(0,0,-dim_off)
            pt1, pt2 = TT::Bounds.point(comp.bounds, st_index), TT::Bounds.point(comp.bounds, end_index)
            pt1.y=500;pt2.y=500
            dim_l = add_dimension_pts(pt1, pt2, vector)
            dim_l.layer = layer_name
			if show_dimension	
				st_index, end_index, vector = 2,6, Geom::Vector3d.new(dim_off,0,0)
				pt1, pt2 = TT::Bounds.point(comp.bounds, st_index), TT::Bounds.point(comp.bounds, end_index)
				pt1.y=500;pt2.y=500
				dim_l = add_dimension_pts(pt1, pt2, vector)
				dim_l.layer = layer_name
			end
        end
        
    end
    
    def self.add_row_dimension row, view
        comp_names = []

        row.each{ |id|
            comp = DP::get_comp_pid(id)
            defn_name   = comp.definition.name
            if comp_names.include?(defn_name)
                add_comp_dimension comp, view, false
            else
                comp_names << defn_name
                add_comp_dimension comp, view
            end
        }
    end
    
    def self.add_dimensions comp_h, view='top'
        #outline_drawing comp_h, view
        #corners = get_corners view
        rows = get_comp_rows comp_h, view
        row_elems = rows.flatten.uniq
        comp_h.keys.each { |id|
            comp_h[id][:row_elem] = true if row_elems.include?(id)
        }
        rows.each{|row|
            add_row_dimension row, view
        }
        
        comp_h.each { |comp_details|
            comp_id = comp_details[0]
            comp = DP::get_comp_pid comp_id
            add_comp_dimension comp, view unless comp_h[comp_id][:row_elem]
        }
    end
    
    def self.get_comp_rows comp_h, view
        corners = []
		singles = []
		comp_h.each_pair{|x, y| 
			if y[:type]==:corner
				corners<<x 
			elsif y[:type]==:single 
				singles<<x
			end
		}
		rows = []

        corners.each{|id| comp_h[id][:type]=:corner}
		corners.each{|cor|
			adjs = comp_h[cor][:adj]
			row = []
			adjs.each{|adj_comp|
				row  = [cor]
				curr = adj_comp
				#comp_h[cor][:adj].delete curr
				comp_h[curr][:adj].delete cor
				while comp_h[curr][:type] == :double
					row << curr
					adj_next = comp_h[curr][:adj][0]
					comp_h[adj_next][:adj].delete curr
					comp_h[curr][:adj].delete adj_next
					curr = adj_next
				end
				row << curr
                row.sort_by!{|r| comp=DP.get_comp_pid r; comp.transformation.origin.x}
				rows << row
			}
        } 
		row_elems = rows.flatten
#=begin		
		singles.reject!{|x| row_elems.include?(x)}
		singles.each{|cor|
			adjs = comp_h[cor][:adj]
			row = []
			adjs.each{|adj_comp|
				row  = [cor]
				curr = adj_comp
				#comp_h[cor][:adj].delete curr
				comp_h[curr][:adj].delete cor
				while comp_h[curr][:type] == :double
					row << curr
					adj_next = comp_h[curr][:adj][0]
					comp_h[adj_next][:adj].delete curr
					comp_h[curr][:adj].delete adj_next
					curr = adj_next
				end
				row << curr
                row.sort_by!{|r| comp=DP.get_comp_pid r; comp.transformation.origin.x}
				rows << row
			}
        } 
#=end		
		
        rows
    end

    def self.outline_drawing view, offset=500 #comp_h not needed
        comps 	= DP::get_visible_comps view
		comp_h 	= DP::parse_components comps 
 
        comp_h.keys.each{|cid|
            comp = DP::get_comp_pid cid
            next if comp.nil?
            pts = get_outline_pts comp, view, offset

            face = Sketchup.active_model.entities.add_face(pts)
            face.edges.each{|edge| edge.layer = 'DP_outline_'+view}
            face.layer 	= 	'DP_outline_'+view
            face.hidden	=	true
        }
        add_dimensions comp_h, view
    end
    
	def self.get_layer_entities layer_name
		model = Sketchup::active_model
		ents = model.entities
		layer_ents = []
		layer_ents = ents.select{|x| x.layer.name==layer_name}
	end
	
	def self.delete_layer_entities layer_name
		layer_ents = get_layer_entities layer_name
		layer_ents.each{|ent| 
			unless ent.deleted?
				Sketchup::active_model.entities.erase_entities ent
			end
		}
	end
	
    #Create the working drawing for the specific view
	def self.working_drawing view='top'
		views = ['top', 'left', 'right', 'back', 'front']
		return nil unless views.include?(view)

		if view=='top'
			layer_name = 'DP_lamination'
			Sketchup.active_model.layers.add(layer_name) if Sketchup.active_model.layers[layer_name].nil?
			delete_layer_entities layer_name
		end
		
        layer_name = 'DP_outline_'+view
        Sketchup.active_model.layers.add(layer_name) if Sketchup.active_model.layers[layer_name].nil?
		delete_layer_entities layer_name
        
        layer_name = 'DP_dimension_'+view
        Sketchup.active_model.layers.add(layer_name) if Sketchup.active_model.layers[layer_name].nil?
		delete_layer_entities layer_name
		
        outline_drawing view
        puts "done"
	end
    
    def self.get_all_views
        views = ['top', 'left', 'right', 'back', 'front']
        views.each { |v|  working_drawing v  }
    end
    
    def self.get_single_adj comp_h
        singles=[]; comp_h.each_pair{|x, y| singles<<x if y[:type] == :single}; return singles
    end
    
    def self.get_corners comp_h
        corners = []
        comp_h.each_pair{|x, y| 
            if y[:type] == :double
                adj_comps = y[:adj]
                cor_comp =  DP.get_comp_pid x
                comp1 = DP.get_comp_pid adj_comps[0]
                comp2 = DP.get_comp_pid adj_comps[1]
                if (comp1.transformation.rotz+comp2.transformation.rotz)%180 != 0
                    #This check when its row component but the adjacents are rotated
                    f1 = DP.ents.add_face(DP::get_xn_pts cor_comp, comp1)
                    f2 = DP.ents.add_face(DP::get_xn_pts cor_comp, comp2)
                    if f2.normal.perpendicular? f1.normal
                        corners<<x 
                        #DP.sel.add cor_comp
                    end
                    DP.ents.erase_entities f1, f2
                end
            end
        }
        return corners
    end
	
	def self.write_imageeeee(val)
		view = Sketchup.active_model.active_view
		if val == 'top'
			@name = "Top View"
			eye = [0, 0, 500]
			target = [0, 0, 0]
			up = [-0.006059714697060147, 0.9701603229993295, -0.2423885878824059]
		elsif val == 'right'
			@name = "Right View"
			eye = [500, 0, 50]
			target = [0, 0, 0]
			up = [-1, 0, 0]
		elsif val == 'front'
			@name = "Front View"
			eye = [0, -450, 70]
			target = [0, 0, 0]
			up = [0, 0, 1]
		end
		cam = Sketchup::Camera.new eye, target, up
		view.camera = cam
		keys = {
		  :filename => "C:/Users/Decorpot-020/Desktop/Images/#{@name}.png",
		  :width => view.vpwidth,
		  :height => view.vpheight,
		  :antialias => false,
		  #:compression => 0.9,
		  :transparent => true
		}
		view.write_image keys
	end
	
	
	def self.get_rio_components
		Sketchup.active_model.entities.grep(Sketchup::ComponentInstance).select{|x| x.definition.get_attribute('rio_params', 'standard_comp')=='rio_comp'}
	end
			
	def self.check_xn check_comp, comp_a
		comp_a.each { |comp|
			next if comp == check_comp
			xn = comp.bounds.intersect check_comp.bounds
			return true if xn.width * xn.height * xn.depth != 0
		}
		return false
	end
			
	def self.scan_components
		comp_a = get_rio_components
		adj_comps = []
		unless comp_a.empty?	
			comp_a.each{|comp|
				resp = check_xn comp, comp_a
				adj_comps << comp if resp
			}
			return adj_comps
		end
		puts "adj_comps : #{adj_comps}"
		
		adj_comps
	end	
	
	def self.export_working_drawing
		adj_comps = scan_components
		if !adj_comps.empty?
			Sketchup.active_model.selection.clear
			adj_comps.each{|comp| Sketchup.active_model.selection.add comp}
			UI.messagebox("The selected components overlap each other. Working drawing doesnt allow component overlap.")
			return false
		end
		viloop = []
		views_to_process = ["Top","Front","Right","Left","Back"]
		#views_to_process = ["Top"]
		end_format = ".jpg"
		if Sketchup.active_model.title != ""
			@title = Sketchup.active_model.title
		else
			@title = "Untitled"
		end

		outpath = "C:/Users/Decorpot-020/Desktop/imgexport/"
	

		views_to_process.each {|vi|
			viloop.push(vi)
			
			view = vi.downcase
			layers = Sketchup.active_model.layers
			visible_layers = ['DP_outline_'+view, 'DP_dimension_'+view]
			visible_layers << 'DP_lamination' if view=='top'
			working_drawing view

			Sketchup.active_model.active_layer=visible_layers[1]
			layers.each{|layer| 
				layer.visible=false unless visible_layers.include?(layer.name)}
			visible_layers.each{|l| Sketchup.active_model.layers[l].visible=true}
			
			if vi == "Top"
				@cPos = [0, 0, 0]
				@cTarg = [0, 0, -1]
				@cUp = [0, 1, 0]
			elsif vi == "Front"
				@cPos = [0, 0, 0]
				@cTarg = [0, 1, 0]
				@cUp = [0, 0, 1]
			elsif vi == "Right"
				@cPos = [0, 0, 0]
				@cTarg = [-1, 0, 0]
				@cUp = [0, 0, 1]
			elsif vi == "Left"
				@cPos = [0, 0, 0]
				@cTarg = [1, 0, 0]
				@cUp = [0, 0, 1]
			elsif vi == "Back"
				@cPos = [0, 0, 0]
				@cTarg = [0, -1, 0]
				@cUp = [0, 0, 1]
			end
			
			Sketchup.active_model.active_view.camera.set @cPos, @cTarg, @cUp
			Sketchup.active_model.active_view.zoom_extents
			keys = {
				:filename => outpath+vi+end_format,
				:width => 1920,
				:height => 1080,
				:antialias => true,
				:compression => 0,
				:transparent => true
			}
			#Sketchup.active_model.active_view.write_image keys
			Sketchup.active_model.active_view.write_image outpath+vi+end_format
			#Sketchup.active_model.active_view.write_image outpath+"j"+view+".jpg"
			
			layers.each{|layer| layer.visible=true}
		}

		FileUtils.cd(outpath)
		f = File.open("#{@title}.pdf", 'w')
		if f.is_a?(File)
			f.close
			Prawn::Document.generate("#{@title}.pdf", :page_size=>"A4", :page_layout=>:landscape) do
				viloop.each {|vp|
					image outpath+vp+end_format, width: 750, height: 500, resolution: 1920
				}
			end
			UI.messagebox 'Export successful',MB_OK
		else
			UI.messagebox 'Cannot write to pdf.Please Close and try again if pdf is open.',MB_OK
		end
		#system('explorer %s' % (outpath))
	end
end


