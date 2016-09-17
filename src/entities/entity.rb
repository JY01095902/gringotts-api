class Entity
    attr_accessor :_id
    attr_accessor :tenant_id
    attr_accessor :owner_user_id
    attr_accessor :creator_user_id
    attr_accessor :creation_time_utc
    attr_accessor :last_modifier_user_id
    attr_accessor :last_modification_time_utc
    
    def to_hash
        return { 
                _id: self._id,
                tenant_id: self.tenant_id,
                owner_user_id: self.owner_user_id,
                creator_user_id: self.creator_user_id,
                creation_time_utc: self.creation_time_utc,
                last_modifier_user_id: self.last_modifier_user_id,
                last_modification_time_utc: self.last_modification_time_utc
            }
    end
end