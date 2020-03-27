import UIKit
import RxSwift
import RxCocoa

final class CharacterDetailsViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let viewModel: CharacterDetailsViewModel
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private lazy var contentView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 16
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16)
        return view
    }()
    
    private lazy var characterImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        return view
    }()
    private lazy var characterNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DesignStyling.Fonts.largeTitle
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var addToSquadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("💪 Recruit to Squad", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return button
    }()
    
    private lazy var characterDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DesignStyling.Fonts.body
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
//    private lazy var activityIndicator: UIActivityIndicatorView = {
//        let view = UIActivityIndicatorView(style: .whiteLarge)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.color = UIColor.darkGray
//        view.hidesWhenStopped = true
//        return view
//    }()
    
    private lazy var lastAppearedIn = LastAppearedInView()
    
    init(viewModel: CharacterDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .clear
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .white
        self.view.backgroundColor = DesignStyling.Colours.darkBlueGray
        
        setupUI()
        setupBindings()
    }
    
    func setupUI(){
        self.view.addSubview(scrollView)
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(container)
        
        container.addSubview(characterImageView)
        container.addSubview(contentView)
        contentView.addArrangedSubview(characterNameLabel)
        contentView.addArrangedSubview(addToSquadButton)
        contentView.addArrangedSubview(characterDescriptionLabel)
        contentView.addArrangedSubview(lastAppearedIn)
        
        characterNameLabel.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        characterDescriptionLabel.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        
        let frameGuide = scrollView.frameLayoutGuide
        let contentGuide = scrollView.contentLayoutGuide
        
        NSLayoutConstraint.activate([
            frameGuide.topAnchor.constraint(equalTo: view.topAnchor),
            frameGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            frameGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            frameGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            //
            container.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentGuide.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor),
            container.widthAnchor.constraint(equalTo: frameGuide.widthAnchor),
            //
            characterImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            characterImageView.topAnchor.constraint(equalTo: container.topAnchor),
            characterImageView.bottomAnchor.constraint(equalTo: contentView.topAnchor),
            characterImageView.widthAnchor.constraint(equalTo: container.widthAnchor),
            characterImageView.heightAnchor.constraint(equalTo: characterImageView.widthAnchor),
            //
            contentView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: container.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
    }
    
    func setupBindings() {
        
        viewModel.characterName
            .drive(characterNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.characterDescription
            .drive(characterDescriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.characterImage
            .drive(characterImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.showsLastAppearedInSection
            .drive(lastAppearedIn.rx.isHidden)
            .disposed(by: disposeBag)
        
        lastAppearedIn.configure(comics: viewModel.latestComics.asDriver(),
                                 showsMoreComicsSections: viewModel.showsMoreComicsSection,
                                 moreComicsTitle: viewModel.moreComicsTitle)
        
    }
}
