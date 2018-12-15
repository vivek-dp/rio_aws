face = fsel
faces = []
face_edges = face.outer_loop.edges
face_edges.each { |edge|
	if edge.layer.name == 'Window'
		puts "Window edge1"
		face1_arr 		= edge.faces
		face1_arr.delete face 
		face1 = face1_arr[0] 
		faces << face1
		
		puts "face1 : #{face1}"
		face1_edges = face1.edges
		face1_edges.delete edge
		
		puts "face1_edges : #{face1_edges}"
		face2_edge = nil
		face1_edges.each{|face1_edge| puts face1_edge.layer.name;
			if face1_edge.layer.name == 'Window'
				puts "kdhfkjdh"
				face2_edge = face1_edge 
			end
		}
		if face2_edge
			inner_face 	= face2_edge.faces
			inner_face.delete face1
			face2_edges = inner_face[0].edges
			face2_edges.delete face2_edge
			third_edge 	= face2_edges.select {|ed| ed.layer.name == 'Window'}
			faces 		<< third_edge[0].faces
		end
	end
}
sel.add(faces)




@window_faces = []
Sketchup.active_model.entities.grep(Sketchup::Face).each{|face|
	face_edges = face.edges
	next if face.edges.length != 4
	@window_faces << face if face.edges.select{|ed| ed.layer.name == 'Wall'}.length == 2 && face.edges.select{|ed| ed.layer.name == 'Window'}.length == 2
}

#Send an Array with pushed elements ....use array.push
def find_adj_window_face arr=[]
	puts "arr : #{arr} #{arr.length}"
	if arr.length == 3
		return arr
	else
		face = arr.last
		face.edges.each{|edge|
			edge.faces.each{|face|
				if @window_faces.include?(face) && !arr.include?(face)
					arr.push(face)
					find_adj_window_face arr
				end
			}
		}
		return arr 
	end
end

=begin


def get_edges_connected edge
	verts 		= edge.vertices
	edge_arr	= []
	verts.each { |vert|
		edge_arr << vert.edges
	}
	edge_arr.uniq!
	edge_arr
end

face = fsel 
face_edges = face.outer_loop.edges

face_edges.each { |edge| 
	edge.add_attribute :rio_atts, 'wall_facing', 'inner' if edge.layer == 'Wall'
end
window_edges = []
face_edges.each { |edge|
	if edge.layer == 'Window'
		window_edge 	<< edge
		window_vertices = edge.vertices
		vert1			= window_vertices[0]
		vert2			= window_vertices[1]
		vert1.edges.each{|vedge| 
			if edge.layer == 'Wall' && edge.get_attribute :rio_atts, 'wall_facing' != 'inner'
				window_edge << vedge
				vedge_arr 	= get_edges_connected edges
				
				vedge_arr.each { |vvedge|
					if edge.layer == 'Wall' && edge.get_attribute :rio_atts, 'wall_facing' != 'inner'
						window_edge << vvedge
					elsif edge.layer == 'Window'
						window_edge << vvedge
					end
				}
			end
		}
	end
}



face = fsel
faces = []
face_edges = face.outer_loop.edges
face_edges.each { |edge|
	if edge.layer.name == 'Window'
		puts "Window edge1"
		face1_arr 		= edge.faces
		face1_arr.delete face 
		face1 = face1_arr[0] 
		faces << face1
		
		puts "face1 : #{face1}"
		face1_edges = face1.edges
		face1_edges.delete edge
		
		puts "face1_edges : #{face1_edges}"
		face2_edge = nil
		face1_edges.each{|face1_edge| puts face1_edge.layer.name;
			if face1_edge.layer.name == 'Window'
				puts "kdhfkjdh"
				face2_edge = face1_edge 
			end
		}
		if face2_edge
			inner_face 	= face2_edge.faces
			inner_face.delete face1
			face2_edges = inner_face.edges
			face2_edges.delete face2_edge
			third_edge 	= face2.edges.select {|ed| ed.layer.name == 'Window'}
			faces 		<< third_edge.faces
		end
	end
}
sel.add(faces)





edge 		= fsel
vertices	= edge.vertices

vertice
=end