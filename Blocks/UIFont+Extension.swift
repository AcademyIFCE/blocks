import UIKit

extension UIFont {
    
    class func preferredFont(forTextStyle style: UIFont.TextStyle, weight: Weight = .regular) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let descriptor = preferredFont(forTextStyle: style).fontDescriptor
        let font = UIFont.systemFont(ofSize: descriptor.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
    }
    
}
