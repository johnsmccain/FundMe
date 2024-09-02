// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;
import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract FundFundMe is Script {
    uint256 SEND_VALUE = 0.5 ether;

    function fundFundMe(address mostRecentDeploy) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentDeploy)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded FundMe with %s", SEND_VALUE);
    }

    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        fundFundMe(mostRecentDeployed);
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentDeploy) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentDeploy)).withdraw();
        vm.stopBroadcast();
        console.log("Withdrawal complete");
    }

    function run() public {
        address mostRecentDeploy = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        withdrawFundMe(mostRecentDeploy);
    }
}
