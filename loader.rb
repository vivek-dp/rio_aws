module Decor_Standards
	SUPPORT_PATH 		= File.join(File.dirname(__FILE__))
	CONTROL_PATH 		= File.join(SUPPORT_PATH, 'controller')
	WEBDIALOG_PATH   	= File.join(SUPPORT_PATH, 'webpages')
	DECORPOT_ASSETS 	= File.join(SUPPORT_PATH, 'assets')
	BACKUP_PATH 		= File.join(SUPPORT_PATH, 'backup')

	path = File.dirname(__FILE__)
	cont_path = File.join(path, 'controller')

	Sketchup::require File.join(cont_path, 'load_toolbar.rb')
	Sketchup::require File.join(cont_path, 'create_wall.rb')
	Sketchup::require File.join(cont_path, 'import_component_aws.rb')
	Sketchup::require File.join(cont_path, 'dynamic_configuration.rb')
	Sketchup::require File.join(cont_path, 'export_report.rb')
	Sketchup::require File.join(cont_path, 'working_drawing.rb')

end