require 'rack/test'
require 'test-unit'

OUTER_APP = Rack::Builder.parse_file('config.ru').first

class TestChestsAPI <  Test::Unit::TestCase
    include Rack::Test::Methods

    def app
        OUTER_APP
    end

    def test_get_all
        get 'http://127.0.0.1:9292/api/v1/chests'
        assert last_response.ok?
        assert JSON.parse(last_response.body).kind_of? Array

        #puts last_response.public_methods
    end

    def test_get_by_id
        get "http://127.0.0.1:9292/api/v1/chests/57cd201e3942682f746ac359"
        assert last_response.ok?
        assert JSON.parse(last_response.body).kind_of? Array
        assert_equal 1, JSON.parse(last_response.body).length
    end

    def test_post
        post "http://127.0.0.1:9292/api/v1/chests", { name: 'test1', vault_id: "57cd201f3942682f746ac35b"}
        assert JSON.parse(last_response.body).kind_of? Hash
        assert_equal 201, last_response.status
    end
end