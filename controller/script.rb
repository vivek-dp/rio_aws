load 'E:\git\rio_aws\controller\working_drawing.rb'
load 'E:\git\rio_aws\lib\code\dp_core.rb'
load 'E:\git\rio_aws\controller\import_component_aws.rb'


#WorkingDrawing::initialize

inp_h  = {
	"wall1"		=>"2196", 
	"wall2"		=>"2899", 
	"wheight"	=>"2720", 
	"wthick"	=>"0",
	"door"		=>	{
					"door_view"		=>"front",
					"door_position"	=>"610",
					"door_height"	=>"2100",
					"door_length"	=>"884"
					}
	}

DP::create_layers
DP::create_wall inp_h

model 	= Sketchup.active_model
cdef 	= model.definitions.load(target_path)




model 		= Sketchup.active_model

dir_path  	= 'E:/test/*.dwg'
files 		= Dir.glob(dir_path)
files.each { |dwg_path|

	res 		= model.import dwg_path, false

	definitions = Sketchup.active_model.definitions
	definitions.purge_unused

	skp_path 	= dwg_path.split('.')[0]+'.skp'
	Sketchup.active_model.save(skp_path)

	es.each{|x| es.erase_entities x }
}

carcass_skp = 'E:/test/BC_500.skp'
g_shutter_skp = 'E:/test/GSD_500.skp'
s_shutter_skp = 'E:/test/SSD_500.skp'

model 		= Sketchup.active_model
carcass_def = model.definitions.load(carcass_skp)
shutter_def	= model.definitions.load(g_shutter_skp)	
shutter_def	= model.definitions.load(s_shutter_skp)	

# trans 		= Geom::Transformation.new 
# shut_inst 	= Sketchup.active_model.active_entities.add_instance(shutter_def, trans)
# y_offset	= shut_inst.bounds.height

# trans 		= Geom::Transformation.new([0,y_offset,0]) 
# ccase_inst	=Sketchup.active_model.active_entities.add_instance(carcass_def, trans)

# group 		= Sketchup.active_model.entities.add_group

carcass_skp = 'E:/test1/BC_500.skp'
g_shutter_skp = 'E:/test/GSD_500.skp'
s_shutter_skp = 'E:/test1/SSD_500.skp'

carcass_skp 	= 'E:/test/WS_3_1000.skp'

s_shutter_skp = 'D:/aws_assets/shutter/SLD3_1000.skp'


defn 		= Sketchup.active_model.definitions['Chris']
		defn.instances.each{|inst|
			model.entities.erase_entities inst
		}

s_shutter_skp = 'E:/test/SLD3_1000.skp'
model 		= Sketchup.active_model
shutter_def	= model.definitions.load(s_shutter_skp)
model 		= Sketchup.active_model
definitions = model.definitions
defn		= definitions.add 'Defn#7'
trans 		= Geom::Transformation.new 
shut_inst 	= defn.entities.add_instance(shutter_def, trans)
y_offset	= shut_inst.bounds.height

Sketchup.active_model.entities.add_instance defn, ORIGIN




carcass_def = model.definitions.load(carcass_skp)
#shutter_def	= model.definitions.load(g_shutter_skp)	
shutter_def	= model.definitions.load(s_shutter_skp)

model 		= Sketchup.active_model
definitions = model.definitions
defn		= definitions.add 'Defn#7'
trans 		= Geom::Transformation.new 
shut_inst 	= defn.entities.add_instance(shutter_def, trans)
y_offset	= shut_inst.bounds.height
trans 		= Geom::Transformation.new([0,y_offset,0]) 
ccase_inst  = defn.entities.add_instance(carcass_def, trans)


defn = DP::create_carcass_definition carcass_skp, s_shutter_skp
es.add_instance(defn, Geom::Transformation.new)



hit_face = DP::get_view_face 'top'

nor_vector = Geom::Vector3d.new(0,0,1)
visible_comps = []
mod = Sketchup.active_model
es.grep(Sketchup::Face).each{|face|  
	hit_item = mod.raytest(face.bounds.center, nor_vector)
	if hit_item && hit_item[1][0] == hit_face
		visible_comps << face
		mod.selection.add face
	end
}

edges =[]
visible_comps.each{|face| edges<<face.outer_loop.edges}
edges.flatten.uniq.each{|edge| es.erase_entities if edge.faces > 1}


es.grep(Sketchup::Edge).each{|e| 
	if !e.deleted?
		es.erase_entities e if e.faces.empty?
	end
}

es.grep(Sketchup::Face).each{|face|
	arr = face.get_glued_instances
	if !arr.empty?
		puts "true"
		sel.add(face)
		break 
	else
		puts "false"
	end
}
puts "=========="



entities = Sketchup.active_model.active_entities
face = entities.add_face([0, 0, 0], [100, 0, 0], [100, 100, 0], [0, 100, 0])
face.reverse!
face

component = Sketchup.active_model.definitions.add("tester")
point1 = [10, 10, 0]
point2 = [20, 10, 0]
point3 = [20, 20, 0]
point4 = [10, 20, 0]
inner_face = component.entities.add_face(point1, point2, point3, point4)
component.behavior.is2d = true
inner_face.pushpull(-20, true)
instance = Sketchup.active_model.active_entities.add_instance(component, Geom::Transformation.new)
instance.glued_to = face
arr = [face, instance]


file_path 	= 'D:/aws_assets/Rio_standard_components.csv'
csv_arr 	= CSV.read(file_path)


carcass_path = 'D:/aws_assets/carcass/Wardrobe_hinged_door/WH_8001.skp'
shutter_path = 'D:/aws_assets/shutter/WSD_80_20.skp'


defn = DP::create_carcass_definition carcass_path, shutter_path, '1_100'


res = es.add_instance defn, ORIGIN




def save_dwg dir_path
	files 		= Dir.glob(dir_path+'/**/'+'*.DWG')
	files
end













































	