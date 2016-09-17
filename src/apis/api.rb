require 'grape'
require 'vaults_api'
require 'categories_api'
require 'payments_api'

class API < Grape::API
    mount VaultsAPI
    mount CategoriesAPI
    mount PaymentsAPI
end