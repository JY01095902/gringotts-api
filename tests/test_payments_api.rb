require 'rack/test'
require 'test-unit'

OUTER_APP = Rack::Builder.parse_file('config.ru').first

class TestPaymentsAPI <  Test::Unit::TestCase
    include Rack::Test::Methods

    def app
        OUTER_APP
    end

    def test_get_all
        get 'http://127.0.0.1:9292/api/v1/payments'
        assert last_response.ok?
        assert JSON.parse(last_response.body).kind_of? Array

        #puts last_response.public_methods
    end

    def test_get_by_id
        get "http://127.0.0.1:9292/api/v1/payments/57ceba23bacf2a21d8dc5065"
        assert last_response.ok?
        assert JSON.parse(last_response.body).kind_of? Array
        assert_equal 1, JSON.parse(last_response.body).length
    end

    def test_post
        post "http://127.0.0.1:9292/api/v1/payments", { name: 'test21', amount: 10.5, category:{ id: '57ceba22bacf2a21d8dc5061', name: 'www', type: 'payout' }, chest_id: '57ceba22bacf2a21d8dc5063'}
        assert JSON.parse(last_response.body).kind_of? Hash
        assert_equal 201, last_response.status
    end
end