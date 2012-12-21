module Roovu
  class Engine < Rails::Engine
    ActiveRecord::Base.instance_eval do
      def token_input(column_name)
        cattr_accessor :roovu_token_input_field
        @@roovu_token_input_field = column_name
        instance_eval do
          def tokens(query)
            authors = where("#{@@roovu_token_input_field} like ?", "%#{query}%")
            if authors.empty?
              [{id: "<<<#{query}>>>", name: "New: \"#{query}\""}]
            else
              authors
            end
          end 

          def ids_from_tokens(tokens)
            tokens.gsub!(/<<<(.+?)>>>/) { create!("#{@@roovu_token_input_field}" => $1).id }
            tokens.split(',')
          end
        end
      end
    end    
  end
end