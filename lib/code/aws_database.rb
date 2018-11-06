#----------------------------------------------------------------------
#
#Gem::install "ruby-mysql"
#
#
#-----------------------------------------------------------------------

require 'mysql'

module RioDbLib
	MYSQL_SERVER   ||= 'rio-testdb-inst.c9rntunmueu3.ap-south-1.rds.amazonaws.com'
	MYSQL_USER     ||= 'rioadmin'
	MYSQL_PASSWORD ||= 'adminrio'
	MYSQL_DATABASE ||= 'rio_test_db'
	MYSQL_PORT     ||= 3306

	def self.get_client
		sql_client = Mysql.real_connect(MYSQL_SERVER, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE, MYSQL_PORT)
		return sql_client
	end
	
	def self.run_query client, query_str
		resp = client.query query_str
		resp
	end
	
	def self.create_user email, name=''
		password 	= AwsLib::generate_pwd
		curr_date	= Time.now.strftime("%d-%m-%Y")
		u_name 		= name.split('@')[0] if name.empty?
		# begin
			# sql_query	= "insert into sketchup_users values('#{curr_date}', '#{u_name}', '#{email}', '#{password}', 'basic');"
			# sql_client  = get_client
			# resp 		= sql_client.query sql_query
			# return password
		# rescue Mysql::ServerError:
			# puts "Server Error"
		# end
	end
	
	def self.show_table
		client = get_client
		query_str = "select * from sketchup_users;"
		result = client.query query_str
		pp result.entries
	end
	
	def self.get_aws_keys sql_client, u_name
		sql_query 	= "SELECT access_key_id, secret_access_key from rio_aws_keys where user_name='#{u_name}'"
		resp		= sql_client.query sql_query
		keys 		= resp.entries[0]
		begin
			file_w = File.open(File.join(ENV['TEMP'], '.aws_cache'), 'w')
			file_w.write(DP::simple_encrypt(keys[0])+',')
			file_w.write(DP::simple_encrypt(keys[1]))
		rescue IOError => e
			puts "IOError"
		ensure
			file_w.close unless file_w.nil?
		end
	end
	
	def self.authenticate_aws_user u_name, password
		sql_client 	= get_client
		sql_query 	= "SELECT EXISTS (SELECT * FROM sketchup_users WHERE user_name='#{u_name}' AND pwd = '#{password}');"
		resp		= sql_client.query sql_query
		result 		= resp.entries
		return false if result.empty?
		result		= result.flatten.first.to_i == 1 ? true : false #Change this condition.......ooooooooh
		if result
			get_aws_keys sql_client, u_name
			return true
		end
		return false
	end
	
	#--------------------Sample modules---------------------------------------------------------------------------
	
	def self.insert_rows table_name='', row_arr=[]
		queries = []
		query << "create table if not exists sketchup_users (start_date date, user_name varchar(255),  email VARCHAR(320), pwd varchar(255), user_type varchar(255));"
		query << "insert into sketchup_users values('2018-10-30', 'test_user1', 'test_user1@decorpot.com', 'password1', 'basic');"
		query << "insert into sketchup_users values('2018-10-30', 'test_user2', 'test_user2@decorpot.com', 'password2', 'basic');"
		query << "insert into sketchup_users values('2018-10-31', 'test_user3', 'test_user3@decorpot.com', 'password3', 'basic');"
		query << "insert into sketchup_users values('2018-10-31', 'test_user4', 'test_user4@decorpot.com', 'password4', 'basic');"
	end
	
	def self.dummy_test
		puts "Dummy test code"
	end
end