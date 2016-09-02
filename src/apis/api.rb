require 'grape'
require 'accounts_api'
require 'vaults_api'
require 'categories_api'
require 'chests_api'
require 'payments_api'

class API < Grape::API
    mount AccountsAPI
    mount VaultsAPI
    mount CategoriesAPI
    mount ChestsAPI
    mount PaymentsAPI
end