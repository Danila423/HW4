import UIKit

extension UIColor {
    // MARK: - HEX Initialization
    convenience init?(hexString: String) {
        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        let length = hexSanitized.count
        guard length == 6 || length == 8 else { return nil }

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red, green, blue, alpha: CGFloat
        if length == 6 {
            red = CGFloat((rgb & 0xFF0000) >> 16) / 255
            green = CGFloat((rgb & 0x00FF00) >> 8) / 255
            blue = CGFloat(rgb & 0x0000FF) / 255
            alpha = 1.0
        } else {
            red = CGFloat((rgb & 0xFF000000) >> 24) / 255
            green = CGFloat((rgb & 0x00FF0000) >> 16) / 255
            blue = CGFloat((rgb & 0x0000FF00) >> 8) / 255
            alpha = CGFloat(rgb & 0x000000FF) / 255
        }

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
