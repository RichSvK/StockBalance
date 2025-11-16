import Foundation
import UIKit

enum ColorToken {
    // MARK: - Core Colors
    @ColorElement(light: UIColor.from("#FFFFFF"), dark: UIColor.from("#000000"))
    static var blackWhiteColor: UIColor
    
    // White
    @ColorElement(light: UIColor.from("#000000"), dark: UIColor.from("#FFFFFF"))
    static var whiteBlackColor: UIColor

    // Green
    @ColorElement(light: UIColor.from("#35C759"), dark: UIColor.from("#35C759"))
    static var greenColor: UIColor

    @ColorElement(light: UIColor.from("#afd0a9"), dark: UIColor.from("#afd0a9"))
    static var disabledGreen: UIColor

    // Red
    @ColorElement(light: UIColor.from("#F5392E"), dark: UIColor.from("#F5392E"))
    static var redColor: UIColor
}
