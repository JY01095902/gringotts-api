$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'db'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'entities'))

require 'context'
require 'account'
require 'repository'

class AccountsRepository < Repository
    def initialize
        context = DbContext.new
        @accounts = context.accounts
    end

    def insert_one(account)
        count = 0
        if(account.kind_of? Account)
            objectId = DbContext.get_object_id
            account.id = objectId.to_s
            account.creator_user_id = 1
            account.creation_time_utc = Time.new.utc
            document = account.to_hash
            document.delete(:id)
            document[:_id] = objectId
            result = @accounts.insert_one(document)
            count = result.n
        end
        return count == 1 ? account.to_hash : nil
    end

    def patch_one(filter, patch)
        filter = Repository.format_filter(filter)
        result = @accounts.update_one(filter, { '$set': patch })
        return result.modified_count
    end

    def update_one(filter, update)
        filter = Repository.format_filter(filter)
        if(update.has_key?(:id))
            update.delete(:id)
        end
        result = @accounts.update_one(filter, update)
        return result.modified_count
    end

    def delete_one(filter)
        filter = Repository.format_filter(filter)
        result = @accounts.delete_one(filter)
        return result.deleted_count
    end

    def find(filter = nil)
        filter = Repository.format_filter(filter) if filter != nil
        documents = @accounts.find(filter);
        accounts = Array.new
        documents.each do |document|
            account = Hash.new
            account[:id] = document[:_id].to_s
            account[:name] = document[:name]
            account[:image] = document[:image]
            accounts.push(account)
        end
        return accounts
    end
end