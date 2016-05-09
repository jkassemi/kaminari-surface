require 'kaminari'

require 'kaminari/surface/version'
require 'kaminari/surface/page_scope_methods'

Kaminari::PageScopeMethods.prepend(Kaminari::Surface::PageScopeMethods)

require 'kaminari/surface/paginatable_array_extension'
require 'kaminari/models/array_extension'

Kaminari::PaginatableArray.prepend(Kaminari::Surface::PaginatableArrayExtension)

if defined?(DataMapper)
#  require 'kaminari/surface/data_mapper_extension'
end
