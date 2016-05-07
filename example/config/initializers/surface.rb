require 'kaminari/models/page_scope_methods'

module Kaminari
  module SurfacePageScopeMethods
    def per(num)
      @_per = num
      super
    end

    def surface(num)
      @_surface = num

      remaining = total_count - (offset_value + per_page_count)

      if remaining <= num
        limit(limit_value + remaining).offset(offset_value)
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
