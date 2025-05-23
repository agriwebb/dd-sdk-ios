/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-Present Datadog, Inc.
 */

import Foundation
@testable import DatadogCore

/// `CoreDirectory` pointing to subfolders in `/var/folders/`.
/// This location does not exist by default and should be created and deleted by calling `.create()` and `.delete()` in each test,
/// which guarantees clear state before and after test.
let temporaryCoreDirectory = temporaryUniqueCoreDirectory()

/// `CoreDirectory` pointing to subfolders in `/var/folders/`.
/// This location does not exist by default and should be created and deleted by calling `.create()` and `.delete()` in each test,
func temporaryUniqueCoreDirectory(uuid: UUID = UUID()) -> CoreDirectory {
    return CoreDirectory(
        osDirectory: .init(url: obtainUniqueTemporaryDirectory()),
        coreDirectory: .init(url: obtainUniqueTemporaryDirectory())
    )
}

extension CoreDirectory {
    /// Creates temporary core directory.
    @discardableResult
    func create() throws -> Self {
        try osDirectory.create()
        try coreDirectory.create()
        return self
    }

    /// Deletes temporary core directory.
    func delete() throws {
        try osDirectory.delete()
        try coreDirectory.delete()
    }
}

/// `FeatureDirectories` pointing to subfolders in `/var/folders/`.
/// Those subfolders do not exist by default and should be created and deleted by calling `.create()` and `.delete()` in each test,
/// which guarantees clear state before and after test.
let temporaryFeatureDirectories = FeatureDirectories(
    unauthorized: .init(url: obtainUniqueTemporaryDirectory()),
    authorized: .init(url: obtainUniqueTemporaryDirectory())
)

extension FeatureDirectories {
    /// Creates temporary folder for each directory.
    func create() throws {
        try authorized.create()
        try unauthorized.create()
    }

    /// Deletes each temporary folder.
    func delete() throws {
        try authorized.delete()
        try unauthorized.delete()
    }
}

/// Extends `Directory` with set of utilities for convenient work with files in tests.
/// Provides handy methods to create / delete files and directories.
extension Directory {
    /// Creates empty directory with given attributes .
    @discardableResult
    func create(attributes: [FileAttributeKey: Any]? = nil, file: StaticString = #file, line: UInt = #line) throws -> Self {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: attributes)
        let initialFilesCount = try files().count

        if initialFilesCount > 0 {
            throw ErrorMock("🔥 `Directory` is not empty: \(url)")
        }
        return self
    }

    /// Deletes entire directory with its content.
    func delete(file: StaticString = #file, line: UInt = #line) throws {
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
    }

    /// Checks if directory exists.
    func exists() -> Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }

    func createMockFiles(count: Int, prefix: String = "file") {
        (0..<count).forEach { index in
            _ = try! createFile(named: "\(prefix)\(index)")
        }
    }
}
