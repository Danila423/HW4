import UIKit

final class WrittenWishCell: UITableViewCell {
    // MARK: - Constants
    private enum Constants {
        static let padding: CGFloat = 10
    }

    // MARK: - Properties
    static let reuseId = "WrittenWishCell"

    let wishLabel = UILabel()

    var color: UIColor = .white {
        didSet {
            contentView.backgroundColor = color
        }
    }

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func configureUI() {
        selectionStyle = .none
        contentView.backgroundColor = color
        wishLabel.translatesAutoresizingMaskIntoConstraints = false
        wishLabel.numberOfLines = 0
        contentView.addSubview(wishLabel)

        NSLayoutConstraint.activate([
            wishLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding),
            wishLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            wishLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            wishLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.padding)
        ])
    }

    // MARK: - Configuration
    func configure(with wish: String) {
        wishLabel.text = wish
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        wishLabel.text = nil
    }
}
