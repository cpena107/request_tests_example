class Book < ApplicationRecord
    validates_presence_of :title
    validate :read_not_nil

    def read_not_nil
        if read == nil or read == ""
            errors.add(:read, "can't be nil")
        end
    end
end
