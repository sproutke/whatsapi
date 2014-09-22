require "whatsapi/version"
require 'whatsapi/bin_tree'
module Whatsapi
	class BinTreeWriter < BinTree
		attr_accessor :output

		def initialize
			@output = ""
		end

		def start_stream domain, resource
			attributes = {}
			header = "WA"
			header += write_int8(1)
			header += write_int8(4)

			attributes['to'] = domain
			attributes['resource'] = resource

			write_list_start(attributes.length * 2 + 1)

			@output += "\x01"
			write_attributes(attributes)
			result = header + flush_buffer 
			result
		end

		def flush_buffer
			@output = ""
		end

		def write_list_start count
			if count == 0
				@output += "\x00";
			elsif count < 256
				@output += "\xf8" + count.chr(Encoding::UTF_8)
			else
				@output += "\xf9" + write_int16(count)
			end
		end

		def write_int8 int
			int.chr(Encoding::UTF_8)
		end

		def clear_output
			@output = ""
		end

		def write_int16 int
			result = ((int & 0xff00) >> 8).chr(Encoding::UTF_8)
			result += ((int & 0x00ff) >> 0).chr(Encoding::UTF_8)
			return result
		end
	end
end