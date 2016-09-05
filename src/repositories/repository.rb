$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'db'))
require 'context'

class Repository
    def initialize(collection)
        context = DbContext.instance
        @collection = context.collections[collection]
    end

    # def insert_one(entity)
    #     created_entity = nil
    #     if(entity.kind_of? Entity)
    #         entity.creator_user_id = 1
    #         entity.creation_time_utc = Time.new.utc
    #         document = entity.to_hash
    #         created_entity = super(document)
    #         if(created_entity != nil)
    #             created_entity[:id] = created_entity[:_id].to_s
    #             created_entity.delete(:_id)
    #         end
    #     end
    #     return created_entity
    # end

    def insert_one(document)
        if(document.has_key?(:id))
            document[:_id] = DbContext.get_object_id
            document.delete(:id) 
        end
        result = @collection.insert_one(document)
        count = result.n
        return count == 1 ? document : nil
    end

    def patch_one(filter, patch)
        filter = Repository.format_filter(filter)
        result = @collection.update_one(filter, { '$set': patch })
        return result.modified_count
    end

    def update_one(filter, update)
        filter = Repository.format_filter(filter)
        if(update.has_key?(:id))
            update.delete(:id)
        end
        result = @collection.update_one(filter, update)
        return result.modified_count
    end

    def delete_one(filter)
        filter = Repository.format_filter(filter)
        result = @collection.delete_one(filter)
        return result.deleted_count
    end

    def find(filter)
        filter = Repository.format_filter(filter) if filter != nil
        return @collection.find(filter);
    end

    private
    def Repository.format_filter(filter)
        if(filter.has_key?(:id))
            filter[:_id] = DbContext.get_object_id(filter[:id])
            filter.delete(:id)
        end
        return filter
    end
end