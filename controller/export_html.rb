module Decor_Standards
	def self.export_index(input)
		# puts input
		if input['draw'].length != 0
			self.show_work_drawing(input['draw'])
		end

		if input['views'].length != 0
			self.export_html(input['views'])
		end
		return 1
	end

	def self.show_work_drawing(input)
		# puts "draw------------",input
	end

	def self.generate_html
		dict_name = 'carcase_spec'
		mainarr = []
		Sketchup.active_model.entities.each{|comp|
			if comp.attribute_dictionaries[dict_name] != nil
				ahash = {}
				comp.attribute_dictionaries[dict_name].each{|key, val|
					if !val.empty?
						ahash[key] = val
					end
				}
			end
			if !ahash.nil?
				mainarr.push(ahash)
			end
		}
		# self.generate_html_str(mainarr)
		return mainarr
	end

	def self.get_attributes(vi)
		dict_name = 'carcase_spec'
		# S ||= Sketchup.active_model.selection
		newh = [{"C#1"=>S[0],"C#2"=>S[1],"C#3"=>S[2],"C#4"=>S[3],"C#5"=>S[4],"C#6"=>S[5],"C#7"=>S[6]},'C:/RioSTD/cache/left.jpg']
		mainarr = []
		mainh = {}
		newh[0].keys.each{|x| 
			shash = {}
			newh[0][x].attribute_dictionaries[dict_name].each{|key, val|
				shash[key] = val
			}
			shash["id"] = x
			mainarr.push(shash)
		}
		mainh["attributes"] = mainarr
		mainh["image"] = newh[1]
		 return mainh
	end

	def self.export_html(input)
		@views = input

		html = '<!DOCTYPE html>
							<html lang="en">
							<head>
								<meta charset="utf-8">
								<meta name="viewport" content="width=device-width, initial-scale=1">
								<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
								<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
								<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

								<style type="text/css">
									.procode {font-weight:bold;}
									.vname {padding: 5px 17px 5px 10px; font-weight: bold;text-align: center; text-decoration: underline;}
									body {font-size: 12px;}
									.table-bordered > thead > tr > th {border:1px solid black !important;}
									.table-bordered > tbody > tr > td {border:1px solid black !important;}
									.pagebreak { page-break-before: always; }
									.btm-border {border-bottom: 1px solid black; padding: 10px 5px 10px 5px;}
									.clinote {color: red !important; padding: 10px 0px 10px 0px; font-weight: bold;}
									.page-break {page-break-before:always !important;}
									.chead {color:#d60000 !important;}
								</style>
							</head>

							<body>
								<div class="container-fluid">'
									@views.each{|vi|
										@skps = self.get_attributes(vi)
		html += '<section style="border-style: double;">
									<div style="padding: 5px;">
										<table class="table table-bordered">
											<tbody>
												<tr>
													<td width="10%" style="padding: 0px;">
														<div class="col-lg-12">
															<div class="vname">Elevation&nbsp;'+vi.capitalize+'</div>
														</div>
														<div class="col-lg-12 btm-border">
															<label>Client Name:</label>
															<div class="cliname">Siva S</div>
														</div>
														<div class="col-lg-12 btm-border">
															<label>Client ID:</label>
															<div class="cliname">BUI-26541</div>
														</div>
														<div class="col-lg-12 btm-border">
															<label>Room Name:</label>
															<div class="cliname">Kitchen</div>
														</div>
														<div class="col-lg-12 btm-border">
															<label>Date:</label>
															<div class="cliname">Nov 13, 2018</div>
														</div>
														<div class="col-lg-12">
															<div class="clinote">NOTE:</div>
														</div>
													</td>
													<td width="80%">
														<div class="pull-right"><img src="'+@skps['image']+'"></div>
													</td>
												</tr>
											</ttbody>
										</table>
										<div class="row">
											<div class="col-lg-12">
												<table class="table table-bordered">
													<thead>
														<tr>
															<th class="chead">ID</th>
															<th class="chead">Product Code</th>
															<th class="chead">Product Name</th>
															<th class="chead">Raw Material</th>
															<th class="chead">Laminate Color/Code</th>
															<th class="chead">Handles</th>
															<th class="chead">Soft Close</th>
															<th class="chead">Finish Type</th>
														</tr>
													</thead>
													<tbody>'
													@skps['attributes'].each{|skp|
		html +=						'<tr>
															<td><div class="procode">'+skp["id"]+'</div></td>
															<td><div class="procode">'+skp["attr_product_code"]+'</div></td>
															<td><div class="procode">'+skp["attr_product_name"]+'</div></td>
															<td>'+skp["attr_raw_material"]+'</td>
															<td>'+skp["attr_lamination_color_code"]+'</td>
															<td>'+skp["attr_handles_type"]+'</td>
															<td>'+skp["attr_soft_close"].capitalize+'</td>
															<td>'+skp["attr_finish_type"].capitalize+'</td>
														</tr>'
													}
		html +=					'</tbody>
												</table>
											</div>
										</div>
									</div>
								</section>
								<div class="page-break"></div>'
								}
		html+=	'</div>
							</body>
							</html>'
		File.write('C:/Users/Admin/Desktop/new_html.html', html)
		# UI.messagebox 'HTML Generated Successfully!', MB_OK
		return
	end
end