# Document every assumption about the format of the incoming data with an assertion
# at the point where the assumed feature is first used. Use assertion failures
# to improve your understanding of the data, and to warn you when its format changes.

class Bank
  def read_transactions(account_number)
    [
      {"amount" => "1.23"},
      {"amount" => "76.72"}
    ]
  end
end

class Account
  def initialize(account_number, bank)
    @account_number, @bank = account_number, bank
    @cached = []
  end

  def cache_transaction(transaction)
    puts "caching #{transaction}"
    @cached << transaction
  end

  def refresh_transactions()
    transactions = @bank.read_transactions(@account_number)
    transactions.is_a?(Array) or raise TypeError, "transactions is not an Array"
    transactions.each do |transaction|
      amount = transaction.fetch("amount")
      amount_cents = (Float(amount) * 100).to_i # Kernel.Float is stricter than to_f
      cache_transaction(:amount => amount_cents)
    end
  end
end

def bank_assumptions()
  bank = Bank.new()
  account = Account.new(123, bank)
  account.refresh_transactions()
end

bank_assumptions()