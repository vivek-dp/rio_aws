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
		
		dialog.add_action_callback("loadmaincatagory"){|a, b|
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
		
		dialog.add_action_callback("place_model"){|d, val|
			self.place_Defcomponent(val)
		}
	end
	
	def self.place_Defcomponent(val)
		puts "place_Defcomponent : val : #{val}"
		target_path = RioAwsDownload::download_skp val
		@model = Sketchup::active_model
		puts "target_path : #{target_path}"
		cdef = @model.definitions.load(target_path)
		
		dict_name = 'rio_params'
		key = 'standard_comp'
		cdef.entities[0].definition.set_attribute(dict_name, key, 'rio_comp')
		
		placecomp = @model.place_component cdef.entities[0].definition
	end
	
end