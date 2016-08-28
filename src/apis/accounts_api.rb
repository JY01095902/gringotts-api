$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'repositories'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'entities'))

require 'grape'
require 'accounts_repository'
require 'account'

class AccountsAPI < Grape::API
    version 'v1'
    prefix :api
    format :json
    resources :accounts do
        get do
            accounts_repository = AccountsRepository.new
            accounts = accounts_repository.find
            return accounts
        end

        get ':id' do
            accounts_repository = AccountsRepository.new
            accounts = accounts_repository.find({ id: params[:id]})
            return accounts
        end

        params do
            requires :name, type: String
            optional :image, type: String, default: '/blank.png'
        end
        post do
            account = Account.new
            account.name = params[:name]
            account.image = params[:image]
            accounts_repository = AccountsRepository.new
            created_account = accounts_repository.insert_one(account)
            return created_account
        end

        delete ':id' do
            accounts_repository = AccountsRepository.new
            deleted_count = accounts_repository.delete_one({ id: params[:id]})
            if(deleted_count == 1)
                status 204
                return String.new
            else
                status 404
                return { message: 'no account has been deleted.'}
            end
        end
    end
end