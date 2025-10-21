import UIKit

enum Theme {
    static let primary = UIColor.systemIndigo
    static let secondary = UIColor.systemTeal
    static let background = UIColor.systemBackground
    static let textPrimary = UIColor.label
    static let textSecondary = UIColor.secondaryLabel
    static let cornerRadius: CGFloat = 12

    static func applyGlobalAppearance() {
        UINavigationBar.appearance().tintColor = .white
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = primary
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance

        UISegmentedControl.appearance().selectedSegmentTintColor = primary
        UISegmentedControl.appearance().setTitleTextAttributes([
            .foregroundColor: UIColor.label
        ], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([
            .foregroundColor: UIColor.white
        ], for: .selected)
    }
}


