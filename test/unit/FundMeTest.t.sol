// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe public fundMe;
    uint256 send_value = 5e18;
    uint256 constant STARTING_BALANCE = 10e18;
    address USER = makeAddr("John");

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: send_value}();
        _;
    }

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    // function testDemo() external pure {
    //     console.log("Hello World");
    // }

    function testMinimumUsdIsFive() external view {
        assertEq(fundMe.MINIMUM_USD(), send_value);
    }

    function testMsgSenderIsOwner() external view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testAccurateDataFeedVersion() external view {
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundFailsWithoutEonughEth() external {
        // console.log("Funding contract without enough ETH");
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundUpdatesFundedDataStructure() external funded {
        uint256 currentAmount = fundMe.getAddressToAmountFunded(USER);
        assertEq(currentAmount, send_value);
    }

    function testAddFundsToArrayOfFunders() external funded {
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    function testOnlyOwnerCanWithdraw() external funded {
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawFromSIngleFunder() external funded {
        // Arrange
        uint256 fundMeStaringBalance = address(fundMe).balance;
        uint256 ownerStartingBalance = fundMe.getOwner().balance;
        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();
        // Assert
        uint256 fundMeEndingBalance = address(fundMe).balance;
        uint256 ownerEndingBalance = fundMe.getOwner().balance;
        assertEq(fundMeEndingBalance, 0);
        assertEq(
            fundMeStaringBalance + ownerStartingBalance,
            ownerEndingBalance
        );
    }

    function testCheapWithdrawFromSIngleFunder() external funded {
        // Arrange
        uint256 fundMeStaringBalance = address(fundMe).balance;
        uint256 ownerStartingBalance = fundMe.getOwner().balance;
        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();
        // Assert
        uint256 fundMeEndingBalance = address(fundMe).balance;
        uint256 ownerEndingBalance = fundMe.getOwner().balance;
        assertEq(fundMeEndingBalance, 0);
        assertEq(
            fundMeStaringBalance + ownerStartingBalance,
            ownerEndingBalance
        );
    }

    function testCheapWithdrawFromMultipleFunders() external {
        // ARRANGE
        // Generate and fund 10 different Accounts
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for (
            uint160 i = startingFunderIndex;
            i < numberOfFunders + startingFunderIndex;
            i++
        ) {
            hoax(address(i), send_value);
            fundMe.fund{value: send_value}();
        }
        uint256 funderStartingBalance = address(fundMe).balance;
        uint256 ownerStartingBalance = fundMe.getOwner().balance;

        // ACT
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();
        // ASSERT

        uint256 fundMeEndingBalance = address(fundMe).balance;
        uint256 ownerEndingBalance = fundMe.getOwner().balance;

        assert(fundMeEndingBalance == 0);
        assert(
            funderStartingBalance + ownerStartingBalance == ownerEndingBalance
        );
        assert(
            numberOfFunders * send_value ==
                ownerEndingBalance - ownerStartingBalance
        );
        // console.log(numberOfFunders * send_value);
        // console.log(ownerStartingBalance - STARTING_BALANCE);
        // console.log(ownerEndingBalance - ownerStartingBalance);
    }

    function testWithdrawFromMultipleFunders() external {
        // ARRANGE
        // Generate and fund 10 different Accounts
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for (
            uint160 i = startingFunderIndex;
            i < numberOfFunders + startingFunderIndex;
            i++
        ) {
            hoax(address(i), send_value);
            fundMe.fund{value: send_value}();
        }
        uint256 funderStartingBalance = address(fundMe).balance;
        uint256 ownerStartingBalance = fundMe.getOwner().balance;

        // ACT
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();
        // ASSERT

        uint256 fundMeEndingBalance = address(fundMe).balance;
        uint256 ownerEndingBalance = fundMe.getOwner().balance;

        assert(fundMeEndingBalance == 0);
        assert(
            funderStartingBalance + ownerStartingBalance == ownerEndingBalance
        );
        assert(
            numberOfFunders * send_value ==
                ownerEndingBalance - ownerStartingBalance
        );
        // console.log(numberOfFunders * send_value);
        // console.log(ownerStartingBalance - STARTING_BALANCE);
        // console.log(ownerEndingBalance - ownerStartingBalance);
    }
}
