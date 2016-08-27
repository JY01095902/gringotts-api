require 'entity'

class Category < Entity
    attr_accessor :name
    attr_accessor :type

    def to_hash()
        hash = super.to_hash
        hash[:name] = self.name
        hash[:type] = self.type

        return hash
    end
end