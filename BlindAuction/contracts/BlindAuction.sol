pragma solidity ^0.4.22;


contract BlindAuction {
  struct Bid{
      bytes32 blindBid;
      uint deposit;
  }

  address public beneficiary; // 受益人
//  uint public currentTime; // 当前时间
  uint public biddingEnd; // 出价结束时间
  uint public revealEnd;  // 揭示价格结束时间
  bool public ended;  // 拍卖是否结束
  uint public testValue; // 仅仅是为了测试用

  mapping(address => Bid) public bids;  // 地址到竞标之间的映射

  address public highestBidder; // 最高出价者
  uint public highestBid;  // 最高出价

  // 允许撤回没有成功的出价
  mapping(address => uint) pendingReturns;

  event AuctionEnded(address winner, uint highestBid);  // 拍卖结束的事件


  /// 修饰符主要用于验证输入的正确
  /// onlyBefore和onlyAfter用于验证是否大于或小于一个时间点
  /// 其中‘_’是原始程序开始执行的地方
  modifier onlyBefore(uint _time) { require(now < _time); _;  }
  modifier onlyAfter(uint _time) {  require(now > _time); _;  }

  // 构建函数：保存受益人、竞标结束时间、公示价格结束时间
  constructor(address _beneficiary, uint _biddingTime, uint _revealTime) public {
      beneficiary = _beneficiary;
      biddingEnd = now + _biddingTime;
      revealEnd = biddingEnd + _revealTime;
  }

  function getCurrentTime() public returns (uint){
  //    currentTime = now;
      return now;
  }
  // 由于truffle console中的web3.sha3（）的返回值与solidity不同，在这里用一个测试函数
  // 为了得到hash值
  function Encryption(uint _value, uint nonce) public returns (bytes32){
      //require (_values != 0 && _fake != 0 && _secret != 0);
        return sha3(msg.sender, _value, nonce);
  }

  /// 给出一个秘密出价_blindBid = sha3(value, fake, secret)
  /// 给出的保证金只在出价正确时给予返回
  /// 有效的出价要求出价的ether至少到达value，并且fake不是true
  /// 设置fake为true，并且给出一个错误的出价可以隐藏真实的出价
  /// 一个地址能够多次出价
  /// 如果是我的话，我会限制一个人的出价都是有效的才进行进一步的操作，从而增加造假的难度
  function bid(bytes32 _blindBid) public payable onlyBefore(biddingEnd) {
      require(bids[msg.sender].blindBid == bytes32(0) );
      bids[msg.sender] = Bid({blindBid: _blindBid, deposit:msg.value});
  }


  /// 公示你的出价，对于正确参与的出价，只要没有最终获胜，都会被归还
  function reveal(uint _value, uint nonce) public onlyAfter(biddingEnd) onlyBefore(revealEnd) returns (uint){
    //  uint length = bids[msg.sender].length;
    //  require(_values.length == length);
    //  require(_fake.length == length);
    //  require(_secret.length == length);
      require (_value != 0 && nonce != 0);

      uint refund;

      var bid = bids[msg.sender];
      uint value = _value * 1 ether;
      require(bid.blindBid == sha3(msg.sender, _value, nonce));
      // bid不正确，不会退回押金
      // 局部变量只能在离他最近的花括号中使用
      //  uint value = _value * 1 ether;
      refund += bid.deposit;
      if (bid.deposit >= value) {
          // 处理bid超过value的情况
          if(placeBid(msg.sender, value)){
                refund -= value;
          }
      }
      // 防止再次claimed押金
      bid.blindBid = bytes32(0);

      msg.sender.transfer(refund);  // 如果之前没有置0，会有fallback风险
      return refund;
  }

  // 这是个内部函数，只能被协约本身调用
  function placeBid(address bidder, uint value) internal returns(bool success){
      if(value <= highestBid){
          return false;
      }
      if (highestBidder != 0){
          // 返回押金给之前出价最高的人
          pendingReturns[highestBidder] += highestBid;
      }
      highestBid = value;
      highestBidder = bidder;
      return true;
  }

  // 撤回过多的出价
  function withdraw() public {
      uint amount = pendingReturns[msg.sender];
      if (amount > 0) {
          // 一定要先置0，规避风险
          msg.sender.transfer(amount);
      }
  }

  // 拍卖结束，把代币发给受益人
  function auctionEnd() public onlyAfter(revealEnd){
      require(!ended);
      ended = true;
      emit AuctionEnded(highestBidder, highestBid);
      beneficiary.transfer(highestBid);
  }

  function getBalance() public returns (uint) {
      return this.balance;
  }

  function setValue(uint _value) public payable returns (uint){
      require(beneficiary !=0 );
    //  uint value = _value * 1 ether;
    //  testValue = msg.value - value;
      placeBid(msg.sender, _value * 1 ether);

    //  sendValue(value);
      beneficiary.transfer(_value * 1 ether);
      msg.sender.transfer(msg.value - _value * 1 ether);
      return msg.value - _value * 1 ether;
  }

  function sendValue(uint _testValue) internal {

        beneficiary.transfer(_testValue);
  }

  function () public{
        revert();
  }
}
