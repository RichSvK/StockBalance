import Foundation
import UIKit

/// PropertyWrapper to dynamically get the color based on user interface dark / light theme
@propertyWrapper struct ColorElement {
    var wrappedValue: UIColor {
        return UIColor { theme in
            switch theme.userInterfaceStyle {
            case .dark:
                return dark
            case .light:
                return light
            default:
                return light
            }
        }
    }

    let light: UIColor
    let dark: UIColor

    init(light: UIColor, dark: UIColor) {
        self.light = light
        self.dark = dark
    }

    init(color: UIColor) {
        light = color
        dark = color
    }
}
