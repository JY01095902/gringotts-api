require 'rack/test'
require 'test-unit'

OUTER_APP = Rack::Builder.parse_file('config.ru').first

class TestVaultsAPI <  Test::Unit::TestCase
    include Rack::Test::Methods

    def app
        OUTER_APP
    end

    def test_get_all
        get 'http://127.0.0.1:9292/api/v1/vaults'
        assert last_response.ok?
        assert JSON.parse(last_response.body).kind_of? Array

        #puts last_response.public_methods
    end

    def test_get_by_id
        get "http://127.0.0.1:9292/api/v1/vaults/57ceba23bacf2a21d8dc5067"
        assert last_response.ok?
        assert JSON.parse(last_response.body).kind_of? Array
        assert_equal 1, JSON.parse(last_response.body).length
    end

    def test_post
        post "http://127.0.0.1:9292/api/v1/vaults", { name: 'test1', account_id: "57ceba22bacf2a21d8dc505f"}
        assert JSON.parse(last_response.body).kind_of? Hash
        assert_equal 201, last_response.status
    end
end