module Decor_Standards
	DECORPOT_ASSETS ||= File.join(RIO_ROOT_PATH, 'assets')

	def self.load_main_category()
		path = DECORPOT_ASSETS + "/"
		mainarray = ""
		dirpath = Dir[path+"*"]
		dirpath.each {|mc|
			spval = mc.split("/")
			mainarray += '<option value="'+spval.last+'">'+spval.last+'</option>'
		}
		lastarray = '<select class="ui dropdown" id="main-category" onchange="changeMainCategory()"><option value="0">Select...</option>'+mainarray+'</select>'
		return lastarray
	end

	def self.load_sub_category(val)
		path = DECORPOT_ASSETS + "/" + val + "/"
		arr_value = ""
		dirpath = Dir[path+"*"]
		dirpath.each{|file|
			spval = file.split("/")
			arr_value += '<option value="'+spval.last+'">'+spval.last+'</option>'
		}
		sublast = '<select class="ui dropdown" id="sub-category" onchange="changeSubCategory()"><option value="0">Select...</option>'+arr_value+'</select>'
		return sublast
	end

	def self.load_skp_file(cat)
		subpath = DECORPOT_ASSETS + "/" + cat[0] + "/" + cat[1] + "/"
		subarr = []
		subdir = Dir[subpath+"*.skp"]
		subdir.each{|s|
			subarr.push(s)
		}
		return subarr
	end


	def self.place_Defcomponent(val)
		@model = Sketchup::active_model
		cdef = @model.definitions.load(val)
		placecomp = @model.place_component cdef.entities[0].definition
	end
end