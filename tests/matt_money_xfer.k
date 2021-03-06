context TransferMoney {
    public TransferMoney(Account source, Account destination, Currency amount) {
        SourceAccount = source;
        DestinationAccount = destination;
        Amount = amount;
        Bank = this;
    }

    stageprop Amount {} requires {
        double value() const;
    }

    // Execute the use case
    public void run() {
        Bank.transfer();
    }

    stageprop Bank {
        public void transfer() {
            SourceAccount.withdraw();
            DestinationAccount.deposit();
        }
    }

    role SourceAccount {    
        public void withdraw() {
            if ( Amount.value() > this.getBalance().value() ) {
                assert(false, "Insufficient funds");
            }
            this.decreaseBalance(Amount);
        }
    } requires {
        void decreaseBalance(Currency amt);
        Currency getBalance();
    }

    role DestinationAccount {
        public void deposit() {
            this.increaseBalance(Amount);
        }
    } requires {
        void increaseBalance(Currency amt)
    }
}

class Account {
    private Currency balance_;

    public Account() {
       balance_ = new Currency(0.0);
    }

    // Must be public to be accessible as Role-player methods
    public void increaseBalance(Currency amount) {
        this.balance_ = new Currency(this.balance_.value() + amount.value());
    }

    public void decreaseBalance(Currency amount) {
        this.balance_ = new Currency(this.balance_.value() - amount.value());
    }

    public Currency getBalance() {
        return this.balance_;
    }
}

class Currency {
    private double value_;
    public Currency(double val) {
        value_ = val;
    }
    public double value() const {
        return value_;
    }
}


{
    Account src = new Account();
    Account dst = new Account();
    TransferMoney transfer = new TransferMoney(src, dst, new Currency(10.0));
    transfer.run()
}

/* GOLD:
line 27: NONCOMPLIANT: Trying to enact object script `value()' without using the interface of the Role it is playing: `Amount'.
line 30: Type of actual parameter `current$context.Amount' (Amount) in call of `decreaseBalance' does not match type of formal parameter `amt' (Currency amt)
line 39: Type of actual parameter `current$context.Amount' (Amount) in call of `increaseBalance' does not match type of formal parameter `amt' (Currency amt)
line 70: WARNING: Assignment / initialization does not create a new instance. Both `value_' and `val' will refer to the same object. Use `val.clone' to create a separate instance.
1 warning, 2 errors.
___________________________________________________________
*/
