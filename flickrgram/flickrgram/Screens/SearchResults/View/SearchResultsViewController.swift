import UIKit

/// Displays the search results screen
final class SearchResultsViewController: UIViewController {
    private typealias Cell = SearchResultsCell
    
    private let searchBar = UISearchBar()
    private let refreshControl = UIRefreshControl()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let placeholderView = SearchResultsPlaceholderView()

    private var fullRowsCount: Int { viewModel.searchResults.count / viewModel.columnsCount }
    private var cellSize: CGFloat { view.bounds.width / CGFloat(viewModel.columnsCount) }
    private let refreshGapInRows: Int = 2
    
    private let appearance = Appearance()
    private let viewModel: SearchResultsViewModel
    
    /// Designated initializer
    /// - Parameter viewModel: ViewModel
    init(viewModel: SearchResultsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupObservers()
        setupSubviews()
        setupConstraints()
        
        viewModel.onViewLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if !placeholderView.isHidden {
            placeholderView.frame = .init(
                x: 0.0,
                y: 0.0,
                width: collectionView.frame.width,
                height: view.safeAreaLayoutGuide.layoutFrame.maxY - searchBar.frame.maxY
            )

            placeholderView.bounds = placeholderView.frame
        }
    }
    
    private func setupObservers() {
        viewModel.onPullToRefreshDeactivation = { [weak self] in
            if let self = self, self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
        
        viewModel.$isActivityIndicatorAnimating.onValueChange = { [weak self] isAnimating in
            if isAnimating {
                self?.activityIndicator.startAnimating()
                self?.view.isUserInteractionEnabled = false
            } else {
                self?.activityIndicator.stopAnimating()
                self?.view.isUserInteractionEnabled = true
            }
        }
        
        viewModel.onReload = { [weak self]  in
            self?.collectionView.reloadData()
        }
        
        viewModel.onSectionsInsertion = { [weak self] sectionsIndices in
            self?.collectionView.insertSections(sectionsIndices)
        }
        
        viewModel.onCellReload = { [weak self] indexPath in
            self?.collectionView.reloadItems(at: [indexPath])
        }
        
        viewModel.$query.onValueChange = { [weak self] query in
            self?.searchBar.text = query
        }
        
        viewModel.$isPlaceholderHidden.onValueChange = { [weak self] isHidden in
            self?.placeholderView.isHidden = isHidden
        }
    }
    
    private func setupSubviews() {
        navigationController?.isNavigationBarHidden = appearance.isNavigationBarHidden
        view.backgroundColor = appearance.backgroundColor
                
        view.addSubview(searchBar)
        searchBar.placeholder = viewModel.searchBarPlaceholder
        searchBar.searchBarStyle = appearance.searchBarStyle
        searchBar.searchTextField.clearButtonMode = appearance.searchBarTextFieldClearButtonMode
        searchBar.delegate = self
        
        view.addSubview(collectionView)
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = appearance.collectionViewShowsVerticalScrollIndicator
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)
        
        collectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(onRefreshControlDrag), for: .valueChanged)
        
        collectionView.addSubview(placeholderView)
        placeholderView.setImage(appearance.placeholderViewImage)
        placeholderView.setTitle(viewModel.placeholderTitle)
        placeholderView.isHidden = viewModel.isPlaceholderHidden
        
        view.addSubview(activityIndicator)
        activityIndicator.backgroundColor = appearance.activityIndicatorBackgroundColor
        activityIndicator.layer.cornerRadius = appearance.activityIndicatorBackgroundCornerRadius
    }
    
    private func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
                
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc private func onRefreshControlDrag() {
        viewModel.onPullToRefresh()
    }
}

// MARK: - UISearchBarDelegate

extension SearchResultsViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        viewModel.onSearchBarPress()
        return false
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchResultsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return .init(width: cellSize, height: cellSize)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.onCellSelection(atIndexPath: indexPath)
    }
}

// MARK: - UICollectionViewDataSource

extension SearchResultsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell
        else {
            return .init()
        }
        
        let model = viewModel.searchResults[indexPath.section * viewModel.columnsCount + indexPath.row]
        model.bind(to: cell)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if viewModel.searchResults.count % viewModel.columnsCount == 0 {
            return fullRowsCount
        } else {
            return fullRowsCount + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section < fullRowsCount {
            return viewModel.columnsCount
        } else {
            return viewModel.searchResults.count % viewModel.columnsCount
        }
    }
}

// MARK: - UIScrollViewDelegate {

extension SearchResultsViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        let refreshGap = CGFloat(refreshGapInRows) * cellSize
        
        if maximumOffset - currentOffset <= refreshGap, 0 < currentOffset, 0 < maximumOffset {
            viewModel.onBottomDragging()
        }
    }
}

// MARK: - Appearance

private extension SearchResultsViewController {
    struct Appearance {
        let isNavigationBarHidden: Bool = true
        let backgroundColor: UIColor = .systemBackground
        let searchBarStyle: UISearchBar.Style = .minimal
        let searchBarTextFieldClearButtonMode: UITextField.ViewMode = .never
        let collectionViewShowsVerticalScrollIndicator: Bool = false
        let placeholderViewImage: UIImage = .init(named: "no_results_placeholder") ?? .init()
        let activityIndicatorBackgroundColor: UIColor = .white
        let activityIndicatorBackgroundCornerRadius: CGFloat = 2.0
    }
}
