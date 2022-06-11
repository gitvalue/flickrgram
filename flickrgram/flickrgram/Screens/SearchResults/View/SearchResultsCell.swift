import ImageLoading
import UIKit

/// Displays photo cell on search results screen
final class SearchResultsCell: UICollectionViewCell, SearchResultPresentable {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    private let appearance = Appearance()
    
    private var onPrepareForReuse: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = bounds
        titleLabel.frame = bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        titleLabel.text = nil        
    }
        
    private func setupSubviews() {
        backgroundColor = appearance.backgroundColor
        
        addSubview(titleLabel)
        titleLabel.numberOfLines = appearance.titleLabelNumberOfLines
        titleLabel.textAlignment = appearance.titleLabelTextAlignment
        
        addSubview(imageView)
    }
}

// MARK: - Appearance

private extension SearchResultsCell {
    struct Appearance {
        let backgroundColor: UIColor = .systemGray
        let titleLabelNumberOfLines: Int = 0
        let titleLabelTextAlignment: NSTextAlignment = .center
    }
}
