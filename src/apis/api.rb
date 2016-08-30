require 'grape'
require 'accounts_api'
require 'vaults_api'
require 'categories_api'

class API < Grape::API
    mount AccountsAPI
    mount VaultsAPI
    mount CategoriesAPI
end