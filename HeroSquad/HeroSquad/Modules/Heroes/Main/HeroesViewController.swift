import UIKit
import RxSwift
import RxCocoa

final class HeroesViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    private let heroesList: HeroesListViewController = {
        return HeroesListViewController()
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
        self.navigationController?.navigationBar.barTintColor = DesignStyling.Colours.darkBlueGray
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "marvel-logo"))
        self.view.backgroundColor = DesignStyling.Colours.darkBlueGray
        
        self.addChild(self.heroesList)
        self.view.addSubview(self.heroesList.view)
        self.heroesList.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            heroesList.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            heroesList.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            heroesList.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            heroesList.view.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        
    }
    
    func setupBindings() {
        
        self.viewModel.heroes.drive(
            self.heroesList.collectionView.rx.items(cellIdentifier: HeroCollectionViewCell.identifier, cellType: HeroCollectionViewCell.self)) { row, item, cell in
                cell.configure(with: item)
        }.disposed(by: disposeBag)
                rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map { _ in }
            .bind(to: self.viewModel.viewLoaded)
            .disposed(by: disposeBag)
        
        
        self.heroesList.collectionView.rx.reachedBottom
            .map { _ in }
            .bind(to: self.viewModel.nextPageTriggered)
            .disposed(by: disposeBag)
    }
}
