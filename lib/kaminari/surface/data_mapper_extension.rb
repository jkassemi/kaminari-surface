module Kaminari
  module Surface
    module DataMapperExtension
      module Paginating
        def all(options={})
          super.extend Paginating
        end

        def per(num)
          super.extend Paginating
        end
      end
    end
  end
end
