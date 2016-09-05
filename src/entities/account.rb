require 'entity'

class Account < Entity
    attr_accessor :name 
    attr_accessor :image
    attr_accessor :user_id

    def to_hash()
        hash = super.to_hash
        hash[:name] = self.name
        hash[:image] = self.image
        hash[:user_id] = self.user_id

        return hash
    end
end