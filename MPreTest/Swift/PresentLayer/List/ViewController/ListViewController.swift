import UIKit
import Combine

class ListViewController: UIViewController {
    private var tableView: ListTableView!
    private var collectionView: ListCollectionView!
    private var activityIndicator: UIActivityIndicatorView!
    private var viewModel: ListViewModelType!
    private var cancellables: Set<AnyCancellable> = []

    // 의존성 주입을 위한 초기화 메서드
    init(viewModel: ListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bindViewModel()
        
        viewModel.getData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateLayout(for: size)
    }
    
    private func setupViews() {
        tableView = ListTableView(frame: .zero, style: .plain)
        collectionView = ListCollectionView()
        activityIndicator = UIActivityIndicatorView(style: .large)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        tableView.itemSelected = { [weak self] item in
            self?.handleItemSelected(item, cell: nil)
        }
        
        collectionView.itemSelected = { [weak self] item, cell in
            self?.handleItemSelected(item, cell: cell)
        }
        
        updateLayout(for: view.bounds.size)
    }
    
    private func bindViewModel() {
        viewModel.listPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                let presentData = list
                self?.tableView.items = presentData
                self?.collectionView.items = presentData
                self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
        
        viewModel.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleItemSelected(_ item: ListPresentData, cell: ListCollectionViewCell?) {
        let webVC = WebViewController()
        webVC.url = item.url // URL을 item에서 가져오도록 변경
        webVC.pageTitle = item.title
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    private func updateLayout(for size: CGSize) {
        let isLandscape = size.width > size.height
        tableView.isHidden = isLandscape
        collectionView.isHidden = !isLandscape
    }
}
