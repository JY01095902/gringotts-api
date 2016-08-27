$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'src', 'repositories'))

require 'account_repository'

account = Account.new
account.name = 'Hello'
account.image = '/1.jpg'

account_repository = AccountRepository.new
#puts account_repository.insert_one(account);

# puts account_repository.update_one({ :id => '57c179cbbacf2a14a816e8d6' },
# { :name => '呵呵', :creation_time_utc => Time.new.utc })

#puts account_repository.delete_one({ id: '57c17a6abacf2a1580d0fa99' })

puts account_repository.find