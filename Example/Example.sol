pragma solidity ^0.4.24;

/*

  This is just a very simple example contract used to demonstrate the BouncerProxy making calls to it

*/


contract Example {

  constructor() public { }

  //it keeps a count to demonstrate stage changes
  uint public count = 0;
  //and it can add to a count
  function addAmount(uint256 amount) public returns (bool) {
    count = count + amount;
    return true;
  }

  function accounce(bytes32 _message) public returns (bool) {
    emit Announce(_message,now,msg.sender,address(this));
  }
  event Announce(bytes32 message,uint256 timestamp,address sender,address context);

}
