require 'rspec'
require 'faker'
require 'active_record'
require 'data_mapper'

require 'kaminari/surface/version'
require 'kaminari/surface'

include Kaminari::Surface

# ActiveRecord

require 'kaminari/models/active_record_extension'
::ActiveRecord::Base.send :include, Kaminari::ActiveRecordExtension

ActiveRecord::Base.establish_connection(:adapter => "sqlite3",
                                        :database => ":memory:")

ActiveRecord::Schema.define(:version => 1) do
  create_table :widgets do |t|
    t.string :name
  end
end

module SampleModels
  module ActiveRecord
    class Widget < ::ActiveRecord::Base
      self.table_name = 'widgets'

      before_save :generate_name

      def generate_name
        self.name ||= Faker::Commerce.product_name
      end
    end
  end
end

# DataMapper

require 'kaminari/data_mapper'

DataMapper.setup(:default, 'sqlite::memory:')

module SampleModels
  module DataMapper
    class Widget
      include ::DataMapper::Resource

      property :id   , Serial
      property :name , String

      before :save, :generate_name

      def generate_name
        self.name ||= Faker::Commerce.product_name
      end
    end
  end
end

DataMapper.finalize
DataMapper.auto_migrate!

# Mongoid

require 'mongoid'
require 'kaminari/mongoid'

Mongoid.configure do |config|
  config.sessions = {
    default: {
      hosts: ['0.0.0.0:27017'],
      database: 'kaminari_test'
    }
  }
end

module SampleModels
  module Mongoid
    class Widget
      include ::Mongoid::Document

      field :name, type: String, default: ->{ Faker::Commerce.product_name }
    end
  end
end

# MongoMapper

require 'mongo_mapper'
require 'kaminari/mongo_mapper'

module SampleModels
  module MongoMapper
    class Widget
      include ::MongoMapper::Document
      key :name, String

      before_save :generate_name

      private
      def generate_name
        self.name ||= Faker::Commerce.product_name
      end
    end
  end
end


MongoMapper.connection = Mongo::Connection.new '0.0.0.0', 27017
MongoMapper.database = 'kaminari_test'
