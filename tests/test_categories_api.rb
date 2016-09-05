require 'rack/test'
require 'test-unit'
    
OUTER_APP = Rack::Builder.parse_file('config.ru').first

class TestCategoriesAPI < Test::Unit::TestCase
    include Rack::Test::Methods

    def app
        OUTER_APP
    end

    def test_get_api_statuses_public_timeline_returns_an_empty_array_of_statuses
        get 'http://127.0.0.1:9292/api/v1/categories'
        assert last_response.ok?
        assert JSON.parse(last_response.body).kind_of? Array

        #puts last_response.public_methods
    end

    def test_get_api_statuses_id_returns_a_status_by_id
        get "http://127.0.0.1:9292/api/v1/categories/57cd201e3942682f746ac358"
        assert last_response.ok?
        assert JSON.parse(last_response.body).kind_of? Array
        assert_equal 1, JSON.parse(last_response.body).length
    end

    def test_post
        post "http://127.0.0.1:9292/api/v1/categories", { name: 'test1', name: 'qqq', type: 'payout'}
        assert JSON.parse(last_response.body).kind_of? Hash
        assert_equal 201, last_response.status
    end
end