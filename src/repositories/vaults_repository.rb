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
            vault.creation_time_utc = Time.new.utc
            document = vault.to_hash
            created_vault = super(document)
        end
        return created_vault
    end

    def find(filter = nil)
        filter = VaultsRepository.format_filter filter
        documents = super filter;
        vaults = Array.new
        documents.each do |document|
            vault = Hash.new
            vault[:id] = document[:_id].to_s
            vault[:name] = document[:name]
            vault[:amount] = document[:amount]
            vault[:type] = document[:type]
            vault[:style] = document[:style]
            vault[:details] = document[:details]
            vaults << vault
        end
        return vaults
    end

    def VaultsRepository.format_filter(filter)
        if filter != nil
            filter[:tenant_id] = filter[:tenant_id].to_i if filter[:tenant_id] != nil
            filter[:owner_user_id] = filter[:owner_user_id].to_i if filter[:owner_user_id] != nil
        end
        return filter
    end
end