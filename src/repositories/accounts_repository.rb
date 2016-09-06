$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'entities'))

require 'account'
require 'repository'

class AccountsRepository < Repository
    def initialize
        super(:accounts)
    end

    def insert_one(account)
        created_account = nil
        if(account.kind_of? Account)
            account.tenant_id = 1
            account.user_id = 1
            account.creator_user_id = 1
            account.creation_time_utc = Time.new.utc
            document = account.to_hash
            created_account = super(document)
        end
        return created_account
    end

    def find(filter = nil)
        documents = super(filter);
        accounts = Array.new
        documents.each do |document|
            account = Hash.new
            account[:id] = document[:id]
            account[:name] = document[:name]
            account[:image] = document[:image]
            accounts << account
        end
        return accounts
    end
end