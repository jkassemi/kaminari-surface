require 'kaminari/config'

module Kaminari
  class Configuration
    config_accessor :default_surface
  end

  configure do |config|
    config.default_surface = 50
  end
end

require 'kaminari/models/configuration_methods'

module Kaminari
  module ConfigurationMethods
    module ClassMethods
      def default_surface
        (defined?(@_default_surface) && @_default_surface) ||
          Kaminari.config.default_surface
      end
    end
  end
end

require 'kaminari/models/active_record_model_extension'

module Kaminari
  module ActiveRecordModelExtension
    # TODO: I'm concerned with this approach relying on too many internals, but I'm
    # not sure how best to ensure compatiblity with the mechanism that kaminari is using
    # to inject the `page` method.

    remove_instance_variable(:@_included_block)

    included do
      self.send(:include, Kaminari::ConfigurationMethods)

      eval <<-RUBY
        def self.#{Kaminari.config.page_method_name}(num = nil)
          limit(default_per_page).offset(default_per_page * ((num = num.to_i - 1) < 0 ? 0 : num)).extending do
            include Kaminari::ActiveRecordRelationMethods
            include Kaminari::PageScopeMethods
          end.surface(Kaminari.config.default_surface)
        end
      RUBY
    end
  end
end

require 'kaminari/models/page_scope_methods'

module Kaminari
  module SurfacePageScopeMethods
    def per(num)
      @_per = num

      limit_value = @_limit_before_surface || limit_value

      query = (
        if (n = num.to_i) < 0 || !(/^\d/ =~ num.to_s)
          self
        elsif n.zero?
          limit(n)
        elsif max_per_page && max_per_page < n
          limit(max_per_page).offset(offset_value / limit_value * max_per_page)
        else
          limit(n).offset(offset_value / limit_value * n)
        end
      )

      @_surface ? query.surface(@_surface) : query
    end

    def padding(num)
      @_padding = num
      offset(offset_value + num.to_i).surface(@_surface)
    end

    def surface(num)
      @_surface = num
      @_limit_before_surface = limit_value

      remaining = total_count - (offset_value + per_page_count)

      if remaining <= num
        limit(limit_value + remaining)
      else
        self
      end
    end

    def current_page
      offset_without_padding = offset_value
      offset_without_padding -= @_padding if padding_enabled?
      offset_without_padding = 0 if offset_without_padding < 0

      (offset_without_padding / per_page_count) + 1
    end

    # def first_page?; end
    # def last_page?;  end
    # def next_page; end
    # def num_pages; end
    # def out_of_range?; end
    # def padding; end
    # def per; end
    # def prev_page; end

    def total_pages
      # How many pages are shown on the last page?

      count_without_padding = total_count
      count_without_padding -= @_padding if padding_enabled?
      count_without_padding = 0 if count_without_padding < 0

      total_pages_count = ((count_without_padding - surface_count).to_f / per_page_count).ceil

      if max_pages.present? && max_pages < total_pages_count
        max_pages
      else
        total_pages_count
      end
    end

    def num_pages
      total_pages
    end

    private
    def per_page_count
      (@_per || default_per_page).to_i
    end

    def surface_count
      (@_surface || 0).to_i
    end

    def padding_enabled?
      defined?(@_padding) && @_padding
    end
  end

  PageScopeMethods.prepend(SurfacePageScopeMethods)
end
