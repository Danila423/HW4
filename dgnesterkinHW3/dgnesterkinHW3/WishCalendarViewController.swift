import UIKit

final class WishCalendarViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let collectionViewCellSize = CGSize(width: 150, height: 150)
        static let labelFontSize: CGFloat = 24
        static let buttonHeight: CGFloat = 50
        static let padding: CGFloat = 20
    }

    // MARK: - Properties
    private var events: [WishEventModel] = []
    private let calendarManager = CalendarManager()
    var color: UIColor = .white {
        didSet {
            view.backgroundColor = color
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "События"
        label.font = UIFont.boldSystemFont(ofSize: Constants.labelFontSize)
        label.textAlignment = .center
        label.textColor = UIColor.label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = Constants.collectionViewCellSize
        layout.minimumInteritemSpacing = Constants.padding
        layout.minimumLineSpacing = Constants.padding
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadEventsFromStorage()
        requestCalendarAccess()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = color

        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(WishEventCell.self, forCellWithReuseIdentifier: WishEventCell.reuseIdentifier)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.padding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),

            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.padding),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        setupAddEventButton()
    }

    private func setupAddEventButton() {
        let addEventButton = UIButton(type: .system)
        addEventButton.setTitle("Add Event", for: .normal)
        addEventButton.backgroundColor = .systemBlue
        addEventButton.setTitleColor(.white, for: .normal)
        addEventButton.layer.cornerRadius = Constants.buttonHeight / 2
        addEventButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addEventButton)

        NSLayoutConstraint.activate([
            addEventButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            addEventButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.padding),
            addEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            addEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding)
        ])

        addEventButton.addTarget(self, action: #selector(openAddEventView), for: .touchUpInside)
    }

    // MARK: - Actions
    @objc private func openAddEventView() {
        let addEventVC = WishEventCreationView()
        addEventVC.color = color
        addEventVC.wishArray = getWishes()
        addEventVC.onEventCreated = { [weak self] newEvent in
            self?.events.append(newEvent)
            self?.collectionView.reloadData()
            self?.saveEventsToStorage()
            self?.saveEventToSystemCalendar(newEvent)
        }
        present(addEventVC, animated: true)
    }

    // MARK: - Data Persistence
    private func getWishes() -> [String] {
        if let savedWishes = UserDefaults.standard.array(forKey: "wishArray") as? [String] {
            return savedWishes
        }
        return []
    }

    private func saveEventsToStorage() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let encoded = try? encoder.encode(events) {
            UserDefaults.standard.set(encoded, forKey: "savedEvents")
        }
    }

    private func loadEventsFromStorage() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if let savedData = UserDefaults.standard.data(forKey: "savedEvents"),
           let decodedEvents = try? decoder.decode([WishEventModel].self, from: savedData) {
            events = decodedEvents
        }
    }

    // MARK: - Calendar Access
    private func requestCalendarAccess() {
        calendarManager.checkCalendarAuthorizationStatus { [weak self] status in
            switch status {
            case .notDetermined:
                self?.calendarManager.requestAccess { granted in
                    DispatchQueue.main.async {
                        if granted {
                            print("Доступ к календарю предоставлен.")
                        } else {
                            self?.showAccessDeniedAlert()
                        }
                    }
                }
            case .authorized:
                print("Доступ к календарю уже предоставлен.")
            case .restricted, .denied:
                self?.showAccessDeniedAlert()
            case .fullAccess:
                print("Доступ к календарю предоставлен с полным доступом.")
            case .writeOnly:
                print("Доступ к календарю предоставлен только на запись.")
            @unknown default:
                fatalError("Unhandled EKAuthorizationStatus case")
            }
        }
    }



    private func saveEventToSystemCalendar(_ event: WishEventModel) {
        calendarManager.saveEvent(title: event.title, description: event.description, startDate: event.startDate, endDate: event.endDate) { success in
            DispatchQueue.main.async {
                if success {
                    print("Событие успешно сохранено в календарь.")
                } else {
                    self.showAlert(title: "Ошибка", message: "Не удалось сохранить событие в календарь.")
                }
            }
        }
    }

    private func showAccessDeniedAlert() {
        showAlert(title: "Доступ запрещен", message: "Пожалуйста, разрешите доступ к календарю в настройках устройства.")
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension WishCalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishEventCell.reuseIdentifier, for: indexPath) as? WishEventCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: events[indexPath.row])
        return cell
    }
}
