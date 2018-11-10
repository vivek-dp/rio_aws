module RIO

	
end

SUPPORT_PATH 	= File.join(File.dirname(__FILE__))
install_path 	= File.join(SUPPORT_PATH, 'install')

json_file 		= File.read('E:\Rio_install\install\file_list_schema.json');
file_list_h		= JSON.parse(json_file)
flist			= []
file_list_h.keys.each{ |key|
	#Change this method to recursively get ruby files
	first_key = file_list_h[key][0]	
	if first_key.is_a?(Array)
		file_list_h[key].each{ |fname|
			file_name = File.join(SUPPORT_PATH, key, fname)
			flist << file_name
		}
	else
		file_list_h[key].each{|subkey| 
			if subkey.is_a?(String)
				file_name	= File.join(SUPPORT_PATH,key,subkey) #For files inside subfolders
				flist << file_name
			else
				subpath = subkey.keys[0]
				subkey[subpath].each{|fname|
					file_name = File.join(SUPPORT_PATH, key, fname)
					flist << file_name
				}
			end
		}
	end
}

RIO_ROOT ||= 'C:\RioSTD'
flist.each{|file_name|
	Sketchup.load(File.join(RIO_ROOT, file_name))
}

