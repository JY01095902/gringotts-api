$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'repositories'))

require 'grape'
require 'account_repository'

class AccountsController < Grape::API
    version 'v1'
    prefix :api
    format :json
    get 'accounts' do
        account_repository = AccountRepository.new
        accounts = account_repository.find
        return accounts
    end
end