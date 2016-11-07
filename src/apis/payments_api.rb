$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'repositories'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'entities'))

require 'grape'
require 'payments_repository'
require 'payment'

class PaymentsAPI < Grape::API
    version 'v1'
    prefix :api
    format :json
    resources :payments do
        get do
            payments_repository = PaymentsRepository.new
            payments = payments_repository.find params
            return payments
        end

        get ':id' do
            payments_repository = PaymentsRepository.new
            payments = payments_repository.find({ id: params[:id]})
            return payments
        end

        params do
            requires :name, type: String
            requires :amount, type: Float
            requires :vault, type: Hash
            requires :category, type: Hash
            requires :tenant_id, type: Integer
            requires :creator_user_id, type: Integer
            optional :date, type: Time, default: Time.new
        end
        post do
            payment = Payment.new
            payment.name = params[:name]
            payment.date = params[:date]
            payment.amount = params[:amount]
            payment.vault = params[:vault]
            payment.category = params[:category]
            payment.tenant_id = params[:tenant_id]
            payment.creator_user_id = params[:creator_user_id]
            payments_repository = PaymentsRepository.new
            created_payment = payments_repository.insert_one payment
            return created_payment
        end

        delete ':id' do
            payments_repository = PaymentsRepository.new
            deleted_count = payments_repository.delete_one({ id: params[:id]})
            if deleted_count == 1
                status 204
                return String.new
            else
                status 404
                return { message: 'no payment has been deleted.'}
            end
        end
        
        params do
            requires :last_modifier_user_id, type: Integer
            optional :date, type: Time, default: Time.new
        end
        patch ':id' do
            patch = Hash.new
            patch[:name] = params[:name] if params[:name] != nil
            patch[:date] = params[:date] if params[:date] != nil
            patch[:amount] = params[:amount] if params[:amount] != nil
            patch[:vault] = params[:vault] if params[:vault] != nil
            patch[:category] = params[:category] if params[:category] != nil
            patch[:last_modifier_user_id] = params[:last_modifier_user_id] if params[:last_modifier_user_id] != nil
            payments_repository = PaymentsRepository.new
            puts patch
            modified_count = payments_repository.patch_one({ id: params[:id]}, patch)
            if modified_count == 1
                status 204
                return String.new
            else
                status 404
                return { message: 'no payment has been patched.'}
            end
        end
        
        params do
            requires :name, type: String
            requires :amount, type: Float
            requires :vault, type: Hash
            requires :category, type: Hash
            requires :owner_user_id, type: Integer
            requires :last_modifier_user_id, type: Integer
            optional :date, type: Time, default: Time.new
        end
        put ':id' do
            payment = Payment.new
            payment.name = params[:name]
            payment.amount = params[:amount]
            payment.vault = params[:vault]
            payment.category = params[:category]
            payment.date = params[:date]
            payment.owner_user_id = params[:owner_user_id]
            payment.last_modifier_user_id = params[:last_modifier_user_id]
            payments_repository = PaymentsRepository.new
            modified_count = payments_repository.update_one({ id: params[:id]}, payment)
            if(modified_count == 1)
                status 204
                return String.new
            else
                status 404
                return { message: 'no payment has been updated.'}
            end
        end
    end
end