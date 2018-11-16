require_relative 'tt_bounds.rb'

module Decor_Standards
	def self.decor_create_wall
		dialog = UI::HtmlDialog.new({:dialog_title=>"#{TITLE}", :preferences_key=>"com.sample.plugin", :scrollable=>true, :resizable=>true, :width=>600, :height=>420, :style=>UI::HtmlDialog::STYLE_DIALOG})
		html_path = File.join(WEBDIALOG_PATH, 'create_wall.html')
		dialog.set_file(html_path)
		dialog.set_position(0, 150)
		dialog.show

		dialog.add_action_callback("clickcancel") { |action_context, param1|
		  dialog.close
		}

		dialog.add_action_callback("submitval"){|ac, params|
			#puts JSON.parse(params)
			#puts "------------------------------"
			inp_h =	JSON.parse(params)
			return nil if inp_h.empty?
			#create walls
			DP::create_wall inp_h
		}
		
	end
end