require 'mongo'
require 'bson'

class DbContext
    attr_reader :accounts;
    attr_reader :vaults;
    attr_reader :chests;
    attr_reader :spending;
    attr_reader :categories;

    def initialize
        client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'gringotts')

        @accounts = client[:accounts]
        @vaults = client[:vaults]
        @chests = client[:chests]
        @spending = client[:spending]
        @categories = client[:categories]
    end

    def DbContext.get_object_id(string = nil)
        return string == nil ? BSON::ObjectId.new : BSON::ObjectId(string)
    end
end