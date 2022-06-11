import UIKit

/// Search results placeholder
final class SearchResultsPlaceholderView: UIView {
    private let stackView = UIStackView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    private let appearance = Appearance()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Assigns a displaying image
    /// - Parameter image: Image model
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    /// Assigns a title label text
    /// - Parameter title: Text
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    private func setupSubviews() {
        addSubview(stackView)
        stackView.axis = appearance.stackViewAxis
        stackView.alignment = appearance.stackViewAlignment
        stackView.spacing = appearance.stackViewSpacing
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        
        titleLabel.numberOfLines = appearance.titleLabelNumberOfLines
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor).isActive = true
    }
}

// MARK: - Appearance

private extension SearchResultsPlaceholderView {
    struct Appearance {
        let stackViewAxis: NSLayoutConstraint.Axis = .vertical
        let stackViewAlignment: UIStackView.Alignment = .center
        let stackViewSpacing: CGFloat = 5.0
        let titleLabelNumberOfLines: Int = 0
    }
}
