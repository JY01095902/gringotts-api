require 'entity'

class Chest < Entity
    attr_accessor :name 
    attr_accessor :amount
    attr_accessor :vault_id

    def to_hash()
        hash = super.to_hash
        hash[:name] = self.name
        hash[:amount] = self.amount
        hash[:vault_id] = self.vault_id

        return hash
    end
end