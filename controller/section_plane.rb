def section_plane angle
	mod 	= Sketchup.active_model

	#Sketchup.active_model.start_operation 'rio_plane'

	ents	= [];
	ents	= mod.entities.each{|mod_comp|
		ents << mod_comp
	}
	
	Sketchup.active_model.selection.clear
	mod.entities.each { |ent|
		if ent.respond_to?(:transformation)
			Sketchup.active_model.selection.add(ent) if ent.transformation.rotz==angle
		end
	}

	#mod.abort_operation

end