import UIKit

/// Flickr search query screen
final class SearchViewController: UIViewController {
    private typealias Cell = SearchHistoryCell
    
    private let backButton = UIButton()
    private let searchBar = UISearchBar()
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private var searchBarLeadingConstraint: NSLayoutConstraint?
    private var appeared: Bool = false
    
    private let viewModel: SearchViewModel
    
    private let appearance = Appearance()
    
    /// Designated initializer
    /// - Parameter viewModel: Screen's viewmodel
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupNotifications()
        setupSubviews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.layoutIfNeeded()
        
        if !appeared {
            appeared = true
            
            searchBarLeadingConstraint?.constant = backButton.frame.maxX
            
            UIView.animate(withDuration: appearance.animationDuration) { [weak self] in
                self?.view.layoutIfNeeded()
            } completion: { [weak self] isFinished in
                if isFinished {
                    self?.searchBar.becomeFirstResponder()
                }
            }
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onKeyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    private func setupSubviews() {
        navigationController?.isNavigationBarHidden = appearance.isNavigationBarHidden

        view.backgroundColor = appearance.backgroundColor
        
        view.addSubview(backButton)
        backButton.setImage(appearance.backButtonIcon, for: .normal)
        backButton.addTarget(self, action: #selector(onBackButtonPress), for: .touchUpInside)
        
        view.addSubview(searchBar)
        searchBar.placeholder = viewModel.searchBarPlaceholder
        searchBar.searchBarStyle = appearance.searchBarStyle
        searchBar.delegate = self
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
    }
    
    private func setupConstraints() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: appearance.backButtonLeading).isActive = true
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBarLeadingConstraint = searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        searchBarLeadingConstraint?.isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc private func onBackButtonPress() {
        self.searchBarLeadingConstraint?.constant = 0.0
        
        UIView.animate(withDuration: appearance.animationDuration) {
            self.backButton.isHidden = true
            self.view.layoutIfNeeded()
        } completion: { isFinished in
            if isFinished {
                self.viewModel.onBackButtonPress()
            }
        }
    }
    
    @objc private func onKeyboardWillShow(_ notification: Notification) {
        guard
            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        let contentInset = tableView.contentInset
        tableView.contentInset = .init(
            top: contentInset.top,
            left: contentInset.left,
            bottom: contentInset.bottom + keyboardHeight,
            right: contentInset.right
        )
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.onSearchButtonPress(searchBar.text)
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.onCellPress(indexPath.row)
    }
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell
        else {
            return .init()
        }
        
        cell.setText(viewModel.queries[indexPath.row])
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.queries.count
    }
}

// MARK: - Appearance

private extension SearchViewController {
    struct Appearance {
        let isNavigationBarHidden: Bool = true
        let backgroundColor: UIColor = .systemBackground
        let backButtonLeading: CGFloat = 5.0
        let backButtonIcon: UIImage? = .init(named: "back_button")
        let animationDuration: CGFloat = 0.25
        let searchBarStyle: UISearchBar.Style = .minimal
    }
}
