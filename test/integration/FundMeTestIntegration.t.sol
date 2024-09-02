// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;
import {FundMe} from "../..//src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {Test} from "forge-std/Test.sol";
import {WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe public fundMe;
    DeployFundMe deployFundMe;

    uint256 public constant SEND_VALUE = 0.5 ether;
    uint256 public constant STARTING_USER_BALANCE = 10 ether;

    address JOHN = makeAddr("john");

    function setUp() public {
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(JOHN, STARTING_USER_BALANCE);
    }

    function userCanFundAndOwnerWithdraw() public {
        uint256 preUserBalance = address(JOHN).balance;
        uint256 preOwnerBalance = address(fundMe.getOwner()).balance;

        vm.prank(JOHN);
        fundMe.fund{value: SEND_VALUE}();

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        uint256 postUserBalance = address(JOHN).balance;
        uint256 postOwnerBalance = address(fundMe.getOwner()).balance;

        assert(address(fundMe).balance == 0);
        assert(preUserBalance - postUserBalance == SEND_VALUE);
        assert(postOwnerBalance - SEND_VALUE == preOwnerBalance);
    }
}
