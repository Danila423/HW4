import UIKit

final class CustomSlider: UIView {
    // MARK: - Constants
    private enum Constants {
        static let valueLabelWidth: CGFloat = 40
        static let titleFontSize: CGFloat = 16
    }

    // MARK: - Properties
    var slider: UISlider = UISlider()
    var valueChanged: ((Float) -> Void)?
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()

    // MARK: - Initialization
    init(title: String, min: Float, max: Float, initialValue: Float = 0.0) {
        super.init(frame: .zero)
        titleLabel.text = title
        slider.minimumValue = min
        slider.maximumValue = max
        slider.value = initialValue
        valueLabel.text = String(format: "%.0f", initialValue)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func configureUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.textAlignment = .right
        valueLabel.font = UIFont.systemFont(ofSize: 14)
        valueLabel.textColor = .gray

        addSubview(titleLabel)
        addSubview(slider)
        addSubview(valueLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            slider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: -8),

            valueLabel.centerYAnchor.constraint(equalTo: slider.centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.widthAnchor.constraint(equalToConstant: Constants.valueLabelWidth),

            slider.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        slider.minimumTrackTintColor = .systemBlue
        slider.maximumTrackTintColor = .systemGray
        slider.thumbTintColor = .systemBlue

        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textColor = UIColor.label

        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }

    // MARK: - Actions
    @objc private func sliderValueChanged() {
        let currentValue = slider.value
        valueLabel.text = String(format: "%.0f", currentValue)
        valueChanged?(currentValue)
    }
}
