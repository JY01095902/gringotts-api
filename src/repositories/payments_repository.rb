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
            payment.owner_user_id = 1
            payment.creator_user_id = 1
            payment.creation_time_utc = Time.new.utc
            document = payment.to_hash
            created_payment = super(document)
        end
        return created_payment
    end

    def find(filter = nil)
        filter = PaymentsRepository.format_filter filter
        documents = super filter
        payments = Array.new
        documents.each do |document|
            payment = Hash.new
            payment[:id] = document[:_id].to_s
            payment[:name] = document[:name]
            payment[:date] = document[:date]
            payment[:amount] = document[:amount]
            payment[:vault] = document[:vault]
            payment[:category] = document[:category]

            payments << payment
        end
        return payments
    end

    def self.format_filter(filter)
        if filter != nil
            filter[:tenant_id] = filter[:tenant_id].to_i if filter[:tenant_id] != nil
            filter[:owner_user_id] = filter[:owner_user_id].to_i if filter[:owner_user_id] != nil
            filter[:date] = Time.parse filter[:date] if filter[:date] != nil
        end
        return filter
    end
end