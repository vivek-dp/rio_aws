options ={"main-category"=>"Kitchen_Base_Unit",
 "sub-category"=>"Base_Single_Door",
 "carcass-code"=>"BC_500",
 "shutter-code"=>"SD_50_70",
 "door-type"=>"Single",
 "shutter-type"=>"solid",
 "shutter-origin"=>"1_1"}
 
 

 
load 'E:\git\rio_aws\lib\code\aws_downloader.rb'
load 'E:\git\rio_aws\controller\import_component_aws.rb'

require 'rubygems'


def install_gem(name)
	begin
	  require name
	rescue LoadError
	  begin
		Gem::install name
	  rescue Gem::InstallError => error
		puts "ERROR! RubyZip could not be installed."
		puts error.message
	  else
		require name
	  end
	end
end