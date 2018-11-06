#-------------------------------------------------------------------------------------
#
#Aws file list download and file download here
#
#---------------------------------------------------
require 'aws-sdk'

module RioAwsDownload
	KEY_FILE_LOC ||= ENV['TEMP']+'\.aws_cache'
	AWS_ASSETS_REGION ||= 'ap-south-1'
	
	def self.aws_credentials
		key_contents 	= File.read(KEY_FILE_LOC)
		keys 			= key_contents.split(',')
		Aws.config[:region] = AWS_ASSETS_REGION
		
		aws_credentials = {	'access_key_id' 	=> DP::simple_decrypt(keys[0]), 
							'secret_access_key' => DP::simple_decrypt(keys[1])}
		@s3_client  = Aws::S3::Client.new(
							access_key_id: aws_credentials['access_key_id'],
							secret_access_key: aws_credentials['secret_access_key']
						)
		
		aws_credentials
	end
	
	def self.get_client
		aws_credentials if @s3_client.nil?
		return @s3_client
	end
	
	#-------------------------------------------------------------------
	#Inputs :
	#------------
	#	folder_prefix 	: prefix of the folder_files
	#	bucket_name 	: defaults to test bucket
	#Return :
	#------------
	# 	folders and files in the current folder
	# For bucket folder : Use '' for bucket folder
	# Use folder prefix as 'folder_name/' for other folders
	#-------------------------------------------------------------------
	def self.get_folder_files folder_prefix, bucket_name='test.rio.assets' 
		s3_client	= get_client
		bucket_objs = @s3_client.list_objects_v2(
						{	bucket: bucket_name, 
							prefix: folder_prefix}
						)
		folder_files 	=[];
		current_files	= []
		if bucket_objs.contents.length > 1
			bucket_objs.contents.each{|x| folder_files << x.key}
			folder_files.each { |name|
				name.slice!(folder_prefix)
				fname = name.split('/')[0]
				current_files << fname unless current_files.include?(fname)
			}
			puts "current_files  : #{current_files}"
			unless current_files.empty?
				current_files.reject!{ |e| e.to_s.empty? } #removes nil and empty strings
				current_files.compact! 
			end
		end
		puts current_files
		
		#If skps are found
		skp_files={:skps=>[], :jpgs=>[], :prefix=>folder_prefix}
		current_files.each { |fname|
			skp_files[:skps] << fname if fname.end_with?('.skp')
			skp_files[:jpgs] << fname if fname.end_with?('.jpg')
		}
		puts "skps : #{skp_files}"
		
		if skp_files[:skps].empty?
			return current_files
		else
			return skp_files
		end
	end 
	
	#Only for skp....write separate method for other files
	def self.download_skp file_path, bucket_name='test.rio.assets' 
		s3_client	= get_client
		temp_dir 	= ENV['TEMP']
		file_name 	= File.basename(file_path)
		target_path = temp_dir + "\\" + file_name
		begin
			resp 	= s3_client.get_object(bucket: bucket_name, key: file_path, response_target: target_path)
			puts "File download success"
			return target_path
		rescue Aws::S3::Errors::NoSuchKey
			puts "File Does not exist"
			return nil
		end
		return nil
	end
	
	def self.download_jpg file_path, bucket_name='test.rio.assets' 
		s3_client	= get_client
		temp_dir	= ENV['TEMP']
		file_name 	= File.basename(file_path)
		target_path = temp_dir + "\\" + file_name
		begin
			resp 	= s3_client.get_object(bucket: bucket_name, key: file_path, response_target: target_path)
			puts "File download success"
			return target_path
		rescue Aws::S3::Errors::NoSuchKey
			puts "File Does not exist"
			return nil
		end
		return nil
	end
	
end
