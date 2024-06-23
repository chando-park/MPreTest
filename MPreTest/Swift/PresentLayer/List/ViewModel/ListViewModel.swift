import Foundation
import Combine
import CoreData

protocol ListViewModelType {
    var listPublisher: AnyPublisher<[ListPresentData], Never> { get }
    var isLoading: AnyPublisher<Bool, Never> { get }
    func getData()
}

class ListViewModel: ListViewModelType {
    @Published private(set) var list: [ListPresentData] = []
    @Published private(set) var loading: Bool = false
    private let fetcher: ListDataFecherType
    private var cancellables: Set<AnyCancellable> = []

    init(fetcher: ListDataFecherType) {
        self.fetcher = fetcher
    }

    var listPublisher: AnyPublisher<[ListPresentData], Never> {
        $list.eraseToAnyPublisher()
    }
    
    var isLoading: AnyPublisher<Bool, Never> {
        $loading.eraseToAnyPublisher()
    }

    func getData() {
        loading = true
        fetcher.getList()
            .flatMap { [weak self] (models) -> AnyPublisher<[ListModel], Never> in
                guard let self = self else { return Just([]).eraseToAnyPublisher() }
                let savePublishers = models.map { CoreDataManager.shared.saveNewsItem($0) }
                return Publishers.MergeMany(savePublishers)
                    .collect()
                    .map { _ in models }
                    .catch { _ in Just(models) }
                    .eraseToAnyPublisher()
            }
            .catch { _ in
                CoreDataManager.shared.fetchNewsItems()
                    .replaceError(with: [])
            }
            .map { model in
                model.map { $0.toPresentModel() }
            }

            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.loading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching data: \(error)")
                }
            }, receiveValue: { [weak self] models in
                self?.list = models
            })
            .store(in: &cancellables)
    }
}
