layers = ["ELECTRICAL", "Window", "Door", "Wall"]



def two_d_to_3d layer_name
	Sketchup.active_model.start_operation '2d_to_3d'
	visible_layers 	= Sketchup.active_model.layers
	visible_layers.each{|layer| layer.visible=false}
	model		= Sketchup.active_model
	ents 		= model.entities
	puts "start #{ents.length}"
	layer_ents 	= ents.select{|ent| ent.layer.name == layer_name}
	Sketchup.active_model.layers[layer_name].visible=true
	case layer_name
	when 'Wall'
		layer_ents.each{|edge|
			edge.find_faces
		}
		curr_ents 	= Sketchup.active_model.entities
		face_ents 	= curr_ents - ents
		puts face_ents
	when 'Door'
		layer_ents.each{|edge|
			# puts "edge : #{edge}"
			# vertices 	= edge.vertices
			# pt1 		= vertices[0].position
			# ents.erase_entities edge
			# line = ents.add_line vertices[0], vertices[1]
			# line.layer = layer_name
			edge.find_faces
		}
	end
	visible_layers.each{|layer| layer.visible=false}
	ents 		= model.entities
	puts "End #{ents.length}"
end 

two_d_to_3d 'Wall'

edge = fsel

v = fsel.vertices

edges 	= []
edges 	= ents.grep(Sketchup::Edge).select{|x| x.vertices.include?(v[0])}
edges << ents.grep(Sketchup::Edge).select{|x| x.vertices.include?(v[1])}
edges.uniq!

sel.add(edges)

entity = edge


entity.entities.intersect_with(true, entity.transformation, entity.entities.parent)















#----------------------------------------------------------------------------------------------------
layer_name = 'Wall'
model		= Sketchup.active_model
ents 		= model.entities
puts "start #{ents.length}"
layer_ents 	= ents.select{|ent| ent.layer.name == layer_name}

layer_ents.each{|edge|
	edge.find_faces
}

faces = Sketchup.active_model.entities.grep(Sketchup::Face)

faces.each{ |face|
	face_edges = face.edges
	delete_face = false
	face_edges.each { |edge|
		if edge.layer.name != 'Wall'
			delete_face = true
			break
		end
	}
	Sketchup.active_model.entities.erase_entities face if delete_face == true
}

faces = Sketchup.active_model.entities.grep(Sketchup::Face)

Sketchup.active_model.start_operation '2d_to_3d'

faces = Sketchup.active_model.entities.grep(Sketchup::Face)
timer_id = UI.start_timer(1, true) {
	if faces.empty?
		UI.stop_timer timer_id
	else
		x = faces.pop
		x.pushpull -2000.mm
	end	
}


Sketchup.active_model.abort_operation


