module RioModel
	AWS_ASSETS_REGION ||= 'ap-south-1'
	def self.addObservers
		Sketchup.active_model.add_observer(RioModelObserver.new)
	end

	class RioModelObserver < Sketchup::ModelObserver
		def onSaveModel(model)
			puts "onSaveModel" + model.to_s
			RioModel.exportModel()
		end
	end

	def self.exportModel()
		return if @exporting

		puts "exportModel()"
		model 		= Sketchup.active_model
		s3_client 	= RioAwsDownload::get_client
		
		file_path 	= DP::current_file_path
		target_path = "folder3/"+File.basename(file_path) #Change to user_name
		puts Time.now
		
		resp = s3_client.put_object({
			body: file_path, 
			bucket: "test.rio.assets", 
			key: target_path, 
		})	

		puts Time.now if resp
		puts "resp : #{resp}"

		@exporting = true
	ensure
		@exporting = false
	end

end

RioModel.addObservers() 