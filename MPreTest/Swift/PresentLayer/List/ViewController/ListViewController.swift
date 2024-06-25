import UIKit
import Combine

class ListViewController: UIViewController {
    private var tableView: UITableView!
    private var scrollView: ListScrollView!
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
        
        self.view.backgroundColor = .white
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateLayout(for: size)
    }
    
    private func setupViews() {
        tableView = UITableView()
        scrollView = ListScrollView()
        activityIndicator = UIActivityIndicatorView(style: .large)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        view.addSubview(scrollView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        scrollView.itemSelected = { [weak self] item in
            self?.handleItemSelected(item)
        }
        
        updateLayout(for: view.bounds.size)
    }
    
    private func bindViewModel() {
        viewModel.listPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                let presentData = list
                self?.tableView.reloadData()
                self?.scrollView.items = presentData
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
    
    private func handleItemSelected(_ item: ListPresentData) {
        let webVC = WebViewController()
        webVC.url = item.url
        webVC.pageTitle = item.title
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    private func updateLayout(for size: CGSize) {
        let isLandscape = size.width > size.height
        tableView.isHidden = isLandscape
        scrollView.isHidden = !isLandscape
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        let item = viewModel.list[indexPath.row]
        cell.configure(title: item.title, imageUrl: item.urlToImage, publishedAt: item.publishedAt)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.list[indexPath.row]
        handleItemSelected(item)
    }
}
