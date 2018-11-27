SKETCHUP_CONSOLE.show

if defined?(RIO_ROOT_PATH).to_s != 'constant'

	RIO_ROOT_PATH	= File.join(File.dirname(__FILE__))
	install_path 	= File.join(RIO_ROOT_PATH, 'install')
	puts RIO_ROOT_PATH

	json_file 		= File.read('settings/file_list_schema.json');
	file_list_h		= JSON.parse(json_file)
	flist			= []
	file_list_h.keys.each { |key|
		#Change this method to recursively get ruby files
		value = file_list_h[key]
		if value.is_a?(Array)
			file_list_h[key].each{ |fname|
				file_name = File.join(RIO_ROOT_PATH, key, fname)
				flist << file_name
			}
		else
			value.keys.each{|subkey| 
				sub_folder = value[subkey]
				sub_folder.each{|fname|
					file_name = File.join(RIO_ROOT_PATH, key, subkey, fname)
					flist << file_name
				}

			}
		end
	}
	#file_loaded?
end