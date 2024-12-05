import UIKit

final class WishEventCreationView: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: - Constants
    private enum Constants {
        static let pickerHeight: CGFloat = 150
        static let textFieldHeight: CGFloat = 40
        static let buttonWidth: CGFloat = 200
        static let buttonHeight: CGFloat = 50
        static let padding: CGFloat = 20
        static let smallPadding: CGFloat = 10
    }

    // MARK: - Properties
    private let titleTextField = UITextField()
    private let descriptionTextField = UITextField()
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    private let addButton = UIButton(type: .system)
    private let wishPicker = UIPickerView()

    var wishArray: [String] = []
    var onEventCreated: ((WishEventModel) -> Void)?

    var color: UIColor = .white {
        didSet {
            view.backgroundColor = color
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPicker()
    }

    // MARK: - UI Setup
    private func setupUI() {
        titleTextField.placeholder = "Enter Title"
        descriptionTextField.placeholder = "Enter Description"
        titleTextField.borderStyle = .roundedRect
        descriptionTextField.borderStyle = .roundedRect
        
        startDatePicker.datePickerMode = .date
        endDatePicker.datePickerMode = .date
        startDatePicker.addTarget(self, action: #selector(startDateChanged), for: .valueChanged)
        
        addButton.setTitle("Add Event", for: .normal)
        addButton.backgroundColor = .systemBlue
        addButton.setTitleColor(.white, for: .normal)
        addButton.layer.cornerRadius = Constants.buttonHeight / 2
        addButton.addTarget(self, action: #selector(addEventTapped), for: .touchUpInside)

        wishPicker.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        startDatePicker.translatesAutoresizingMaskIntoConstraints = false
        endDatePicker.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(wishPicker)
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextField)
        view.addSubview(startDatePicker)
        view.addSubview(endDatePicker)
        view.addSubview(addButton)

        NSLayoutConstraint.activate([
            wishPicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.padding),
            wishPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            wishPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            wishPicker.heightAnchor.constraint(equalToConstant: Constants.pickerHeight),
            
            titleTextField.topAnchor.constraint(equalTo: wishPicker.bottomAnchor, constant: Constants.smallPadding),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            titleTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),
            
            descriptionTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: Constants.smallPadding),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            descriptionTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),
            
            startDatePicker.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: Constants.smallPadding),
            startDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            startDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),

            endDatePicker.topAnchor.constraint(equalTo: startDatePicker.bottomAnchor, constant: Constants.smallPadding),
            endDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            endDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),

            addButton.topAnchor.constraint(equalTo: endDatePicker.bottomAnchor, constant: Constants.padding),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            addButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }

    private func setupPicker() {
        wishPicker.dataSource = self
        wishPicker.delegate = self
    }

    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return wishArray.count
    }

    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return wishArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        titleTextField.text = wishArray[row]
    }

    // MARK: - Actions
    @objc private func startDateChanged() {
        endDatePicker.minimumDate = startDatePicker.date
    }

    @objc private func addEventTapped() {
        guard let title = titleTextField.text, !title.isEmpty,
              let description = descriptionTextField.text, !description.isEmpty else {
            showAlert(message: "Пожалуйста, заполните все поля.")
            return
        }
        
        let startDate = startDatePicker.date
        let endDate = endDatePicker.date

        guard endDate >= startDate else {
            showAlert(message: "Дата окончания не может быть раньше даты начала.")
            return
        }
        
        let newEvent = WishEventModel(
            title: title,
            description: description,
            startDate: startDate,
            endDate: endDate
        )
        
        onEventCreated?(newEvent)
        dismiss(animated: true, completion: nil)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
