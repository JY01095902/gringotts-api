$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'entities'))

require 'vault'
require 'repository'

class VaultsRepository < Repository
    def initialize
        super(:vaults)
    end

    def insert_one(vault)
        created_vault = nil
        if(vault.kind_of? Vault)
            vault.tenant_id = 1
            vault.owner_user_id = 1
            vault.creator_user_id = 1
            vault.creation_time_utc = Time.new.utc
            document = vault.to_hash
            created_vault = super(document)
        end
        return created_vault
    end

    def find(filter = nil)
        documents = super(filter);
        vaults = Array.new
        documents.each do |document|
            vault = Hash.new
            vault[:id] = document[:_id].to_s
            vault[:name] = document[:name]
            vault[:amount] = document[:amount]
            vault[:type] = document[:type]
            vault[:style] = document[:style]
            vault[:details] = document[:details]
            vault[:owner_user_id] = document[:owner_user_id]
            vaults << vault
        end
        return vaults
    end
end