require 'grape'
require 'accounts_controller'
require 'test_controller'

class API < Grape::API
    mount AccountsController
    mount TestController
end