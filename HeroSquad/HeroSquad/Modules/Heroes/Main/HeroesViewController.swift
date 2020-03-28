import UIKit
import RxSwift
import RxCocoa

final class HeroesViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    private lazy var heroesList: HeroesListViewController = {
        return HeroesListViewController()
    }()
    
    private lazy var mySquadList: MySquadViewController =  {
        return MySquadViewController()
    }()
    
    private let viewModel: HeroesViewModelType
    
    init(viewModel: HeroesViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }
    
    func setupUI() {
        self.view.backgroundColor = DesignStyling.Colours.darkBlueGray
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "marvel-logo"))
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "icon_back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "icon_back")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        self.view.addSubview(stackView)
        
        self.addChild(self.mySquadList)
        stackView.addArrangedSubview(self.mySquadList.view)
        self.mySquadList.didMove(toParent: self)
        
        self.addChild(self.heroesList)
        stackView.addArrangedSubview(self.heroesList.view)
        self.heroesList.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mySquadList.view.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.45, constant: 0),
            ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = DesignStyling.Colours.darkBlueGray
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func setupBindings() {
        
        self.viewModel.heroes.drive(
            self.heroesList.collectionView.rx.items(cellIdentifier: HeroCollectionViewCell.identifier, cellType: HeroCollectionViewCell.self)) { row, item, cell in
                cell.configure(with: item)
        }.disposed(by: disposeBag)
            
        rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .take(1)
            .map { _ in }
            .bind(to: self.viewModel.viewLoaded)
            .disposed(by: disposeBag)
        
        
        self.heroesList.collectionView.rx.reachedBottom
            .map { _ in }
            .bind(to: self.viewModel.nextPageTriggered)
            .disposed(by: disposeBag)
        
        self.heroesList.collectionView.rx
            .modelSelected(HeroDisplayItemViewModel.self)
            .bind(to: self.viewModel.heroSelected)
            .disposed(by: disposeBag)
        
        self.viewModel.showsMySquad
            .drive(self.mySquadList.view.rx.isHidden)
            .disposed(by: disposeBag)
        
        self.viewModel.mySquadHeroes.drive(
            self.mySquadList.collectionView.rx.items(cellIdentifier: MySquadHeroCollectionViewCell.identifier, cellType: MySquadHeroCollectionViewCell.self)) { row, item, cell in
                cell.configure(with: item)
        }.disposed(by: disposeBag)
        
        self.mySquadList.collectionView.rx
            .modelSelected(HeroDisplayItemViewModel.self)
            .bind(to: self.viewModel.heroSelected)
            .disposed(by: disposeBag)
            
    }
}

