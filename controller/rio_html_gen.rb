



def generate_html_str
	in_h={"raw_material"=>"sadsad", "lamination_color/code"=>"sadas", "handler_type"=>"dasdg", "soft_close"=>"Yes", "finish_type"=>"Acrylic", "product_code"=>"TC_GDD_1000"}
	html_str = '<!DOCTYPE html>
				<html lang="en">
			
				<head>
				<meta charset="utf-8">
				<meta name="viewport" content="width=device-width, initial-scale=1">
					<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
					<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
					<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
					<script type="text/javascript" src="sketchhtml.js"></script>
					<style type="text/css">
						.sidebar {
						  margin: 0;
						  padding: 0;
						  width: 215px;
						  position: fixed;
						  height: 100%;
						  overflow: auto;
						  height: 800px;
						  border:1px solid black;
						}
						div.content {
						  margin-left: 200px;
						  padding: 1px 16px;
						  height: 800px;
						}
					</style>
					</head>'
				
	html_str += '<div class="container">
				  <div class="row">
						<div class="sidebar">
							<div class="form-group">
								<label>Client Name</label>
								<input type="text" class="form-control" >
							</div>
						</div>
						<div class="content">
							<div class="col-lg-12" style="border:1px solid black; height: 600px;">Image</div>
							<div class="col-lg-12" style="border:1px solid black; height: 200px;">
								<div id="load_comps">'
	table_str	=   '<table class="table">'
	in_h.each_pair{|key, value| 
						table_str += '<tr><td>'+ key + '</td><td>'+ value + '</td></tr>'
				}
	table_str	+=	'</table>'
	html_str 	+= table_str
	html_str 	+= '</div>
							</div>
						</div>
					</div>
				</div>'
	html_str += "</html>"
	File.write('E:/sample_html.html', html_str)
	puts html_str
end