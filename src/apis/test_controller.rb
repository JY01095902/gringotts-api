$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'repositories'))

require 'grape'

class TestController < Grape::API
    version 'v1'
    prefix :api
    format :json
    get 'test' do
        
        return 'ok'
    end
end