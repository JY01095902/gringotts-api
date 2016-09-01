$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'src', 'apis'))
require 'api'
require "rack/test"
require 'test-unit'

OUTER_APP = Rack::Builder.parse_file('config.ru').first


class TestApp < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  def test_get_api_statuses_public_timeline_returns_an_empty_array_of_statuses
    get 'http://127.0.0.1:9292/api/v1/accounts'
    assert last_response.ok?
    assert JSON.parse(last_response.body).kind_of? Array

    #puts last_response.public_methods
  end

  def test_get_api_statuses_id_returns_a_status_by_id
    get "http://127.0.0.1:9292/api/v1/accounts/57c69bd039426816a4df6b86"
    assert last_response.ok?
    assert JSON.parse(last_response.body).kind_of? Array
    assert_equal 1, JSON.parse(last_response.body).length
  end

  def test_post
    post "http://127.0.0.1:9292/api/v1/accounts"
    assert_equal 201 last_response.status
    # assert JSON.parse(last_response.body).kind_of? Array
    # assert_equal 1, JSON.parse(last_response.body).length
  end
end