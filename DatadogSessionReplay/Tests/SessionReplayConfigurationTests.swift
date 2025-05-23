/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-Present Datadog, Inc.
 */

#if os(iOS)
import XCTest
@_spi(Internal)
@testable import TestUtilities
@_spi(Internal)
@testable import DatadogSessionReplay

class SessionReplayConfigurationTests: XCTestCase {
    func testDefaultConfiguration() {
        // When
        let config = SessionReplay.Configuration()

        // Then
        XCTAssertEqual(config.replaySampleRate, 100)
        XCTAssertEqual(config.defaultPrivacyLevel, .mask)
        XCTAssertEqual(config.textAndInputPrivacyLevel, .maskAll)
        XCTAssertEqual(config.imagePrivacyLevel, .maskAll)
        XCTAssertEqual(config.touchPrivacyLevel, .hide)
        XCTAssertEqual(config.startRecordingImmediately, true)
        XCTAssertNil(config.customEndpoint)
        XCTAssertEqual(config._additionalNodeRecorders.count, 0)
    }

    func testDefaultConfigurationWithNewApi() {
        // When
        let config = SessionReplay.Configuration(
            textAndInputPrivacyLevel: .maskAll,
            imagePrivacyLevel: .maskAll,
            touchPrivacyLevel: .hide
        )

        // Then
        XCTAssertEqual(config.replaySampleRate, 100)
        XCTAssertEqual(config.defaultPrivacyLevel, .mask)
        XCTAssertEqual(config.textAndInputPrivacyLevel, .maskAll)
        XCTAssertEqual(config.imagePrivacyLevel, .maskAll)
        XCTAssertEqual(config.touchPrivacyLevel, .hide)
        XCTAssertEqual(config.startRecordingImmediately, true)
        XCTAssertNil(config.customEndpoint)
        XCTAssertEqual(config._additionalNodeRecorders.count, 0)
    }

    func testConfigurationWithAdditionalNodeRecorders() {
        let random: Float = .mockRandom(min: 0, max: 100)
        let mockNodeRecorder = SessionReplayNodeRecorderMock()

        // When
        var config = SessionReplay.Configuration(replaySampleRate: random)
        config.setAdditionalNodeRecorders([mockNodeRecorder])

        // Then
        XCTAssertEqual(config._additionalNodeRecorders.count, 1)
        XCTAssertEqual(config._additionalNodeRecorders[0].identifier, mockNodeRecorder.identifier)
    }

    func testConfigurationWithAdditionalNodeRecordersWithNewApi() {
        let mockNodeRecorder = SessionReplayNodeRecorderMock()

        // When
        var config = SessionReplay.Configuration(
            textAndInputPrivacyLevel: .maskAll,
            imagePrivacyLevel: .maskAll,
            touchPrivacyLevel: .hide
        )
        config.setAdditionalNodeRecorders([mockNodeRecorder])

        // Then
        XCTAssertEqual(config._additionalNodeRecorders.count, 1)
        XCTAssertEqual(config._additionalNodeRecorders[0].identifier, mockNodeRecorder.identifier)
    }
}
#endif
