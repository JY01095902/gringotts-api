$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'entities'))

require 'chest'
require 'repository'

class ChestsRepository < Repository
    def initialize
        super(:chests)
    end

    def insert_one(chest)
        created_chest = nil
        if(chest.kind_of? Chest)
            chest.creator_user_id = 1
            chest.tenant_id = 1
            chest.creation_time_utc = Time.new.utc
            document = chest.to_hash
            created_chest = super(document)
            if(created_chest != nil)
                created_chest[:id] = created_chest[:_id].to_s
                created_chest.delete(:_id)
            end
        end
        return created_chest
    end

    def find(filter = nil)
        documents = super(filter);
        chests = Array.new
        documents.each do |document|
            chest = Hash.new
            chest[:id] = document[:_id].to_s
            chest[:name] = document[:name]
            chest[:amount] = document[:amount]
            chest[:account_id] = document[:account_id]
            chests << chest
        end
        return chests
    end
end