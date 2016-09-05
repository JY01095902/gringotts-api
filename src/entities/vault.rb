require 'entity'

class Vault < Entity
    attr_accessor :name 
    attr_accessor :amount
    attr_accessor :account_id
    attr_accessor :user_id

    def to_hash()
        hash = super.to_hash
        hash[:name] = self.name
        hash[:amount] = self.amount
        hash[:account_id] = self.account_id
        hash[:user_id] = self.user_id

        return hash
    end
end