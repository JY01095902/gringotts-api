require 'grape'
require 'accounts_api'
require 'categories_api'

class API < Grape::API
    mount AccountsAPI
    mount CategoriesAPI
end