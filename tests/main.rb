$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'src', 'repositories'))

require 'account_repository'

account = Account.new
account.name = 'Hello'
account.image = '/1.jpg'

accounts_repository = AccountsRepository.new
#puts accounts_repository.insert_one(account);

# puts accounts_repository.update_one({ :id => '57c179cbbacf2a14a816e8d6' },
# { :name => '呵呵', :creation_time_utc => Time.new.utc })

#puts accounts_repository.delete_one({ id: '57c17a6abacf2a1580d0fa99' })

puts accounts_repository.find