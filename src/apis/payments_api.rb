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
            payments = payments_repository.find
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
            requires :category, type: Hash
            requires :chest_id, type: String
            optional :date, type: Time, default: Time.new
        end
        post do
            payment = Payment.new
            payment.name = params[:name]
            payment.amount = params[:amount]
            payment.category = params[:category]
            payment.chest_id = params[:chest_id]
            payment.date = params[:date]
            payments_repository = PaymentsRepository.new
            created_payment = payments_repository.insert_one(payment)
            return created_payment
        end

        delete ':id' do
            payments_repository = PaymentsRepository.new
            deleted_count = payments_repository.delete_one({ id: params[:id]})
            if(deleted_count == 1)
                status 204
                return String.new
            else
                status 404
                return { message: 'no payment has been deleted.'}
            end
        end
        
        patch ':id' do
            patch = Hash.new
            patch[:name] = params[:name] if params[:name] != nil
            patch[:amount] = params[:amount] if params[:amount] != nil
            patch[:category] = params[:category] if params[:category] != nil
            patch[:chest_id] = params[:chest_id] if params[:chest_id] != nil
            patch[:date] = params[:date] if params[:date] != nil
            payments_repository = PaymentsRepository.new
            modified_count = payments_repository.patch_one({ id: params[:id]}, patch)
            if(modified_count == 1)
                status 204
                return String.new
            else
                status 404
                return { message: 'no payment has been patched.'}
            end
        end
        
        params do
            requires :name, type: String
            optional :image, type: String, default: '/blank.png'
        end
        put ':id' do
            payment = Payment.new
            payment.name = params[:name]
            payment.amount = params[:amount]
            payment.category = params[:category]
            payment.chest_id = params[:chest_id]
            payment.date = params[:date]
            payments_repository = PaymentsRepository.new
            modified_count = payments_repository.update_one({ id: params[:id]}, payment.to_hash)
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