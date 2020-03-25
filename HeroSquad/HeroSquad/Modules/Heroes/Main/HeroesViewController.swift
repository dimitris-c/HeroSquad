import UIKit

final class HeroesViewController: UIViewController {

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
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.barTintColor = DesignStyling.Colours.darkBlueGray
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "marvel-logo"))
        self.view.backgroundColor = DesignStyling.Colours.darkBlueGray
        
        
    }
    
}
