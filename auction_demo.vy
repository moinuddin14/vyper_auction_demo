# No Modifiers
# No Inheritance
# No Overloading of Functions
# No Operator Overloading
# No Recursive Calls
# No Infinite loops
# No Overflow and Underflow

beneficiary: public(address)
auctionStart: public(timestamp)
auctionEnd: public(timestamp)

#current state of the auction
highestBid: public(wei_value)
highestBidder: public(address)
ended: public(bool)

# Constructor
# timedelta is the number of seconds that we want the bid to happen
@public
def __init__(_beneficiary: address, _bidding_time:timedelta):
    self.beneficiary = _beneficiary
    self.auctionStart = block.timestamp
    self.auctionEnd = self.auctionStart + _bidding_time

# Bid function would allow bidders to send ethers to this contract    
@public
@payable
def bid():
    # Check if bidding time is over
    # Asserts the specified condition, if the condition is equals to true the code will continue to run. Otherwise, the OPCODE REVERT (0xfd) will be triggered, the code will stop it’s operation, the contract’s state will be reverted to the state before the transaction took place and the remaining gas will be returned to the transaction’s sender.
    # Though we have used assert without paranthesis, having the assert with paranthesis is absolutely fine and will compile with no issues, but to follow the Python style of coding, its recommended to not use the paranthesis. 
    assert block.timestamp < self.auctionEnd
    # Check if bid is higher than the last highest bidder
    assert msg.value > self.highestBid
    # Check the condition that the highestBid is already set with some value
    if not self.highestBid == 0:
        # Send money back to highest bidder
        send(self.highestBidder, self.highestBid)
    self.highestBidder = msg.sender
    self.highestBid = msg.value
    
# End auction and send the total bid to the winner
@public
def endAuction():
    # Check if the bid period is done
    assert block.timestamp >= self.auctionEnd
    # Check if the auction is already over
    assert not self.ended
    # End the auction
    self.ended = True
    # Send money to the beneficiary
    send(self.beneficiary, self.highestBid)
    