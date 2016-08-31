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
            category.creator_user_id = 1
            category.creation_time_utc = Time.new.utc
            document = category.to_hash
            created_category = super(document)
            if(created_category != nil)
                created_category[:id] = created_category[:_id].to_s
                created_category.delete(:_id)
            end
        end
        return created_category
    end

    def find(filter = nil)
        documents = super(filter);
        categories = Array.new
        documents.each do |document|
            category = Hash.new
            category[:id] = document[:_id].to_s
            category[:name] = document[:name]
            category[:type] = document[:type]
            categories.push(category)
        end
        return categories
    end
end