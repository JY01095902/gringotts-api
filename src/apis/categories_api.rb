$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'repositories'))

require 'grape'

class CategoriesAPI < Grape::API
    version 'v1'
    prefix :api
    format :json
    get 'categories' do
        
        return 'ok'
    end
end