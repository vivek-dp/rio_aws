require_relative '../lib/code/aws_core.rb' #remove later
require_relative '../lib/code/aws_downloader.rb'

module RioAWSComponent
	def self.get_sub_list folder_name
	
	end
	
	
	def self.decor_import_comp
		title 		= 'Decor - Standards'
		dialog 		= UI::WebDialog.new("#{title}", true, "#{title}", 700, 600, 150, 150, true)
		webpath		= File.join('E:/git/rio_aws','webpages') #remove this
		html_path 	= File.join(webpath, 'import_comp.html')
		dialog.set_file(html_path)
		dialog.set_position(0, 150)
		dialog.show

=begin        
        #Begin : AWS download the assets..................
		dialog.add_action_callback("loadmaincategory"){|a, b|
			mainarray 	= RioAwsDownload::get_folder_files('decorpot-assets/')
			
			js_maincat 	= "passMainCategoryToJs("+mainarray.to_s+")"
			a.execute_script(js_maincat)
		}
		dialog.add_action_callback("get_category") {|d, val|
			val 		= val.to_s
			arr_value 	= RioAwsDownload::get_folder_files('decorpot-assets/'+val+'/')
			js_subcat 	= "passSubCategoryToJs("+arr_value.to_s+")"
			d.execute_script(js_subcat)
		}
		
		
		dialog.add_action_callback("load-sketchupfile") { |s, cat|
			cat = cat.split(",")
			arr_value 	= RioAwsDownload::get_folder_files('decorpot-assets/'+cat[0]+'/'+cat[1]+'/')
			puts "arr_value : #{arr_value} : #{arr_value.class}"
			
			if !arr_value.empty?
				puts "arr_value1"
				if !arr_value[:jpgs].empty?
					puts "arr_value2"
					jpg_arr = [];
					
					arr_value[:jpgs].each{|img| 
						res = RioAwsDownload::download_jpg (arr_value[:prefix]+img)
						jpg_arr << res}
						jpg_arr << arr_value[:prefix]
					puts "jpg_arr : #{jpg_arr}"
					js_command = "passFromRubyToJavascript("+ jpg_arr.to_s + ")"
					s.execute_script(js_command)
				end
			end
        }
        #End : AWS download the assets..................
=end

        #Begin : Temporary code for local access of the assets...
        decorpot_asset = "E:/git/rio_aws/assets"

        dialog.add_action_callback("loadmaincategory"){|a, b|
            puts "loadmaincategory"
			path = decorpot_asset + "/"
			mainarray = []
			dirpath = Dir[path+"*"]
			dirpath.each {|mc|
				mainarray.push(mc)
			}
			js_maincat = "passMainCategoryToJs("+mainarray.to_s+")"
			a.execute_script(js_maincat)
		}

		dialog.add_action_callback("get_category") {|d, val|
			val = val.to_s
			@path = decorpot_asset + "/" + val + "/"
			@arr_value = []
			@dirpath = Dir[@path+"*"]
			
			@dirpath.each {|file|
				@arr_value.push(file)
			}
			js_subcat = "passSubCategoryToJs("+@arr_value.to_s+")"
			d.execute_script(js_subcat)
		}

		dialog.add_action_callback("load-sketchupfile") {|s, cat|
			cat = cat.split(",")
			@subpath = decorpot_asset + "/" + cat[0] + "/" + cat[1] + "/"
			@subarr = []
			@subdir = Dir[@subpath+"*.skp"]
            puts "subpath : #{@subpath}"
			@subdir.each{|s|
				@subarr.push(s)
			}
            puts "@subarr : #{@subarr}"
			js_command = "passFromRubyToJavascript("+ @subarr.to_s + ")"
			s.execute_script(js_command)
        }
        #End : Temporary code for local access of the assets...
		
		dialog.add_action_callback("place_model"){|d, val|
			place_Defcomponent(val)
        }
        dialog.add_action_callback("edit_component"){|d, val|
            place_component(val, true)
        }
	end #decor_import_comp
    
    def self.place_component options={}, edit=false
        comp_origin     = nil

        if edit==true
            if Sketchup.active_model.selection.empty?
                UI.messagebox('No component selected')  #This should not happen 
                return false
            end
            sel             = Sketchup.active_model.selection[0] 
            comp_origin     = sel.transformation.origin
            comp_trans      = sel.transformation
        end


        # options ={"main-category"=>"Kitchen_Base_Unit",
        #     "sub-category"=>"Base_Single_Door",
        #     "carcass-code"=>"BC_500",
        #     "shutter-code"=>"SD_50_70",
        #     "door-type"=>"Single",
        #     "shutter-type"=>"solid",
        #     "shutter-origin"=>"1_1"}

        # options = {"internal-category"=>"7",
        #         "main-category"=>"Wardrobe_Sliding_Door",
        #         "sub-category"=>"Wardrobe_Sliding_2Door",
        #         "carcass-code"=>"WS_2_600",
        #         "shutter-code"=>"SLD2_600",
        #         "door-type"=>"Double",
        #         "shutter-type"=>"solid",
        #         "material-type"=>"aluminium",
        #         "shutter-origin"=>"0_76"}

        return false if options.empty?
        bucket_name     = 'rio-sub-components'

        main_category   = options['main-category']
        #Bad Mapping........:)
        main_category = 'Crockery_Unit' if main_category.start_with?('Crockery') #Temporary mapping ....Move crockery to base unit and top unit later in the AWS server
            
        sub_category    = options['sub-category']   #We will use it for decription
        carcass_code    = options['carcass-code']
        shutter_code    = options['shutter-code']||''
        internal_code   = options['internal-category']||''
        shutter_origin  = options['shutter-origin']||''

        #------------------------------------------------------------------------------------------------
        carcass_skp         = carcass_code+'.skp'
        aws_carcass_path    = File.join('carcass',main_category,carcass_skp)
        local_carcass_path  = File.join(RIO_ROOT_PATH,'cache',carcass_skp)

        if File.exists?(local_carcass_path)
            puts "File already present "
        else
            puts "Downloading file"
            resp = RioAwsDownload::download_file bucket_name, aws_carcass_path, local_carcass_path
            if resp.nil?
                puts "Carcass file download error  : "+aws_carcass_path
                return false
            end
        end
        #------------------------------------------------------------------------------------------------
        if shutter_code.empty?
            local_shutter_path = ''
        else
            puts "Downloading shutter"
            shutter_skp         = shutter_code+'.skp'
            aws_shutter_path    = File.join('shutter',shutter_skp)
            local_shutter_path  = File.join(RIO_ROOT_PATH,'cache',shutter_skp)
            puts shutter_skp, aws_shutter_path
            unless File.exists?(local_shutter_path)
                RioAwsDownload::download_file bucket_name, aws_shutter_path, local_shutter_path
            end
        end

        options = {
            :shutter_origin => shutter_origin,
            :internal_code => internal_code,
            :comp_origin => comp_origin
        }
        #Remove the previous component
        Sketchup.active_model.entities.erase_entities sel if edit

        defn = DP::create_carcass_definition local_carcass_path, local_shutter_path, options
        defn.set_attribute(:rio_atts, 'carcass_code', carcass_code)
        defn.set_attribute(:rio_atts, 'shutter_code', shutter_code)
        defn.set_attribute(:rio_atts, 'internal_code', internal_code)

        prev_active_layer = Sketchup.active_model.active_layer.name
        Sketchup.active_model.active_layer='DP_Comp_layer'
        
        if edit == true
            Sketchup.active_model.entities.add_instance defn, comp_trans
        else
            placecomp = Sketchup.active_model.place_component defn
        
        end
        Sketchup.active_model.active_layer=prev_active_layer
        return true
    end
 
    #Check if set_attribute to definition is right
	def self.place_Defcomponent(val)
		puts "place_Defcomponent : val : #{val}"
        
        auto_placement = false
        #target_path = RioAwsDownload::download_skp val
        
        prev_active_layer = Sketchup.active_model.active_layer.name
        Sketchup.active_model.active_layer='DP_Comp_layer'
        target_path = val.split('.skp')[0]+'.skp' 
		@model = Sketchup::active_model
		puts "target_path : #{target_path}"
		cdef = @model.definitions.load(target_path)
		
		dict_name   = :rio_atts
		key         = 'rio_comp'
        cdef.set_attribute(dict_name, key, 'true')
        auto_mode = DP::get_auto_mode

        if auto_mode && auto_mode != false
            status = 'comp-clicked:'+DP::get_auto_mode
        else
            status = DP::get_state 
        end
        puts "status : #{auto_mode} : #{status}"
        if status
            if Sketchup.active_model.selection[0].nil? #Ideally this should not happen :)
                puts "No component selected...Please select a component to do auto placement"
            else
                if status.start_with?('wall-clicked')
                    wall        = Sketchup.active_model.selection[0]
                    wall_posn   = wall.get_attribute :rio_atts, 'position'

                    case wall_posn
                    when 'left'
                        rotz = 90
                        comp_origin = wall.bounds.corner(0)
                    when 'front'
                        rotz = 180
                        comp_origin = wall.bounds.corner(1)
                    when 'right'
                        rotz = -90
                        comp_origin = wall.bounds.corner(2)
                    when 'back'
                        rotz = 0
                        comp_origin = wall.bounds.corner(0)
                    end
                    tr      = Geom::Transformation.rotation([0, 0, 0], Z_AXIS, rotz.degrees)
                    inst    = Sketchup.active_model.active_entities.add_instance cdef, tr
                    
                    case wall_posn
                    when 'left'
                        trans   = Geom::Transformation.new([comp_origin.x+inst.bounds.width, comp_origin.y, comp_origin.z])
                    when 'front'
                        puts "front"
                        trans   = Geom::Transformation.new([comp_origin.x, comp_origin.y+inst.bounds.height, comp_origin.z])
                    when 'right'
                        trans   = Geom::Transformation.new([comp_origin.x-inst.bounds.width, comp_origin.y, comp_origin.z])
                    when 'back'
                        trans   = Geom::Transformation.new([comp_origin.x, comp_origin.y-inst.bounds.height, comp_origin.z])
                    end
                    inst.transform!(trans)

                elsif status.start_with?('comp-clicked')
                    posn = status.split(':')[1].downcase
                    comp = Sketchup.active_model.selection[0]
                    if comp.nil?  
                        puts "No component selected"
                        return
                    end
                    rotz = comp.transformation.rotz

                    puts "posn : #{posn} : #{rotz}"
                    comp_origin = comp.transformation.origin
                    
                    case posn
                    when 'left'
                        case rotz
                        when 0
                            trans   = Geom::Transformation.new([comp_origin.x-cdef.bounds.width, comp_origin.y, comp_origin.z])
                            inst    = Sketchup.active_model.active_entities.add_instance cdef, trans
                        when 90
                            tr      = Geom::Transformation.rotation([0, 0, 0], Z_AXIS, rotz.degrees)
                            inst    = Sketchup.active_model.active_entities.add_instance cdef, tr
                            trans   = Geom::Transformation.new([comp_origin.x, comp_origin.y-cdef.bounds.width, comp_origin.z])
                            inst.transform!(trans)
                        when 180, -180
                            tr      = Geom::Transformation.rotation([0, 0, 0], Z_AXIS, rotz.degrees)
                            inst    = Sketchup.active_model.active_entities.add_instance cdef, tr
                            trans   = Geom::Transformation.new([comp_origin.x+cdef.bounds.width, comp_origin.y, comp_origin.z])
                            inst.transform!(trans)
                        when -90
                            tr      = Geom::Transformation.rotation([0, 0, 0], Z_AXIS, rotz.degrees)
                            inst    = Sketchup.active_model.active_entities.add_instance cdef, tr
                            trans   = Geom::Transformation.new([comp_origin.x, comp_origin.y+cdef.bounds.width, comp_origin.z])
                            inst.transform!(trans)
                        end
                    when 'right'
                        case rotz
                        when 0
                            trans   = Geom::Transformation.new([comp_origin.x+comp.bounds.width, comp_origin.y, comp_origin.z])
                            inst    = Sketchup.active_model.active_entities.add_instance cdef, trans
                        when 90
                            tr      = Geom::Transformation.rotation([0, 0, 0], Z_AXIS, rotz.degrees)
                            inst    = Sketchup.active_model.active_entities.add_instance cdef, tr
                            trans   = Geom::Transformation.new([comp_origin.x, comp_origin.y+comp.bounds.height, comp_origin.z])
                            inst.transform!(trans)
                        when 180, -180
                            tr      = Geom::Transformation.rotation([0, 0, 0], Z_AXIS, rotz.degrees)
                            inst    = Sketchup.active_model.active_entities.add_instance cdef, tr
                            trans = Geom::Transformation.new([comp_origin.x-cdef.bounds.width, comp_origin.y, comp_origin.z])
                            inst.transform!(trans)
                        when -90
                            tr      = Geom::Transformation.rotation([0, 0, 0], Z_AXIS, rotz.degrees)
                            inst    = Sketchup.active_model.active_entities.add_instance cdef, tr
                            trans = Geom::Transformation.new([comp_origin.x, comp_origin.y-comp.bounds.height, comp_origin.z])
                            inst.transform!(trans)
                        end
                    when 'top'
                        case rotz
                        when 0
                            trans   = Geom::Transformation.new([comp_origin.x, comp_origin.y, comp_origin.z+comp.bounds.depth])
                            inst    = Sketchup.active_model.active_entities.add_instance cdef, trans
                        when 90
                            tr      = Geom::Transformation.rotation([0, 0, 0], Z_AXIS, rotz.degrees)
                            inst    = Sketchup.active_model.active_entities.add_instance cdef, tr
                            trans   = Geom::Transformation.new([comp_origin.x, comp_origin.y, comp_origin.z+comp.bounds.depth])
                            inst.transform!(trans)
                        when 180, -180
                            tr      = Geom::Transformation.rotation([0, 0, 0], Z_AXIS, rotz.degrees)
                            inst    = Sketchup.active_model.active_entities.add_instance cdef, tr
                            trans = Geom::Transformation.new([comp_origin.x, comp_origin.y, comp_origin.z+comp.bounds.depth])
                            inst.transform!(trans)
                        when -90
                            tr      = Geom::Transformation.rotation([0, 0, 0], Z_AXIS, rotz.degrees)
                            inst    = Sketchup.active_model.active_entities.add_instance cdef, tr
                            trans = Geom::Transformation.new([comp_origin.x, comp_origin.y, comp_origin.z+comp.bounds.depth])
                            inst.transform!(trans)
                        end
                    end

                    puts "inst : #{inst} : #{tr} : #{trans}"
                    if inst
                        comp_bound_check = DP::check_room_bounds inst
                        if comp_bound_check == false
                            UI.messagebox("Component placed outside room bounds")
                        end
                        Sketchup.active_model.selection.add inst
                    end
                end
            end
            if auto_mode != true
                DP::set_state false
            else
                Sketchup.active_model.selection
            end
        else
            placecomp = @model.place_component cdef
        end
        Sketchup.active_model.active_layer=prev_active_layer
	end #place_Defcomponent
	
end #RioAWSComponent