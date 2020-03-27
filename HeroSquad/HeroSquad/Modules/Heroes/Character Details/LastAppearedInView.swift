import UIKit
import RxSwift
import RxCocoa

final class LastAppearedInView: UIView {
    
    private let disposeBag = DisposeBag()
    
    private lazy var containerView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 16
        return view
    }()
    
    private lazy var comicsContainerView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 16
        view.alignment = .leading
        view.distribution = .fillEqually
        return view
    }()
    
    private lazy var firstComicView = ComicView()
    private lazy var secondComicView = ComicView()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "more-comics-bg"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DesignStyling.Fonts.title3
        label.textColor = .white
        label.text = "Last appeared in"
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var moreComicsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DesignStyling.Fonts.headline
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(containerView)
        
        comicsContainerView.addArrangedSubview(firstComicView)
        comicsContainerView.addArrangedSubview(secondComicView)
        
        containerView.addArrangedSubview(titleLabel)
        containerView.addArrangedSubview(comicsContainerView)
        containerView.setCustomSpacing(24, after: comicsContainerView)
        containerView.addArrangedSubview(imageView)
        imageView.addSubview(moreComicsLabel)
        
        NSLayoutConstraint.activate([
            moreComicsLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 16),
            moreComicsLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -16),
            moreComicsLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(comics: Driver<(left: ComicDisplayItem?, right: ComicDisplayItem?)>,
                   showsMoreComicsSections: Driver<Bool>,
                   moreComicsTitle: Driver<String>) {
        
        comics
            .drive(onNext: { [weak self] comics in
                if let left = comics.left {
                    self?.firstComicView.cofigure(with: left)
                }
                if let right = comics.right {
                    self?.secondComicView.cofigure(with: right)
                }
            })
            .disposed(by: disposeBag)
        
        showsMoreComicsSections
            .drive(imageView.rx.isHidden)
            .disposed(by: disposeBag)
        
        moreComicsTitle
            .drive(moreComicsLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
}

private class ComicView: UIView {
    
    private let disposeBag = DisposeBag()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 4
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.backgroundColor = DesignStyling.Colours.stoneGray
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DesignStyling.Fonts.footnote
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        self.addSubview(stackView)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        
        titleLabel.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 192),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 0.7),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cofigure(with comicItem: ComicDisplayItem) {
        titleLabel.text = comicItem.comic.title
        
        comicItem.loadImage(size: .medium(aspectRatio: .portait))
            .drive(imageView.rx.image)
            .disposed(by: disposeBag)
    }
    
}
