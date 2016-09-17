require 'entity'

class Vault < Entity
    attr_accessor :name 
    attr_accessor :amount
    attr_accessor :type
    attr_accessor :style
    attr_accessor :details

    def to_hash()
        hash = super.to_hash
        hash[:name] = self.name
        hash[:amount] = self.amount
        hash[:type] = self.type
        hash[:style] = self.style
        hash[:details] = self.details

        return hash
    end
end