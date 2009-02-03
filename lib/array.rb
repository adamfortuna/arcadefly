class Array
 def paginate(all = nil, options = {})
   options[:page] = (options[:page].to_i == 0) ? 1 : options[:page].to_i
   options[:per_page] = (options[:per_page].to_i == 0) ? 30 : options[:per_page].to_i    
   pagination_array = WillPaginate::Collection.new(options[:page], options[:per_page], self.size)
   start_index = pagination_array.offset
   end_index = start_index + (options[:per_page] - 1)
   array_to_concat = self[start_index..end_index]
   array_to_concat.nil? ? [] : pagination_array.concat(array_to_concat)
 end
end