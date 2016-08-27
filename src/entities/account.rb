require 'entity'

class Account < Entity
    attr_accessor :name 
    attr_accessor :image

    def to_hash()
        hash = super.to_hash
        hash[:name] = self.name
        hash[:image] = self.image

        return hash
    end
end