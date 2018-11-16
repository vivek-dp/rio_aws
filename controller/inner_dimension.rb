def get_front_bounds comp
	
	rotz = comp.transformation.rotz
	
	case rotz
	when 0
		indexes = [0,1,4,5]
	when 90
		indexes = [1,3,5,7]
	when 180, -180
		indexes = [2,3,6,7]
	when -90
		indexes = [0,2,4,6]
	end
	
	pts_a = []
	indexes.each{|i| pts_a << TT::Bounds.point(comp.bounds, i)}
	#pts_a
	
	x_pvector = Geom::Vector3d.new(1,0,0)
	x_nvector = Geom::Vector3d.new(-1,0,0)
	
	y_pvector = Geom::Vector3d.new(0,1,0)
	y_nvector = Geom::Vector3d.new(0,-1,0)
	
	z_pvector = Geom::Vector3d.new(0,0,100)
	z_nvector = Geom::Vector3d.new(0,0,-1)
	
	dim_off = 3*rand
	pts = []
	#pts_a.each{
		case rotz
		when 0
			pts << [pts_a[0].offset(x_pvector, dim_off) , pts_a[2].offset(x_pvector, dim_off)]
			pts << [pts_a[1].offset(x_nvector, dim_off) , pts_a[3].offset(x_nvector, dim_off)]
		when 90
			pts << [pts_a[0].offset(y_pvector, dim_off) , pts_a[2].offset(y_pvector, dim_off)]
			pts << [pts_a[1].offset(y_nvector, dim_off) , pts_a[3].offset(y_nvector, dim_off)]
		when 180, -180
			pts << [pts_a[0].offset(x_pvector, dim_off) , pts_a[2].offset(x_pvector, dim_off)]
			pts << [pts_a[1].offset(x_nvector, dim_off) , pts_a[3].offset(x_nvector, dim_off)]
		when -90
			pts << [pts_a[0].offset(y_pvector, dim_off) , pts_a[2].offset(y_pvector, dim_off)]
			pts << [pts_a[1].offset(y_nvector, dim_off) , pts_a[3].offset(y_nvector, dim_off)]
		end
	#}
	puts pts
	pts.each{|dim_pt|
		puts "dim_pt.. : #{dim_pt}"
		pt1 	= dim_pt[0]
		#x
		pt1.x+=1
		pt2 	= dim_pt[1]
		pt2.x+=1
		
		#Sketchup.active_model.entities.add_line pt1, pt2
		dim_l 	= Sketchup.active_model.entities.add_dimension_linear(pt1, pt2, y_pvector)
		#dim_l.material.color = 'red'
		#dim_l
		puts "dim_l"+dim_l.to_s
	}
end

# comp	= fsel
# pts 	= get_front_points comp
# dim_off = 4*rand



