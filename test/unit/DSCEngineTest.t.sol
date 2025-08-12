//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployDsc} from "../../script/DeployDsc.s.sol";
import {DecentralizedStableCoin} from "../../src/DecentralizedStableCoin.sol";
import {DSCEngine} from "../../src/DSCEngine.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract DSCEngineTest is Test {
    DecentralizedStableCoin dsc;
    DSCEngine dscEngine;
    DeployDsc deployer;
    HelperConfig config;
    address ethUsdPriceFeed;
    address weth;
    address public USER = makeAddr("user");
    uint256 public AMOUNT_COLLATERAL = 10 ether;
    uint256 public STARTING_ERC20_BALANCE = 10 ether;

    function setUp() public {
        deployer = new DeployDsc();
        (dsc, dscEngine, config) = deployer.run();
        (ethUsdPriceFeed,, weth,,) = config.activeNetworkConfig();
        ERC20Mock(weth).mint(USER, STARTING_ERC20_BALANCE);
    }

    //////////////////////
    // PRICE TESTS   /////
    //////////////////////

    function testGetUsdValue() public view {
        uint256 ethAmount = 15 ether;
        // 15e18 * 2000/ETH = 30000e18;
        uint256 expectedUsdValue = 30000e18;
        uint256 actualUsdValue = dscEngine.getUsdValue(weth, ethAmount);
        assertEq(actualUsdValue, expectedUsdValue);
    }

    ////////////////////////////////
    // DEPOSIT COLLATERAL TEST /////
    ////////////////////////////////

    function testRevertIfCollateralIsZero() public {
        vm.startPrank(USER);

        ERC20Mock(weth).approve(address(dscEngine), AMOUNT_COLLATERAL);

        vm.expectRevert(DSCEngine.DSCEngine__NeedsMoreThanZero.selector);
        dscEngine.depositCollateral(weth, 0);
        vm.stopPrank();
    }
}
