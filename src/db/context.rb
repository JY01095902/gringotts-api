require 'mongo'
require 'bson'
require 'singleton'

class DbContext
    include Singleton

    attr_reader :collections;

    def initialize
        client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'gringotts')

        @collections = Hash.new
        @collections[:accounts] = client[:accounts]
        @collections[:vaults] = client[:vaults]
        @collections[:chests] = client[:chests]
        @collections[:payments] = client[:payments]
        @collections[:categories] = client[:categories]
    end

    def DbContext.get_object_id(string = nil)
        return string == nil ? BSON::ObjectId.new : BSON::ObjectId(string)
    end
end