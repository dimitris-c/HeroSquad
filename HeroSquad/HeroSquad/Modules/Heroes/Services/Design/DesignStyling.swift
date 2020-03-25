import UIKit

struct DesignStyling {

    struct Fonts {
        private static func fontTrait(with weight: UIFont.Weight) -> [UIFontDescriptor.TraitKey: Any] {
            return [UIFontDescriptor.TraitKey.weight : weight]
        }
        
        static var body: UIFont {
            let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
                .addingAttributes([UIFontDescriptor.AttributeName.traits : fontTrait(with: .regular)])
            return UIFont(descriptor: fontDescriptor, size: 17)
        }
        
        static var footnote: UIFont {
            let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .footnote)
                .addingAttributes([UIFontDescriptor.AttributeName.traits : fontTrait(with: .semibold)])
            return UIFont(descriptor: fontDescriptor, size: 13)
        }
        
        static var headline: UIFont {
            let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline)
                .addingAttributes([UIFontDescriptor.AttributeName.traits : fontTrait(with: .semibold)])
            return UIFont(descriptor: fontDescriptor, size: 17)
        }
        
        static var largeTitle: UIFont {
            let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle)
                .addingAttributes([UIFontDescriptor.AttributeName.traits : fontTrait(with: .bold)])
            return UIFont(descriptor: fontDescriptor, size: 34)
        }
        
        static var title3: UIFont {
           let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title3)
               .addingAttributes([UIFontDescriptor.AttributeName.traits : fontTrait(with: .semibold)])
           return UIFont(descriptor: fontDescriptor, size: 20)
        }
    }
    
    struct Colours {
        static let darkBlueGray = UIColor(red: 0.13, green: 0.15, blue: 0.17, alpha: 1.0)
        static let red = UIColor(red: 0.95, green: 0.05, blue: 0.04, alpha: 1.0)
        static let darkRed = UIColor(red: 0.74, green: 0.00, blue: 0.00, alpha: 1.00)
        static let stoneGray = UIColor(red: 0.21, green: 0.23, blue: 0.27, alpha: 1.00)
        static let stoneGrayLight = UIColor(red: 0.29, green: 0.32, blue: 0.37, alpha: 1.00)
    }
    
}
