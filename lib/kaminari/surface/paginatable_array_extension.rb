module Kaminari
  module Surface
    module PaginatableArrayExtension
      def limit(*_args)
        copy_attrs(super)
      end

      def offset(*_args)
        copy_attrs(super)
      end

      private

      def copy_attrs(target)
        if defined?(@_per_value)
          target.instance_variable_set(:@_per_value, @_per_value)
        end

        if defined?(@_surface_value)
          target.instance_variable_set(:@_surface_value, @_surface_value)
        end

        target
      end
    end
  end
end
