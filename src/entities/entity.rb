class Entity
    attr_accessor :id
    attr_accessor :creator_user_id
    attr_accessor :creation_time_utc
    attr_accessor :last_modifier_user_id
    attr_accessor :last_modification_time_utc
    
    def to_hash()
        return { 
                id: self.id,
                creator_user_id: self.creator_user_id,
                creation_time_utc: self.creation_time_utc,
                last_modifier_user_id: self.last_modifier_user_id,
                last_modification_time_utc: self.last_modification_time_utc
            }
    end
end