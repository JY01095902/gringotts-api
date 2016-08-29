$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'db'))
require 'context'

module RepositoryHelper
    def RepositoryHelper.format_filter(filter)
        if(filter.has_key?(:id))
            filter[:_id] = DbContext.get_object_id(filter[:id])
            filter.delete(:id)
        end
        return filter
    end
end