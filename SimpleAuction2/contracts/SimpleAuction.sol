pragma solidity ^0.4.23;
contract SimpleAuction {

	mapping(address => bool) public isBided;
	mapping(uint => Bidder) public bidders;
	mapping(address => bool) public isRefunded;

	address public beneficiary;
	uint public duration;
	uint public endTime;
	uint public hightBidPrice;
	uint public bidderNum;
	uint public winner;
	bool public isEnded;

	struct Bidder{
		address bidderAdderss;
		uint bidPrice;
	}
	
	//constructor
	constructor(uint _duration, address _beneficiary) public {
		beneficiary = _beneficiary;
		duration = _duration;
		endTime = now + _duration;
	}

	//bid
	function bid() public payable{
		require(!isEnded);
		require(!isBided[msg.sender]);
		require(now <= endTime);

		isBided[msg.sender] = true;
		bidders[bidderNum] = Bidder(msg.sender, msg.value);

		if(hightBidPrice < msg.value){
			hightBidPrice = msg.value;
			winner = bidderNum;
		}
		bidderNum ++;
	}


	//Auction End
	function auctionEnd() public {
		require(!isEnded);
		require(now > endTime);
		isEnded = true;

		isRefunded[bidders[winner].bidderAdderss] = true;
		beneficiary.transfer(bidders[winner].bidPrice);
		for(uint i = 1;(i < bidderNum) && (!isRefunded[bidders[i].bidderAdderss]);i ++){
			isRefunded[bidders[i].bidderAdderss] = true;
			bidders[i].bidderAdderss.transfer(bidders[i].bidPrice);
		}
	}
}