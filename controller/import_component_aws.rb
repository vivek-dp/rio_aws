require_relative '../lib/code/aws_core.rb' #remove later
require_relative '../lib/code/aws_downloader.rb'

module RioAWSComponent
	def self.get_sub_list folder_name
	
	end
	
	
	def self.decor_import_comp
		dialog = UI::WebDialog.new("#{TITLE}", true, "#{TITLE}", 700, 600, 150, 150, true)
		html_path = File.join(WEBDIALOG_PATH, 'import_comp.html')
		dialog.set_file(html_path)
		dialog.set_position(0, 150)
		dialog.show
		
		dialog.add_action_callback("loadmaincatagory"){|a, b|
			mainarray 	= RioAwsDownload::get_folder_files('')
			
			js_maincat 	= "passMainCategoryToJs("+mainarray.to_s+")"
			a.execute_script(js_maincat)
		}
	end
	
end