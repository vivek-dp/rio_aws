require_relative '../lib/code/aws_core.rb' #remove later
require_relative '../lib/code/aws_downloader.rb'

module RioAWSComponent
	def self.get_sub_list folder_name
	
	end
	
	
	def self.decor_import_comp
		title = 'Decor - Standards'
		dialog = UI::WebDialog.new("#{title}", true, "#{title}", 700, 600, 150, 150, true)
		webpath=File.join(File.expand_path("..", Dir.pwd), 'webpages') #remove this
		html_path = File.join(webpath, 'import_comp.html')
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
			jpg_arr = [];
			arr_value[:jpgs].each{|img| 
				res = RioAwsDownload::download_jpg (arr_value[:prefix]+img)
				jpg_arr << res}
			js_command = "passFromRubyToJavascript("+ jpg_arr.to_s + ")"
			s.execute_script(js_command)
		}
	end
	
end