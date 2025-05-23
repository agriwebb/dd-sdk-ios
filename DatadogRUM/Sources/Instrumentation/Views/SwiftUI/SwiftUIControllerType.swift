/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-Present Datadog, Inc.
 */

/// Controller type enum to identify different SwiftUI hosting controllers
internal enum ControllerType {
    case hostingController
    case navigationStackHostingController
    case modal
    case unknown

    /// Determines the controller type from the class name
    init(from className: String) {
        if className.hasPrefix("_TtGC7SwiftUI19UIHostingController") {
            self = .hostingController
        } else if className.contains("Navigation") {
            self = .navigationStackHostingController
        } else if className.hasPrefix("_TtGC7SwiftUI29PresentationHostingController") {
            self = .modal
        } else {
            self = .unknown
        }
    }
}
