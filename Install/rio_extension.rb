require 'sketchup.rb'
require 'extensions.rb'

path = File.dirname(__FILE__)

folder_path = File.join(path, 'rio')

#Change here for access
folder_path		= 'C:/RioSTD'
folder_path 	= 'E:/git/rio_aws'

loader 			= File.join(folder_path, 'loader.rb')
title 			= 'Rio Tool'
ext 			= SketchupExtension.new(title, loader)
ext.version 	= '0.0.2'
ext.copyright 	= 'Public Domain - 2018'
ext.creator 	= 'Decorpot Development Team'
Sketchup.register_extension(ext, true)