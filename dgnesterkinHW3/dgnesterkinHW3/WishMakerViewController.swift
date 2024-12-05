import UIKit

final class WishMakerViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let stackTopOffset: CGFloat = 60
        static let horizontalPadding: CGFloat = 20
        static let buttonHeight: CGFloat = 30
        static let buttonSpacing: CGFloat = 10
        static let titleFontSize: CGFloat = 32
    }

    // MARK: - Properties
    private var isSlidersHidden = false
    private let stack = UIStackView()
    private let hexTextField = UITextField()

    private let sliderRed = CustomSlider(title: "Red", min: 0, max: 255)
    private let sliderGreen = CustomSlider(title: "Green", min: 0, max: 255)
    private let sliderBlue = CustomSlider(title: "Blue", min: 0, max: 255)

    private let toggleButton = UIButton(type: .system)
    private let hexButton = UIButton(type: .system)
    private let randomColorButton = UIButton(type: .system)

    private let actionStack = UIStackView()
    private let addMoreWishesButton = UIButton(type: .system)
    private let scheduleWishesButton = UIButton(type: .system)

    var color: UIColor = .white {
        didSet {
            view.backgroundColor = color
            updateButtonColors(with: color)
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSliders()
        configureToggleButton()
        configureHexTextField()
        configureHexButton()
        configureRandomColorButton()
        configureActionStack()
        view.backgroundColor = .white
        updateButtonColors(with: color)
    }

    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = .systemPink
        let title = UILabel()
        title.text = "WishMaker"
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: Constants.titleFontSize)
        view.addSubview(title)
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            title.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }

    private func configureSliders() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        view.addSubview(stack)
        [sliderRed, sliderGreen, sliderBlue].forEach { stack.addArrangedSubview($0) }
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.stackTopOffset),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding)
        ])
        sliderRed.valueChanged = { [weak self] _ in self?.updateBackgroundColor() }
        sliderGreen.valueChanged = { [weak self] _ in self?.updateBackgroundColor() }
        sliderBlue.valueChanged = { [weak self] _ in self?.updateBackgroundColor() }
    }

    private func configureToggleButton() {
        configureButton(toggleButton, title: "Toggle Sliders", action: #selector(toggleSliders))
        NSLayoutConstraint.activate([
            toggleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            toggleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
            toggleButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: Constants.buttonSpacing),
            toggleButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }

    private func configureHexTextField() {
        hexTextField.placeholder = "Enter HEX"
        hexTextField.borderStyle = .roundedRect
        hexTextField.textAlignment = .center
        hexTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hexTextField)
        NSLayoutConstraint.activate([
            hexTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hexTextField.topAnchor.constraint(equalTo: toggleButton.bottomAnchor, constant: Constants.buttonSpacing),
            hexTextField.widthAnchor.constraint(equalToConstant: 150)
        ])
    }

    private func configureHexButton() {
        configureButton(hexButton, title: "Apply HEX Color", action: #selector(applyHexColor))
        NSLayoutConstraint.activate([
            hexButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            hexButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
            hexButton.topAnchor.constraint(equalTo: hexTextField.bottomAnchor, constant: Constants.buttonSpacing),
            hexButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }

    private func configureRandomColorButton() {
        configureButton(randomColorButton, title: "Random Color", action: #selector(generateRandomColor))
        NSLayoutConstraint.activate([
            randomColorButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            randomColorButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
            randomColorButton.topAnchor.constraint(equalTo: hexButton.bottomAnchor, constant: Constants.buttonSpacing),
            randomColorButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }

    private func configureActionStack() {
        actionStack.axis = .vertical
        actionStack.spacing = Constants.buttonSpacing
        actionStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(actionStack)

        configureButton(addMoreWishesButton, title: "Add More Wishes", action: #selector(openWishStoringView))
        configureButton(scheduleWishesButton, title: "Schedule Wish Granting", action: #selector(openWishCalendarView))

        [addMoreWishesButton, scheduleWishesButton].forEach { actionStack.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            actionStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            actionStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
            actionStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.buttonSpacing)
        ])
    }

    // MARK: - Actions
    @objc private func toggleSliders() {
        isSlidersHidden.toggle()
        stack.isHidden = isSlidersHidden
    }

    @objc private func applyHexColor() {
        guard let hexString = hexTextField.text, let color = UIColor(hexString: hexString) else { return }
        self.color = color
    }

    @objc private func generateRandomColor() {
        let randomRed = CGFloat.random(in: 0...1)
        let randomGreen = CGFloat.random(in: 0...1)
        let randomBlue = CGFloat.random(in: 0...1)
        self.color = UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }

    @objc private func openWishStoringView() {
        let wishStoringVC = WishStoringViewController()
        wishStoringVC.color = color
        present(wishStoringVC, animated: true, completion: nil)
    }

    @objc private func openWishCalendarView() {
        let calendarVC = WishCalendarViewController()
        calendarVC.color = color
        navigationController?.pushViewController(calendarVC, animated: true)
    }

    // MARK: - Helpers
    private func configureButton(_ button: UIButton, title: String, action: Selector) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(button.backgroundColor, for: .normal)
        button.layer.cornerRadius = Constants.buttonHeight / 2
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.addTarget(self, action: action, for: .touchUpInside)
    }

    private func updateBackgroundColor() {
        let redValue = CGFloat(sliderRed.slider.value) / 255
        let greenValue = CGFloat(sliderGreen.slider.value) / 255
        let blueValue = CGFloat(sliderBlue.slider.value) / 255
        self.color = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
    }

    private func updateButtonColors(with color: UIColor) {
        view.backgroundColor = color
        [toggleButton, hexButton, randomColorButton, addMoreWishesButton, scheduleWishesButton].forEach { button in
            button.setTitleColor(color, for: .normal)
        }
    }
}
