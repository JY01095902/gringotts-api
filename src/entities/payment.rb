require 'entity'

class Payment < Entity
    attr_accessor :name
    attr_accessor :date
    attr_accessor :amount
    attr_accessor :vault
    attr_accessor :category

    def to_hash()
        hash = super.to_hash
        hash[:name] = self.name
        hash[:date] = self.date
        hash[:amount] = self.amount
        hash[:vault] = self.vault
        hash[:category] = self.category

        return hash
    end
end