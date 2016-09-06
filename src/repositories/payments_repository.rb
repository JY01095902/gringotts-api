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
            payment.tenant_id = 1
            payment.user_id = 1
            payment.creator_user_id = 1
            payment.creation_time_utc = Time.new.utc
            document = payment.to_hash
            created_payment = super(document)
        end
        return created_payment
    end

    def find(filter = nil)
        documents = super(filter);
        payments = Array.new
        documents.each do |document|
            payment = Hash.new
            payment[:id] = document[:id]
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