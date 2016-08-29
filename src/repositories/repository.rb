$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'db'))
require 'context'

class Repository
    protected
    def Repository.format_filter(filter)
        if(filter.has_key?(:id))
            filter[:_id] = DbContext.get_object_id(filter[:id])
            filter.delete(:id)
        end
        return filter
    end
end