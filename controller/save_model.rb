module RioModel
	def self.addObservers
		Sketchup.active_model.add_observer(RioModelObserver.new)
	end

  class RioModelObserver < Sketchup::ModelObserver
    def onSaveModel(model)
      puts "onSaveModel" + model.to_s
      Example.exportModel()
    end
  end

  def self.exportModel()
    return if @exporting

    puts "exportModel()"
    model = Sketchup.active_model

    @exporting = true
	puts "export : #{@exporting} " 
  ensure
	puts "ennsure : #{@exporting}"
    # Just in case model.export should raise an exception we guarranty the flag
    # is reset.
    @exporting = false
  end

end

RioModel.addObservers() 