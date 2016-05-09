module Kaminari
  module Surface
    module PageScopeMethods
      def per(num)
        fail ArgumentError if defined?(@_surface_value)
        @_per_value = num
        extend_state_to(super)
      end

      def padding(num)
        fail ArgumentError if defined?(@_surface_value)
        _padding = num
        extend_state_to(super)
      end

      def surface(num)
        remaining = total_count - (offset_value + per_value)

        if remaining > 0 && remaining <= num
          result = limit(limit_value + remaining).offset(offset_value)
        else
          result = self
        end

        @_surface_value = num

        extend_state_to(result.extend(Kaminari::PageScopeMethods))
      end

      def current_page
        offset_without_padding = offset_value
        offset_without_padding -= @_padding if padding_enabled?
        offset_without_padding = 0 if offset_without_padding < 0

        (offset_without_padding / per_value) + 1
      end

      def total_pages
        count_without_padding = total_count
        count_without_padding -= @_padding if padding_enabled?
        count_without_padding = 0 if count_without_padding < 0

        total_pages_count = ((count_without_padding - surface_value).to_f / per_value).ceil

        if max_pages.present? && max_pages < total_pages_count
          max_pages
        else
          total_pages_count
        end
      end

      def num_pages
        total_pages
      end

      def per_value
        (@_per_value || default_per_page).to_i
      end

      def surface_value
        (@_surface_value || 0).to_i
      end

      private

      def padding_enabled?
        defined?(@_padding) && @_padding
      end

      def extend_state_to(target)
        target.instance_variable_set(:@_per_value, @_per_value)
        target.instance_variable_set(:@_surface_value, @_surface_value)
        target.instance_variable_set(:@_padding, @_padding)
        target
      end
    end
  end
end
