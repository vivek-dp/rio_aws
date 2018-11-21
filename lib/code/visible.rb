#Two functions

def find_adjacent_comps comps, comp
	adj_comps 	= []

	comps.each { |item|
		xn = comp.bounds.intersect item.bounds
		if ((xn.width + xn.depth + xn.height) != 0)
			adj_comps << item
			
		end
	}
	adj_comps
end

Sketchup.active_model.selection.clear


#----------------------------------------
def get_visible_sides comp
	comps 		= Sketchup.active_model.entities.grep(Sketchup::ComponentInstance)
	room_comp 	= comps.select{|x| x.definition.name=='room_bounds'}
	comps 		= comps - room_comp

	adj_comps	=find_adjacent_comps comps-[comp], comp;
	rotz 		= comp.transformation.rotz
	left_view	= true
	right_view	= true
	top_view	= true

	comp_pts 	= []
	puts "adj_comps : #{adj_comps}"
	(0..7).each{|x| comp_pts << comp.bounds.corner(x).to_s}
	case rotz
	when 0
		puts "0....."
		right_pts 	= [comp_pts[0],	comp_pts[2], comp_pts[4], comp_pts[6]]
		left_pts	= [comp_pts[1],	comp_pts[3], comp_pts[5], comp_pts[7]]
		top_pts		= [comp_pts[4],	comp_pts[5], comp_pts[6], comp_pts[7]]
		adj_comps.each{|item|
			Sketchup.active_model.selection.add(item)
			xn 		= comp.bounds.intersect item.bounds
			xn_pts 	= [];(0..7).each{|x| xn_pts<<xn.corner(x).to_s}	

			right_view	= false if (xn_pts&right_pts).length > 2
			left_view	= false if (xn_pts&left_pts).length > 2
			top_view 	= false if (xn_pts&top_pts).length > 2
		}
	when 90
		puts "90"
		right_pts 	= [comp_pts[0],comp_pts[1],comp_pts[4],comp_pts[5]]
		left_pts	= [comp_pts[2],comp_pts[3],comp_pts[6],comp_pts[7]]
		top_pts		= [comp_pts[4],	comp_pts[5], comp_pts[6], comp_pts[7]]
		adj_comps.each{|item|
			Sketchup.active_model.selection.add(item)
			xn 		= comp.bounds.intersect item.bounds
			xn_pts 	= [];(0..7).each{|x| xn_pts<<xn.corner(x).to_s}	

			right_view	= false if (xn_pts&right_pts).length > 2
			left_view	= false if (xn_pts&left_pts).length > 2
			top_view 	= false if (xn_pts&top_pts).length > 2
		}
	when 180, -180
		left_pts 	= [comp_pts[0],comp_pts[2],comp_pts[4],comp_pts[6]]
		right_pts	= [comp_pts[1],comp_pts[3],comp_pts[5],comp_pts[7]]
		top_pts		= [comp_pts[4],	comp_pts[5], comp_pts[6], comp_pts[7]]
		adj_comps.each{|item|
			Sketchup.active_model.selection.add(item)
			xn 		= comp.bounds.intersect item.bounds
			xn_pts 	= [];(0..7).each{|x| xn_pts<<xn.corner(x).to_s}
			
			right_view	= false if (xn_pts&right_pts).length > 2
			left_view	= false if (xn_pts&left_pts).length > 2
			top_view 	= false if (xn_pts&top_pts).length > 2
		}
	when -90
		puts "-90"
		left_pts 	= [comp_pts[0],comp_pts[1],comp_pts[4],comp_pts[5]]
		right_pts	= [comp_pts[2],comp_pts[3],comp_pts[6],comp_pts[7]]
		top_pts		= [comp_pts[4],	comp_pts[5], comp_pts[6], comp_pts[7]]
		adj_comps.each{|item|
			Sketchup.active_model.selection.add(item)
			xn 		= comp.bounds.intersect item.bounds
			xn_pts 	= [];(0..7).each{|x| xn_pts<<xn.corner(x).to_s}
			
			right_view	= false if (xn_pts&right_pts).length > 2
			left_view	= false if (xn_pts&left_pts).length > 2
			top_view 	= false if (xn_pts&top_pts).length > 2
		}
	end	

	puts "Visible views"
	puts "left_view : #{left_view}"
	puts "right_view : #{right_view}"
	puts "Top View : #{top_view}"
	return left_view, right_view, top_view
end





