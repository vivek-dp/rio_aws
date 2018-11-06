require_relative '../lib/code/aws_core.rb' #remove later
require_relative '../lib/code/aws_downloader.rb'

TITLE||='Rio Standards'
WEBDIALOG_PATH ||= 'E:\git\rio_aws\webpages'
dialog = UI::WebDialog.new("#{TITLE}", true, "#{TITLE}", 700, 600, 150, 150, true)
html_path = File.join(WEBDIALOG_PATH, 'import_comp.html')
dialog.set_file(html_path)
dialog.set_position(0, 150)
dialog.show

dialog.add_action_callback("loadmaincatagory"){|a, b|
	mainarray 	= RioAwsDownload::get_folder_files('decorpot-assets/Dynamic-Components/')
	
	js_maincat 	= "passMainCategoryToJs("+mainarray.to_s+")"
	a.execute_script(js_maincat)
}