require 'entity'

class Category < Entity
    attr_accessor :name
    attr_accessor :type
    attr_accessor :user_id

    def to_hash()
        hash = super.to_hash
        hash[:name] = self.name
        hash[:type] = self.type
        hash[:user_id] = self.user_id

        return hash
    end
end