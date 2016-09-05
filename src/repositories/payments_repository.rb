$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'entities'))

require 'payment'
require 'repository'

class PaymentsRepository < Repository
    def initialize
        super(:payments)
    end

    def insert_one(payment)
        created_payment = nil
        if(payment.kind_of? Payment)
            payment.creator_user_id = 1
            payment.creation_time_utc = Time.new.utc
            document = payment.to_hash
            created_payment = super(document)
            if(created_payment != nil)
                created_payment[:id] = created_payment[:_id].to_s
                created_payment.delete(:_id)
            end
        end
        return created_payment
    end

    def find(filter = nil)
        documents = super(filter);
        payments = Array.new
        documents.each do |document|
            payment = Hash.new
            payment[:id] = document[:_id].to_s
            payment[:name] = document[:name]
            payment[:date] = document[:date]
            payment[:amount] = document[:amount]
            payment[:category] = document[:category]
            payment[:chest_id] = document[:chest_id]

            payments << payment
        end
        return payments
    end
end