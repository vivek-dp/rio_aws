#-------------------------------------------------------------------
#
#	AWS Core library
#
#
#
#
#-------------------------------------------------------------------

module AwsLib
	def self.generate_aws_pwd
		o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
		return (0...8).map { o[rand(o.length)] }.join
	end
end