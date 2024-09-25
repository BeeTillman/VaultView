import UIKit

enum Appearance: String, CaseIterable, Identifiable {
    case light
    case dark
    case system

    var id: String { self.rawValue }
}

class AppearanceManager {
    static let shared = AppearanceManager()

    func setAppearance(_ appearance: Appearance) {
        switch appearance {
        case .light:
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
        case .dark:
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
        case .system:
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .unspecified
        }
    }
}
