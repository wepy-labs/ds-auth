/// auth.sol -- widely-used access control pattern for Ethereum

// Copyright (C) 2015, 2016, 2017  Nexus Development, LLC

// Licensed under the Apache License, Version 2.0 (the "License").
// You may not use this file except in compliance with the License.

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).

pragma solidity ^0.4.8;

import "ds-test/test.sol";

import "./auth.sol";

contract FakeVault is DSAuth {
    function access() auth {}
}

contract BooleanAuthority is DSAuthority {
    bool value;
    function BooleanAuthority(bool _value) { value = _value; }
    function canCall(
        address caller, address code, bytes4 sig
    ) constant returns (bool) {
        return value;
    }
}

contract DSAuthTest is DSTest, DSAuthEvents {
    FakeVault vault = new FakeVault();
    BooleanAuthority rejector = new BooleanAuthority(false);

    function test_owner() {
        expectEventsExact(vault);
        vault.access();
        vault.setAuthority(DSAuthority(0));
        LogSetAuthority(DSAuthority(0));
    }

    function testFail_non_owner_1() {
        vault.setAuthority(DSAuthority(0));
        vault.access();
    }

    function testFail_non_owner_2() {
        vault.setAuthority(DSAuthority(0));
        vault.setAuthority(DSAuthority(0));
    }

    function test_accepting_authority() {    
        vault.setAuthority(new BooleanAuthority(true));
        vault.access();
    }

    function testFail_rejecting_authority_1() {
        vault.setAuthority(new BooleanAuthority(false));
        vault.setAuthority(DSAuthority(0));
        vault.access();
    }

    function testFail_rejecting_authority_2() {
        vault.setAuthority(new BooleanAuthority(false));
        vault.setAuthority(DSAuthority(0));
        vault.setAuthority(DSAuthority(0));
    }

    function testFail_rejecting_authority_3() {
        vault.setAuthority(new BooleanAuthority(false));
        vault.setAuthority(DSAuthority(0));
        vault.setAuthority(DSAuthority(0));
    }
}
