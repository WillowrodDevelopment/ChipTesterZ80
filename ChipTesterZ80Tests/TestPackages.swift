//
//  TestPackages.swift
//  ChipTesterZ80
//
//  Created by Mike Hall on 17/03/2025.
//

import Testing
@testable import ChipTesterZ80

struct TestBatch {

    @Test func testTo0x7F() async throws {
        for a in 0..<128 {
            testID = UInt8(a).hex()
            try await _Z80Test().runTest()
        }
    }
    
    @Test func testTo0xFF() async throws {
        for a in 128..<256 {
            testID = UInt8(a).hex()
            try await _Z80Test().runTest()
        }
    }
    
    @Test func testTo0xCB7F() async throws {
        for a in 0..<128 {
            testID = "CB " + UInt8(a).hex()
            try await _Z80Test().runTest()
        }
    }
    
    @Test func testTo0xCBFF() async throws {
        for a in 128..<256 {
            testID = "CB " + UInt8(a).hex()
            try await _Z80Test().runTest()
        }
    }
    
    @Test func testTo0xDD7F() async throws {
        for a in 0..<128 {
            testID = "DD " + UInt8(a).hex()
            try await _Z80Test().runTest()
        }
    }
    
    @Test func testTo0xDDFF() async throws {
        for a in 128..<256 {
            testID = "DD " + UInt8(a).hex()
            try await _Z80Test().runTest()
        }
    }
    
    @Test func testTo0xDDCB7F() async throws {
        for a in 0..<128 {
            testID = "DD CB __ " + UInt8(a).hex()
            try await _Z80Test().runTest()
        }
    }
    
    @Test func testTo0xDDCBFF() async throws {
        for a in 128..<256 {
            testID = "DD CB __ " + UInt8(a).hex()
            try await _Z80Test().runTest()
        }
    }
    
    @Test func testTo0xED7F() async throws {
        for a in 0..<128 {
            testID = "ED " + UInt8(a).hex()
            try await _Z80Test().runTest()
        }
    }
    
    @Test func testTo0xEDFF() async throws {
        for a in 128..<256 {
            testID = "ED " + UInt8(a).hex()
            try await _Z80Test().runTest()
        }
    }
    
    @Test func testTo0xFD7F() async throws {
        for a in 0..<128 {
            testID = "FD " + UInt8(a).hex()
            try await _Z80Test().runTest()
        }
    }
    
    @Test func testTo0xFDFF() async throws {
        for a in 128..<256 {
            testID = "FD " + UInt8(a).hex()
            try await _Z80Test().runTest()
        }
    }
    
    @Test func testTo0xFDCB7F() async throws {
        for a in 0..<128 {
            testID = "FD CB __ " + UInt8(a).hex()
            try await _Z80Test().runTest()
        }
    }
    
    @Test func testTo0xFDCBFF() async throws {
        for a in 128..<256 {
            testID = "FD CB __ " + UInt8(a).hex()
            try await _Z80Test().runTest()
        }
    }


}
