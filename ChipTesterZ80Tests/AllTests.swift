//
//  AllTests.swift
//  ChipTesterZ80
//
//  Created by Mike Hall on 18/03/2025.
//

import Testing
@testable import ChipTesterZ80

struct AllTests {

    @Test func runAllTests() async throws {
        let tests = TestBatch()
        try await tests.testTo0x7F()
        try await tests.testTo0xFF()
        try await tests.testTo0xCB7F()
        try await tests.testTo0xCBFF()
        try await tests.testTo0xDD7F()
        try await tests.testTo0xDDFF()
        try await tests.testTo0xDDCB7F()
        try await tests.testTo0xDDCBFF()
        try await tests.testTo0xED7F()
        try await tests.testTo0xEDFF()
        try await tests.testTo0xFD7F()
        try await tests.testTo0xFDFF()
        try await tests.testTo0xFDCB7F()
        try await tests.testTo0xFDCBFF()
    }


}
