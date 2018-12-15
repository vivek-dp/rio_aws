
load 'E:\git\rio_aws\controller\working_drawing.rb'
load 'E:\git\rio_aws\lib\code\dp_core.rb'
load 'E:\git\rio_aws\controller\import_component_aws.rb'
WorkingDrawing::initialize

cdef	= Sketchup.active_model.definitions['TC_GDD_1000']

@model = Sketchup.active_model
target_path = 'E:\git\rio_aws\assets\Dynamic-Components\Double Shutter wardrobe\Double Shutter Wardrobe.skp'
target_path = 'C:\Users\Decorpot-020\Desktop\Double Shutter Wardrobe1.skp'
cdef = @model.definitions.load(target_path)
comp 	= Sketchup.active_model.selection[0]
rotz 	= comp.transformation.rotz

#Sketchup.active_model.place_component fsel.definition
posn = 'right'
puts "posn : #{posn} : #{rotz}"


#create instance 
#orig_tr =Geom::Transformation.new([0,0,0])
#inst    =Sketchup.active_model.active_entities.add_instance cdef, orig_tr
#comp_tr = inst.transformation.origin
#inst.transform!(Geom::Transformation.new([-comp_tr.x,-comp_tr.y,-comp_tr.z]))
#
#inst.transform!(Geom::Transformation.new([0,-inst.bounds.corner(0).y,0]))

comp_origin = comp.transformation.origin
case posn
when 'left'
	case rotz
	when 0
#        orig_tr =Geom::Transformation.new([0,0,0])
#        inst    =Sketchup.active_model.active_entities.add_instance cdef, orig_tr
#        inst.transform!(orig_tr)
        
		trans   = Geom::Transformation.new([comp_origin.x-cdef.bounds.width, comp_origin.y, comp_origin.z])
		Sketchup.active_model.active_entities.add_instance cdef, trans
        #inst.transform!(trans)
	when 90
		tr      = Geom::Transformation.rotation([0, 0, 0], Z_AXIS, rotz.degrees)
		inst    = Sketchup.active_model.active_entities.add_instance cdef, tr
		trans   = Geom::Transformation.new([comp_origin.x, comp_origin.y-cdef.bounds.width, comp_origin.z])
		inst.transform!(trans)
	when 180, -180
		tr      = Geom::Transformation.rotation([0, 0, 0], Z_AXIS, rotz.degrees)
		inst    = Sketchup.active_model.active_entities.add_instance cdef, tr
		trans = Geom::Transformation.new([comp_origin.x+cdef.bounds.width, comp_origin.y, comp_origin.z])
		inst.transform!(trans)
	when -90
		tr      = Geom::Transformation.rotation([0, 0, 0], Z_AXIS, rotz.degrees)
		inst    = Sketchup.active_model.active_entities.add_instance cdef, tr
		trans = Geom::Transformation.new([comp_origin.x, comp_origin.y+cdef.bounds.width, comp_origin.z])
		inst.transform!(trans)
	end
when 'right'
	case rotz
	when 0
		trans = Geom::Transformation.new([comp_origin.x+cdef.bounds.width, comp_origin.y, comp_origin.z])
		Sketchup.active_model.active_entities.add_instance cdef, trans
	when 90
		tr      = Geom::Transformation.rotation([0, 0, 0], Z_AXIS, rotz.degrees)
		inst    = Sketchup.active_model.active_entities.add_instance cdef, tr
		trans   = Geom::Transformation.new([comp_origin.x, comp_origin.y+comp.bounds.height, comp_origin.z])
		inst.transform!(trans)
	when 180, -180
		tr      = Geom::Transformation.rotation([0, 0, 0], Z_AXIS, rotz.degrees)
		inst    = Sketchup.active_model.active_entities.add_instance cdef, tr
		trans = Geom::Transformation.new([comp_origin.x-cdef.bounds.width, comp_origin.y, comp_origin.z])
		inst.transform!(trans)
	when -90
		tr      = Geom::Transformation.rotation([0, 0, 0], Z_AXIS, rotz.degrees)
		inst    = Sketchup.active_model.active_entities.add_instance cdef, tr
		trans = Geom::Transformation.new([comp_origin.x, comp_origin.y-comp.bounds.height, comp_origin.z])
		inst.transform!(trans)
	end
when 'top'
	case rotz
	when 0
		trans = Geom::Transformation.new([comp_origin.x, comp_origin.y, comp_origin.z+comp.bounds.depth])
		Sketchup.active_model.active_entities.add_instance cdef, trans
	when 90
		tr      = Geom::Transformation.rotation([0, 0, 0], Z_AXIS, rotz.degrees)
		inst    = Sketchup.active_model.active_entities.add_instance cdef, tr
		trans   = Geom::Transformation.new([comp_origin.x, comp_origin.y, comp_origin.z+comp.bounds.depth])
		inst.transform!(trans)
	when 180, -180
		tr      = Geom::Transformation.rotation([0, 0, 0], Z_AXIS, rotz.degrees)
		inst    = Sketchup.active_model.active_entities.add_instance cdef, tr
		trans = Geom::Transformation.new([comp_origin.x, comp_origin.y, comp_origin.z+comp.bounds.depth])
		inst.transform!(trans)
	when -90
		tr      = Geom::Transformation.rotation([0, 0, 0], Z_AXIS, rotz.degrees)
		inst    = Sketchup.active_model.active_entities.add_instance cdef, tr
		trans = Geom::Transformation.new([comp_origin.x, comp_origin.y, comp_origin.z+comp.bounds.depth])
		inst.transform!(trans)
	end
end