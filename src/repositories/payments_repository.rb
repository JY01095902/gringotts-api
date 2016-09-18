$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'entities'))

require 'payment'
require 'repository'

class PaymentsRepository < Repository
    def initialize
        super(:payments)
    end

    def insert_one(payment)
        puts payment
        created_payment = nil
        if(payment.kind_of? Payment)
            payment.tenant_id = 1
            payment.owner_user_id = 1
            payment.creator_user_id = 1
            payment.creation_time_utc = Time.new.utc
            payment = PaymentsRepository.format_payment payment
            document = payment.to_hash
            created_payment = super(document)
        end
        return created_payment
    end

    def update_one(filter, payment)
        payment = PaymentsRepository.format_payment payment
        modified_count = super filter, payment.to_hash
    end

    def patch_one(filter, patch)
        if patch[:vault] != nil
            patch[:vault][:_id] = Repository.get_object_id patch[:vault][:id]
            patch[:vault].delete :id
        end
        if patch[:category] != nil
            patch[:category][:_id] = Repository.get_object_id patch[:category][:id]
            patch[:category].delete :id
        end
        modified_count = super filter, patch
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
            payment[:vault][:id] = payment[:vault][:_id].to_s
            payment[:vault].delete :_id
            payment[:category] = document[:category]
            payment[:category][:id] = payment[:category][:_id].to_s
            payment[:category].delete :_id
            payments << payment
        end
        return payments
    end

    def PaymentsRepository.format_filter(filter)
        if filter != nil
            filter[:tenant_id] = filter[:tenant_id].to_i if filter[:tenant_id] != nil
            filter[:owner_user_id] = filter[:owner_user_id].to_i if filter[:owner_user_id] != nil
            filter[:date] = Time.parse filter[:date] if filter[:date] != nil
            if filter[:'vault.id'] != nil
                filter[:'vault._id'] = Repository.get_object_id filter[:'vault.id']
                filter.delete :'vault.id'
            end
            if filter[:'category.id'] != nil
                filter[:'category._id'] = Repository.get_object_id filter[:'category.id']
                filter.delete :'category.id'
            end
        end
        return filter
    end

    def PaymentsRepository.format_payment(payment)
        if payment.vault != nil
            payment.vault[:_id] = Repository.get_object_id payment.vault[:id]
            payment.vault.delete :id
        end
        if payment.category != nil
            payment.category[:_id] = Repository.get_object_id payment.category[:id]
            payment.category.delete :id
        end
        return payment
    end
end