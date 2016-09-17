$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'db'))
require 'context'

class Repository
    def initialize(collection)
        context = DbContext.instance
        @collection = context.collections[collection]
    end

    def insert_one(document)
        document[:_id] = DbContext.get_object_id
        document.delete :id if document.has_key? :id
        result = @collection.insert_one document
        count = result.n
        document[:id] = document[:_id].to_s
        document.delete :_id
        return count == 1 ? document : nil
    end

    def patch_one(filter, patch)
        filter = Repository.format_filter filter
        if patch.has_key? :_id
            patch.delete :_id
        end
        patch[:last_modification_time_utc] = Time.new.utc
        result = @collection.update_one filter, { '$set': patch }
        return result.modified_count
    end

    def update_one(filter, update)
        filter = Repository.format_filter filter
        if update.has_key? :_id
            update.delete :_id
        end
        update[:last_modification_time_utc] = Time.new.utc
        result = @collection.update_one filter, update
        return result.modified_count
    end

    def delete_one(filter)
        filter = Repository.format_filter filter
        result = @collection.delete_one filter
        return result.deleted_count
    end

    def find(filter)
        filter = Repository.format_filter filter
        return @collection.find filter;
    end

    def self.format_filter(filter)
        if filter.has_key? :id
            filter[:_id] = DbContext.get_object_id filter[:id]
            filter.delete :id
        end if filter != nil
        return filter
    end
end