require "rspec"

require_relative "account"

describe Account do
  let(:valid_acct_number) { "1"*10 }
  describe "#initialize" do
    it "adds the starting balance as the first transaction" do
      a = Account.new(valid_acct_number, 100)
      expect(a.transactions).to eq([100])
    end

    it "adds a 0 transaction when no starting balance is specified" do

      a = Account.new(valid_acct_number)
      expect(a.transactions).to eq([0])
    end

    # I originally wrote the below test as a chance to use a
    # message expectation in this spec, but on second thought
    # it's a bad test! Here's why:
    #
    # I originally didn't realize it, but #validate_number is
    # a private method and testing just the message expectation
    # isn't enough. #initialize provides the only chance to test
    # #validate_number, so we need to add assertations that validate
    # the implementation of #validate_number (not just that it was
    # called)
    #
    # it "validates the account number" do
    #   Account.any_instance.should_receive(:validate_number)
    #                                .with(valid_acct_number)
    #   Account.new(valid_acct_number)
    # end

    it "raises an InvalidAccountNumberError exception for invalid account numbers" do
      expect{Account.new("12")}.to raise_exception(InvalidAccountNumberError)
    end
  end

  # I'd delete this, don't see any use for testing the
  # accessor. Testing that .transactions is an array might
  # feel useful, but so many other tests test that fact
  # indirectly
  #describe "#transactions" do
  #end

  describe "#balance" do
    it "sums transactions" do
      a = Account.new(valid_acct_number)
      a.stub(:transactions).and_return([1,2,3,-1])

      expect(a.balance).to eq(5)
    end

  end

  describe "#acct_number" do
    it "obfuscates the original account number" do
      a = Account.new(valid_acct_number)
      expect(a.acct_number).to eq("******1111")
    end

  end

  describe "deposit!" do
    it "appends amount to the list of transactions" do
      a = Account.new(valid_acct_number)
      a.deposit!(22)
      expect(a.transactions).to eq([0,22])
    end

    it "raises a NegativeDepositError when the deposit amount is negative" do
      a = Account.new(valid_acct_number)
      expect{a.deposit!(-22)}.to raise_error(NegativeDepositError)
    end

    it "returns the current balance" do
      # I've created an account with a starting balance
      # to ensure the return value must be the total balance
      # and not just the deposit amount
      a = Account.new(valid_acct_number, 5)
      expect(a.deposit!(22)).to eq(27)
    end
  end

  describe "#withdraw!" do
    it "appends amount to the list of transactions" do
      a = Account.new(valid_acct_number, 50)
      a.withdraw!(-22)
      expect(a.transactions).to eq([50,-22])
    end

    it "ensures withdraw amounts are recorded as negative numbers" do
      a = Account.new(valid_acct_number, 50)
      a.withdraw!(22)
      expect(a.transactions).to eq([50,-22])
    end

    it "returns the current balance" do
      # I've created an account with a starting balance
      # to ensure the return value must be the total balance
      # and not just the deposit amount
      a = Account.new(valid_acct_number, 5)
      expect(a.withdraw!(2)).to eq(3)
    end

  end
end
