import UIKit

final class AddWishCell: UITableViewCell {
    // MARK: - Constants
    private enum Constants {
        static let textViewHeight: CGFloat = 80
        static let buttonTopPadding: CGFloat = 10
    }

    // MARK: - Properties
    static let reuseId = "AddWishCell"

    private let textView = UITextView()
    private let addButton = UIButton(type: .system)
    var addWish: ((String) -> Void)?

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
        contentView.backgroundColor = color
        selectionStyle = .none

        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.translatesAutoresizingMaskIntoConstraints = false

        addButton.setTitle("Add Wish", for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addWishTapped), for: .touchUpInside)

        contentView.addSubview(textView)
        contentView.addSubview(addButton)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.buttonTopPadding),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.buttonTopPadding),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.buttonTopPadding),
            textView.heightAnchor.constraint(equalToConstant: Constants.textViewHeight),

            addButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: Constants.buttonTopPadding),
            addButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.buttonTopPadding)
        ])
    }

    // MARK: - Actions
    @objc private func addWishTapped() {
        guard let wish = textView.text, !wish.isEmpty else { return }
        addWish?(wish)
        textView.text = ""
    }
}
