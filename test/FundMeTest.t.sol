// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe private fundMe;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    // function testDemo() external pure {
    //     console.log("Hello World");
    // }

    function testMinimumUsdIsFive() external view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testMsgSenderIsOwner() external view {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testAccurateDataFeedVersion() external view {
        assertEq(fundMe.getVersion(), 4);
    }
}
