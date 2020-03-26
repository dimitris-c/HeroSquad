import UIKit
import RxSwift
import RxCocoa

class HeroCollectionViewCell: UICollectionViewCell {
    static let identifier = "hero.list.cell.id"
    
    private var disposeBag = DisposeBag()
    
    private let background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = DesignStyling.Colours.stoneGray
        view.layer.cornerRadius = 8
        return view
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.white
        imageView.frame.size = CGSize(width: 44, height: 44)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.width * 0.5
        return imageView
    }()
    
     let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DesignStyling.Fonts.headline
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private let chevron: UIImageView = {
        let view = UIImageView(image: UIImage(named: "chevron"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.contentView.addSubview(self.background)
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.chevron)
        
        self.titleLabel.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        
        NSLayoutConstraint.activate([
            self.background.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            self.imageView.widthAnchor.constraint(equalToConstant: 44),
            self.imageView.heightAnchor.constraint(equalToConstant: 44),
            self.imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            self.titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -16),
            self.chevron.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            self.chevron.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
    }
    
    func configure(with item: HeroDisplayItemViewModel) {
        self.titleLabel.text = item.name
        
        item.loadImage(with: .small(aspectRatio: .square))
            .drive(self.imageView.rx.image)
            .disposed(by: disposeBag)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        imageView.image = nil
        disposeBag = DisposeBag()
    }
}
