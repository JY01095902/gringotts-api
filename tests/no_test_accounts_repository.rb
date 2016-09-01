$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'src', 'repositories'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'src', 'entities'))

require 'accounts_repository'
require 'account'
require 'minitest/autorun'

class TestAccountsRepository < MiniTest::Test
    def setup
        @accounts_repository = AccountsRepository.new
    end

    def test_insert_one
        account = Account.new
        account.name = 'a'
        account.image = '/a.png'
        assert_equal account.to_hash[:name], @accounts_repository.insert_one(account)[:name]
    end
end