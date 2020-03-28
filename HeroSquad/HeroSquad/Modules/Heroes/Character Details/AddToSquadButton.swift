import UIKit

final class AddToSquadButton: UIButton {

    private let innerView: UIView = UIView()
    
    override var isHighlighted: Bool {
        didSet {
            self.updateContent()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.updateContent()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.addSubview(innerView)
        self.innerView.backgroundColor = DesignStyling.Colours.red
        self.innerView.isUserInteractionEnabled = false
        self.innerView.translatesAutoresizingMaskIntoConstraints = false
        self.innerView.layer.cornerRadius = 8
        self.innerView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            self.innerView.topAnchor.constraint(equalTo: self.topAnchor),
            self.innerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.innerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.innerView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateContent() {
        
        if isSelected {
            self.innerView.backgroundColor = DesignStyling.Colours.darkBlueGray
            self.innerView.layer.borderColor = isHighlighted ? DesignStyling.Colours.darkRed.cgColor : DesignStyling.Colours.red.cgColor
            self.innerView.layer.borderWidth = 3
        } else {
            self.innerView.backgroundColor = isHighlighted ? DesignStyling.Colours.darkRed : DesignStyling.Colours.red
            self.innerView.layer.borderWidth = 0
        }
        
        self.innerView.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.98, y: 0.98) : CGAffineTransform(scaleX: 1, y: 1)
    }
    
}
