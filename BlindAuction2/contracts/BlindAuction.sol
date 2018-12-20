pragma solidity ^0.4.23;
contract BlindAuction{

	mapping(address => bool) public isBidded;
	mapping(uint => Bidder) public bidders;
	mapping(address => bool) public isRefunded;

	address public beneficiary;
	uint public duration;
	uint public reserve;
	uint public endAuction;
	uint public bidderNum;
	uint public hightestBid;
	uint public winner;
	uint bool isEnd;

	struct Bidder{
		address bidderAddress;
		uint bidderPrice;
		uint reservePrice;
	}

	//constructor
	constructor(address _beneficiary, uint _duration, uint _reserve) public{
		beneficiary = _beneficiary;
		duration = _duration;
		reserve = _reserve;
		endAuction = now + _duration;
	}

	//bid
	function bid(uint price) public payable{
		require(!isEnd);
		require(!isBidded[msg.sender]);
		require(reservePrice >= reserve);
		require(now <= endAuction);
		isBidded[msg.sender] = true;
		bidders[bidderNum] = Bidder(msg.sender, price, msg.value);
		if(price > hightestBid){
			hightestBid = price;
			winner = bidderNum;
		}
		bidderNum ++;
	}

	//AuctionEnd
	function auctionEnd() public{
		require(!isEnd);
		require(now > endAuction);
		Bidder tmpBidder;
		isRefunded(bidders(winner).bidderAddress) = true;
		for(uint i = 0;(i <= bidderNum) && (!isRefunded(bidders(i).bidderAddress));i ++){
			tmpBidder = bidders(i);
			tmpBidder.bidderAddress.transfer(tmpBidder.reservePrice);
		}
	}
}