import UIKit

/// Search screen's queries history cell
final class SearchHistoryCell: UITableViewCell {
    private let appearance = Appearance()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Assigns a cell's title text
    /// - Parameter text: Title text
    func setText(_ text: String) {
        textLabel?.text = text
    }
    
    private func setupSubviews() {
        imageView?.image = appearance.icon
    }
}

// MARK: - Appearance

private extension SearchHistoryCell {
    struct Appearance {
        let icon: UIImage? = .init(named: "history")
    }
}
