require 'sqlite3'
module Decor_Standards
	@dbname = 'rio_test'
	@db = SQLite3::Database.new(@dbname)
	@table = 'rio_carcass_components'

	def self.get_main_space()
		getval = @db.execute("select distinct space from #{@table};")
		mainspace = ""
		getval.each {|val|
			spval = val[0].gsub("_", " ")
			mainspace += '<option value="'+val[0]+'">'+spval+'</option>'
		}
		mainspace1 = '<select class="ui dropdown" id="main-space" onchange="changeSpaceCategory()"><option value="0">Select...</option>'+mainspace+'</select>'
		return mainspace1
	end

	def self.create_carcass_database
		db_file_path= File.join(RIO_ROOT_PATH+"/"+"cache/Rio_standard_components.csv")
		if !File.exists?(db_file_path)
			#Download file
		end
		
		csv_arr 	= CSV.read(db_file_path)
		fields 		= csv_arr[0]
		
		#Delete table if already exists
		sql_query	= 'DROP TABLE IF EXISTS '+@table+';'
		@db.execute(sql_query);
		
		#Create fresh table
		sql_query 	= 'CREATE TABLE '+@table+' ('
		fields.each { |field|
			sql_query += field + ' TEXT,'
		}
		sql_query.chomp!(',');
		sql_query += ');'
		@db.execute(sql_query);
		
		
		#Add rows to database
		(1..csv_arr.length-1).each { |index|
			#puts index
			row_values = csv_arr[index].to_s
			row_values.slice!(0);	row_values.chomp!(']')
			#puts "row_values : #{row_values}"
			if fields.length == csv_arr[index].length
				sql_query 	= 'INSERT INTO '+@table+' ('+fields.join(',')+') VALUES ('+row_values+');'
				@db.execute(sql_query);
			else
				puts "Number of fields and columns not equal : #{row_values}"
			end
		}
	end

	def self.get_sub_space(input)
		getsub = @db.execute("select distinct category from #{@table} where space='#{input}';")
		subspace = ""
		getsub.each{|subc|
			spval = subc[0].gsub("_", " ")
			subspace += '<option value="'+subc[0]+'">'+spval+'</option>' 
		}
		subspace1 = '<select class="ui dropdown" id="sub-space" onchange="changesubSpace()"><option value="0">Select...</option>'+subspace+'</select>'
		return subspace1
	end

	def self.get_pro_code(inp)
		getco = @db.execute("select distinct carcass_code from #{@table} where space='#{inp[0]}' and category='#{inp[1]}';" )
		proco = ""
		getco.each{|cod|
			spval = cod[0].gsub("_", " ")
			proco += '<option value="'+cod[0]+'">'+spval+'</option>' 
		}
		proco1 = '<select class="ui dropdown" id="carcass-code" onchange="changeProCode()"><option value="0">Select...</option>'+proco+'</select>'
		return proco1
	end

	def self.get_datas(inp)
		valhash = []
		getdat = @db.execute("select type, solid, glass, alu, ply from #{@table} where space='#{inp[0]}' and category='#{inp[1]}' and carcass_code='#{inp[2]}';")
		valhash.push("type|"+getdat[0][0])
		valhash.push("solid|"+getdat[0][1])
		valhash.push("glass|"+getdat[0][2])
		valhash.push("alu|"+getdat[0][3])
		valhash.push("ply|"+getdat[0][4])
		# valhash["solid"] = getdat[0][1]
		# valhash["glass"] = getdat[0][2]
		# valhash["alu"] = getdat[0][3]
		# valhash["ply"] = getdat[0][4]

		return valhash
	end
end