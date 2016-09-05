require 'entity'

class Payment < Entity
    attr_accessor :name
    attr_accessor :date
    attr_accessor :amount
    attr_accessor :category
    attr_accessor :chest_id
    attr_accessor :user_id

    def to_hash()
        hash = super.to_hash
        hash[:name] = self.name
        hash[:date] = self.date
        hash[:amount] = self.amount
        hash[:category] = self.category
        hash[:chest_id] = self.chest_id
        hash[:user_id] = self.user_id

        return hash
    end
end