pragma solidity ^0.4.23;
contract BlindAuction{

	mapping(address => bool) public isBidded;
	mapping(uint => Bidder) public bidders;

	address public beneficiary;
	uint public duration;
	uint public reserve;
	uint public endAuction;
	uint public bidderNum;

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
		require(!isBidded[msg.sender]);
		require(reservePrice >= reserve);
		require(now <= endAuction);
		isBidded[msg.sender] = true;
		bidders[bidderNum ++] = Bidder(msg.sender, price, msg.value);
	}

	//AuctionEnd
}