SKETCHUP_CONSOLE.show

puts "Rio loader"

if defined?(RIO_ROOT_PATH).to_s != 'constant'

	RIO_ROOT_PATH	= File.join(File.dirname(__FILE__))
	install_path 	= File.join(RIO_ROOT_PATH, 'install')
	puts RIO_ROOT_PATH

	json_file 		= File.read(RIO_ROOT_PATH+'/settings/file_list_schema.json');
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

flist.each{|file_name|
	puts file_name
	Sketchup::require file_name
}
#-----------------------------------------Add Pre start processes here--------------------
#
DP::create_layers
WorkingDrawing::initialize
#
#-----------------------------------------------------------------------------------------

def zrot
	seln = Sketchup.active_model.selection
	if seln.length == 0
		puts "No component selected"
		return
	end
	comp=seln[0]
	point = comp.transformation.origin
	vector = Geom::Vector3d.new(0,0,1)
	angle = 90.degrees
	transformation = Geom::Transformation.rotation(point, vector, angle)
	comp.transform!(transformation)
end
#------------------------------------------Observers--------------------------------------
# class MyEntitiesObserver < Sketchup::EntitiesObserver
	# def onElementAdded(entities, entity)
		# puts "onElementAdded: #{entity}"
	# end
	# def onElementModified(entities, entity)
		# puts "onElementModified: #{entity}"
	# end
# end

#Attach the observer
# Sketchup.active_model.entities.add_observer(MyEntitiesObserver.new)





