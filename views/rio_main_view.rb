module Decor_Standards
	@@rio_tools_menu = false
	puts "@@rio_tools_menu : #{@@rio_tools_menu}"
	if @@rio_tools_menu
		@@rio_tools_menu = true
		puts "@@rio_tools_menu not added"
		UI.add_context_menu_handler do |menu|
			rbm = menu.add_submenu("Rio Tools")
			rbm.add_item("Add Component") { self.add_comp_fom_menu }
			rbm.add_item("Add Attribute") { self.add_attr_from_menu }
		end
	end

	def self.rio_index(*args)
		puts "1212",$rio_dialog
	end
	def self.get_rio_dialog
		$rio_dialog
	end

	def self.add_comp_fom_menu
		$rio_dialog.show
		js_cpage = "document.getElementById('add_comp').click();"
		$rio_dialog.execute_script(js_cpage)
	end

	def self.add_attr_from_menu
		$rio_dialog.show
		js_page = "document.getElementById('add_attr').click();"
		$rio_dialog.execute_script(js_page)
	end

	def self.set_window(inp_page, key, value)
		# js_upt = "passUptVal("+inp_page+','+key+','+value+")"
		 js_cpage = "document.getElementById('#{inp_page}').click();"
		# js_upt = "passUptVal(1)"
		 $rio_dialog.execute_script(js_cpage)
		sleep 0.1
		js_1page = "document.getElementById('#{key}').value='#{value}';"
		$rio_dialog.execute_script(js_1page)
	end

	def self.decor_index(*args)
		$rio_dialog = UI::HtmlDialog.new({:dialog_title=>"RioSTD", :preferences_key=>"com.sample.plugin", :scrollable=>true, :resizable=>true, :width=>600, :height=>700, :style=>UI::HtmlDialog::STYLE_DIALOG})
		html_path = File.join(RIO_ROOT_PATH, 'webpages/index.html')
		$rio_dialog.set_file(html_path)
		$rio_dialog.set_position(0, 80)
		$rio_dialog.show

		@page = []
		$rio_dialog.add_action_callback("callpage"){|a, b|
			@page.push(page)
			js_cpage = "passPageToJs("+@page.to_s+")"
			$rio_dialog.execute_script(js_cpage)

			js_cpage = "document.getElementById('bill_of_material').innerHTML='<h4>Bill of Material</h4>';"

			js_cpage += "document.getElementById('#{input_value}').click();"
			js_cpage += "document.getElementById('autoplace').checked=checked;"
			# $rio_dialog.execute_script(js_cpage);			
			$rio_dialog.execute_script(js_cpage);			


		}

		$rio_dialog.add_action_callback("submitval"){|dialog, params|
			input = JSON.parse(params)
			DP::create_wall input
			js_done = "hideLoad(1)"
			$rio_dialog.execute_script(js_done)
		}

		$rio_dialog.add_action_callback("loadmaincatagory"){|a, b|
			mainarr = []
			value = self.load_main_category()
			mainarr.push(value)
			js_maincat = "passMainCategoryToJs("+mainarr.to_s+")"
			$rio_dialog.execute_script(js_maincat)
		}

		$rio_dialog.add_action_callback("get_category"){|a, b|
			subarr = []
			subval = self.load_sub_category(b.to_s)
			subarr.push(subval)
			js_subcat = "passSubCategoryToJs("+subarr.to_s+")"
			$rio_dialog.execute_script(js_subcat)
		}

		$rio_dialog.add_action_callback("load-sketchupfile"){|a, b|
			cat = b.split(",")
			skpval = self.load_skp_file(cat)
			js_command = "passSkpToJavascript("+ skpval.to_s + ")"
			$rio_dialog.execute_script(js_command)
		}

		$rio_dialog.add_action_callback("place_model"){|a, b|
			self.place_Defcomponent(b)
		}

		$rio_dialog.add_action_callback("loaddatas"){|a, b|
			getval = self.get_attr_value()
			js_maincat = "passValToJs("+getval.to_s+")"
			$rio_dialog.execute_script(js_maincat)
		}

		$rio_dialog.add_action_callback("upd_attribute"){|a, b|
			uptval = self.update_attr(b)
			if uptval.to_i == 1
				js_maincat = "passUpdateToJs(1)"
	 			$rio_dialog.execute_script(js_maincat)
	 		else
	 		end
		}

		$rio_dialog.add_action_callback("exporthtml"){|a, b|
			inp_h =	JSON.parse(b)
			passval = self.export_index(inp_h)
			js_exped = "htmlDone(1)"
			$rio_dialog.execute_script(js_exped)
		}

		$rio_dialog.add_action_callback("open_modal"){|a, b|
			inpval = b.split(",")
			webdialog = UI::WebDialog.new("#{inpval[0]}", true, "#{inpval[0]}", 600, 600, 10, 100, true)
			webdialog.set_url(inpval[1])
			webdialog.show
		}

		$rio_dialog.add_action_callback("getspace"){|a, b|
			mainsp = []
			maincat = self.get_main_space()
			mainsp.push(maincat)
			js_sp = "passSpace("+mainsp.to_s+")"
			$rio_dialog.execute_script(js_sp)
		}

		$rio_dialog.add_action_callback("get_cat"){|a, b|
			subcat = []
			subsp = self.get_sub_space(b)
			subcat.push(subsp)
			js_sub = "passsubCat("+subcat.to_s+")"
			$rio_dialog.execute_script(js_sub)
		}

		$rio_dialog.add_action_callback("load-code"){|a, b|
			sp = b.split(",")
			parr = []
			getcode = self.get_pro_code(sp)
			parr.push(getcode)
			js_pro = "passCarCass("+parr.to_s+")"
			$rio_dialog.execute_script(js_pro)
		}

		$rio_dialog.add_action_callback("load-datas"){|a, b|
			spinp = b.split(",")
			getval = self.get_datas(spinp)
			js_data = "passDataVal("+getval.to_s+")"
			$rio_dialog.execute_script(js_data)
		}

		$rio_dialog.add_action_callback("send_compval"){|a, b|
			inph =	JSON.parse(b)
			puts inph
			js_sent = "sentcompVal(1)"
			$rio_dialog.execute_script(js_sent)
		}

	end
end

