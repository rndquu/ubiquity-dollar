// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {console} from "forge-std/console.sol";
import {IMetaPool} from "../../../src/dollar/interfaces/IMetaPool.sol";
import {MockMetaPool} from "../../../src/dollar/mocks/MockMetaPool.sol";
import "../DiamondTestSetup.sol";

contract TWAPOracleDollar3poolFacetTest is DiamondTestSetup {
    address curve3CRVTokenAddress = address(0x333);
    address twapOracleAddress;
    address metaPoolAddress;

    function setUp() public override {
        super.setUp();

        metaPoolAddress = address(
            new MockMetaPool(address(dollarToken), curve3CRVTokenAddress)
        );
        vm.prank(owner);
        twapOracleDollar3PoolFacet.setPool(
            metaPoolAddress,
            curve3CRVTokenAddress
        );
    }

    function test_overall() public {
        // set the mock data for meta pool
        uint256[2] memory _price_cumulative_last = [
            uint256(100e18),
            uint256(100e18)
        ];
        uint256 _last_block_timestamp = 20000;
        uint256[2] memory _twap_balances = [uint256(100e18), uint256(100e18)];
        uint256[2] memory _dy_values = [uint256(100e18), uint256(100e18)];
        MockMetaPool(metaPoolAddress).updateMockParams(
            _price_cumulative_last,
            _last_block_timestamp,
            _twap_balances,
            _dy_values
        );
        twapOracleDollar3PoolFacet.update();

        uint256 amount0Out = twapOracleDollar3PoolFacet.consult(
            address(dollarToken)
        );
        uint256 amount1Out = twapOracleDollar3PoolFacet.consult(
            curve3CRVTokenAddress
        );
        assertEq(amount0Out, 100e18);
        assertEq(amount1Out, 100e18);
    }

    function testTwap() public {
        IMetaPool lusdCurveMetapool = IMetaPool(
            0xEd279fDD11cA84bEef15AF5D39BB4d4bEE23F0cA
        );

        uint blockYesterday = 18819964; // Dec-19-2023
        uint blockToday = 18825724; // Dec-20-2023

        // Price cumulative last (LUSD): 2603727459113212177341913373130534
        // Price cumulative last (3CRV-LP): 4906263668185139154944097811383097
        // Block timestamp last: 1702981559
        //
        // vm.createSelectFork("https://eth.llamarpc.com", blockYesterday);
        // uint256[2] memory priceCumulativeLast = lusdCurveMetapool.get_price_cumulative_last();
        // uint blockTimestampLast = lusdCurveMetapool.block_timestamp_last();
        // console.log('Price cumulative last (LUSD):', priceCumulativeLast[0]);
        // console.log('Price cumulative last (3CRV-LP):', priceCumulativeLast[1]);
        // console.log('Block timestamp last:', blockTimestampLast);

        // Price cumulative last (LUSD): 2604462177166311753456630214638606
        // Price cumulative last (3CRV-LP): 4906575496469619004999432712098561
        // Block timestamp last: 1703045123
        //
        // vm.createSelectFork("https://eth.llamarpc.com", blockToday);
        // uint256[2] memory priceCumulativeLast = lusdCurveMetapool.get_price_cumulative_last();
        // uint blockTimestampLast = lusdCurveMetapool.block_timestamp_last();
        // console.log('Price cumulative last (LUSD):', priceCumulativeLast[0]);
        // console.log('Price cumulative last (3CRV-LP):', priceCumulativeLast[1]);
        // console.log('Block timestamp last:', blockTimestampLast);

        vm.createSelectFork("https://uk.rpc.blxrbdn.com");

        uint blockTimestampFirst = 1702981559;
        uint256[2] memory priceCumulativeFirst = [
            uint256(2603727459113212177341913373130534),
            uint256(4906263668185139154944097811383097)
        ];

        uint blockTimestampLast = 1703045123;
        uint256[2] memory priceCumulativeLast = [
            uint256(2604462177166311753456630214638606),
            uint256(4906575496469619004999432712098561)
        ];

        uint256[2] memory twapBalances = lusdCurveMetapool.get_twap_balances(
            priceCumulativeFirst,
            priceCumulativeLast,
            blockTimestampLast - blockTimestampFirst
        );

        uint priceAvgToken0 = lusdCurveMetapool.get_dy(
            0,
            1,
            1e18,
            twapBalances
        );

        uint priceAvgToken1 = lusdCurveMetapool.get_dy(
            1,
            0,
            1e18,
            twapBalances
        );

        console.log("Price (LUSD):", priceAvgToken0);
        console.log("Price (3CRV-LP):", priceAvgToken1);
    }
}
