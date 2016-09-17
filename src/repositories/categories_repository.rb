$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'entities'))

require 'category'
require 'repository'

class CategoriesRepository < Repository
    def initialize
        super(:categories)
    end

    def insert_one(category)
        created_category = nil
        if(category.kind_of? Category)
            category.tenant_id = 1
            category.owner_user_id = 1
            category.creator_user_id = 1
            category.creation_time_utc = Time.new.utc
            document = category.to_hash
            created_category = super(document)
        end
        return created_category
    end

    def find(filter = nil)
        filter = VaultsRepository.format_filter filter
        documents = super filter;
        categories = Array.new
        documents.each do |document|
            category = Hash.new
            category[:id] = document[:_id].to_s
            category[:name] = document[:name]
            category[:type] = document[:type]
            categories << category
        end
        return categories
    end

    def self.format_filter(filter)
        if filter != nil
            filter[:tenant_id] = filter[:tenant_id].to_i if filter[:tenant_id] != nil
            filter[:owner_user_id] = filter[:owner_user_id].to_i if filter[:owner_user_id] != nil
        end
        return filter
    end
end