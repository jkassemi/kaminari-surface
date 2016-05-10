module Kaminari
  module Surface
    module PaginatableArrayExtension
      def limit(*_args)
        extend_state_to(super)
      end

      def offset(*_args)
        extend_state_to(super)
      end

      private

      def extend_state_to(target)
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
