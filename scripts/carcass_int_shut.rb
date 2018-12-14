model 			= Sketchup.active_model 

carcass 		= 'Wardrobe_Sliding_Door'
carcass_name	= 'WS_2_600'
carcass_path 	= 'D:/aws_assets/carcass/'+carcass+'/'+carcass_name+'.skp'
lhs_int 		= '2INT_6LHS_600'
rhs_int			= '2INT_6RHS_600'


carcass_name 	= 'WS_3_900'
lhs_int 		= '3INT_2LHS_900'
rhs_int			= '3INT_2RHS_900'
lhs_rhs_int 	= '3INT_2LHS_RHS_900'

shutter_name	= 'SLD3_900'

defn_name	= carcass_name + shutter_name
model 		= Sketchup.active_model
definitions = model.definitions
defn		= definitions.add defn_name

#defn = Sketchup.active_model

carcass_path 	= 'D:/aws_assets/carcass/'+carcass+'/'+carcass_name+'.skp'
shutter_path 	= 'D:/aws_assets/shutter/'+shutter_name+'.skp'
lhs_path 		= 'D:/aws_assets/internal/'+lhs_int+'.skp'
rhs_path 		= 'D:/aws_assets/internal/'+rhs_int+'.skp'
lhs_rhs_path 	= 'D:/aws_assets/internal/'+lhs_rhs_int+'.skp'

carcass_def = model.definitions.load(carcass_path)
shutter_def = model.definitions.load(shutter_path)

lhs_def		= model.definitions.load(lhs_path)
rhs_def		= model.definitions.load(rhs_path)
lhs_rhs_def = model.definitions.load(lhs_rhs_path)


files = Dir.glob('D:/aws_assets/internal/'+'*.dwg')
files.each{|x| puts x if x.include?('600')}

inst 			= es.add_instance shutter_def, ORIGIN
shutter_height 	= inst.bounds.height
shutter_depth 	= inst.bounds.depth
es.erase_entities inst

inst 		= es.add_instance rhs_def, ORIGIN
lhs_height 	= inst.bounds.height
lhs_depth 	= inst.bounds.depth
es.erase_entities inst

pt 		= Geom::Point3d.new(0, 0, 0)
pt.y 	= shutter_height 

res 		= defn.entities.add_instance carcass_def, pt
ref_point 	= res.bounds.corner(6)

doors = carcass_name.split('_')[1].to_i
width = carcass_name.split('_')[2].to_i.mm
ply_width = 18.mm

trans_internal = Geom::Transformation.new([ref_point.x+18.mm, ref_point.y-lhs_height-20.mm, ref_point.z-lhs_depth-38.mm])
res 		= defn.entities.add_instance rhs_def, trans_internal

model = Sketchup.active_model
view = model.active_view
refreshed_view = view.refresh
sleep 1

if doors == 2
	x_next_offset = (width + (ply_width/2))
	trans_internal = Geom::Transformation.new([ref_point.x+x_next_offset, ref_point.y-lhs_height-20.mm, ref_point.z-lhs_depth-38.mm])
	res 		= defn.entities.add_instance lhs_def, trans_internal
else
	x_next_offset 	= (width + ply_width)
	trans_internal 	= Geom::Transformation.new([ref_point.x+x_next_offset, ref_point.y-lhs_height-20.mm, ref_point.z-lhs_depth-38.mm])
	res 			= defn.entities.add_instance lhs_rhs_def, trans_internal
	
	
	model = Sketchup.active_model
	view = model.active_view
	refreshed_view = view.refresh
	sleep 1
	x_next_offset	= 2*width + ply_width
	
	#x_next_offset 	= ply_width
	trans_internal 	= Geom::Transformation.new([ref_point.x+(x_next_offset), ref_point.y-lhs_height-20.mm, ref_point.z-lhs_depth-38.mm])
	res 			= defn.entities.add_instance lhs_def, trans_internal
end

model = Sketchup.active_model
view = model.active_view
refreshed_view = view.refresh
sleep 1
inst = defn.entities.add_instance shutter_def, ORIGIN

unless defn.is_a?(Sketchup::Model)
	Sketchup.active_model.entities.add_instance defn, ORIGIN
end

#res = es.add_instance carcass_def, ORIGIN


#carcass_path = 'D:/rio-sub-components/shutter/AF_40_19.skp'
#carcass_def = model.definitions.load(carcass_path)
#inst = mod.entities.add_instance carcass_def, ORIGIN