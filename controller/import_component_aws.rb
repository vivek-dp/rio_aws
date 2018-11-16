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
		
#		dialog.add_action_callback("loadmaincatagory"){|a, b|
#			mainarray 	= RioAwsDownload::get_folder_files('decorpot-assets/')
#			
#			js_maincat 	= "passMainCategoryToJs("+mainarray.to_s+")"
#			a.execute_script(js_maincat)
#		}
#		dialog.add_action_callback("get_category") {|d, val|
#			val 		= val.to_s
#			arr_value 	= RioAwsDownload::get_folder_files('decorpot-assets/'+val+'/')
#			js_subcat 	= "passSubCategoryToJs("+arr_value.to_s+")"
#			d.execute_script(js_subcat)
#		}
#		
#		
#		dialog.add_action_callback("load-sketchupfile") { |s, cat|
#			cat = cat.split(",")
#			arr_value 	= RioAwsDownload::get_folder_files('decorpot-assets/'+cat[0]+'/'+cat[1]+'/')
#			puts "arr_value : #{arr_value} : #{arr_value.class}"
#			
#			if !arr_value.empty?
#				puts "arr_value1"
#				if !arr_value[:jpgs].empty?
#					puts "arr_value2"
#					jpg_arr = [];
#					
#					arr_value[:jpgs].each{|img| 
#						res = RioAwsDownload::download_jpg (arr_value[:prefix]+img)
#						jpg_arr << res}
#						jpg_arr << arr_value[:prefix]
#					puts "jpg_arr : #{jpg_arr}"
#					js_command = "passFromRubyToJavascript("+ jpg_arr.to_s + ")"
#					s.execute_script(js_command)
#				end
#			end
#		}

        decorpot_asset = "E:/git/rio_aws/assets"

        dialog.add_action_callback("loadmaincatagory"){|a, b|
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
		
		dialog.add_action_callback("place_model"){|d, val|
			self.place_Defcomponent(val)
		}
	end
	
	def self.place_Defcomponent(val)
		puts "place_Defcomponent : val : #{val}"
        
        auto_placement = false
		#target_path = RioAwsDownload::download_skp val
        target_path = val.split('.skp')[0]+'.skp' 
		@model = Sketchup::active_model
		puts "target_path : #{target_path}"
		cdef = @model.definitions.load(target_path)
		
		dict_name = 'rio_params'
		key = 'standard_comp'
		cdef.entities[0].definition.set_attribute(dict_name, key, 'rio_comp')
		
        status = DP::get_state 
        
        if status
            if status.start_with?('wall-clicked')
                 
            elsif status.start_with?('comp-clicked')
                posn = status.split(':')[1].downcase
                comp = Sketchup.active_model.selection[0]
                rotz = comp.transformation.rotz
                
                #Sketchup.active_model.place_component fsel.definition
                
                puts "posn : #{posn} : #{rotz}"
                comp_origin = comp.transformation.origin
                comp_origin = comp.transformation.origin
                case posn
                when 'left'
                    case rotz
                    when 0
                #        orig_tr =Geom::Transformation.new([0,0,0])
                #        inst    =Sketchup.active_model.active_entities.add_instance cdef, orig_tr
                #        inst.transform!(orig_tr)

                        trans   = Geom::Transformation.new([comp_origin.x-cdef.bounds.width, comp_origin.y, comp_origin.z])
                        Sketchup.active_model.active_entities.add_instance cdef, trans
                        #inst.transform!(trans)
                    when 90
                        tr      = Geom::Transformation.rotation([0, 0, 0], Z_AXIS, rotz.degrees)
                        inst    = Sketchup.active_model.active_entities.add_instance cdef, tr
                        trans   = Geom::Transformation.new([comp_origin.x, comp_origin.y-cdef.bounds.width, comp_origin.z])
                        inst.transform!(trans)
                    when 180, -180
                        tr      = Geom::Transformation.rotation([0, 0, 0], Z_AXIS, rotz.degrees)
                        inst    = Sketchup.active_model.active_entities.add_instance cdef, tr
                        trans = Geom::Transformation.new([comp_origin.x+cdef.bounds.width, comp_origin.y, comp_origin.z])
                        inst.transform!(trans)
                    when -90
                        tr      = Geom::Transformation.rotation([0, 0, 0], Z_AXIS, rotz.degrees)
                        inst    = Sketchup.active_model.active_entities.add_instance cdef, tr
                        trans = Geom::Transformation.new([comp_origin.x, comp_origin.y+cdef.bounds.width, comp_origin.z])
                        inst.transform!(trans)
                    end
                when 'right'
                    case rotz
                    when 0
                        trans = Geom::Transformation.new([comp_origin.x+comp.bounds.width, comp_origin.y, comp_origin.z])
                        Sketchup.active_model.active_entities.add_instance cdef, trans
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
                        trans = Geom::Transformation.new([comp_origin.x, comp_origin.y, comp_origin.z+comp.bounds.depth])
                        Sketchup.active_model.active_entities.add_instance cdef, trans
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
            end
        else
            placecomp = @model.place_component cdef.entities[0].definition
        end
	end
	
end