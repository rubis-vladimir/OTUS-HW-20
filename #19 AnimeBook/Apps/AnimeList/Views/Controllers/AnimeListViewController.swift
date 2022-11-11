//
//  AnimeListViewController.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 21.10.2022.
//

import UIKit

/// Протокол управления view-слоем модуля AnimeList
protocol AnimeListPresenterDelegate: AnyObject {
    /// Обновление UI
    func updateUI()
    /// Обработка и показ ошибки
    func showError(_ rError: RecoverableError)
}

/// Контроллер представления коллекции Аниме
final class AnimeListViewController: UIViewController {
    
    // MARK: - Properties
    private let presenter: AnimeListPresentation
    private let searchBar = UISearchBar()
    private var animeListCollectionView: UICollectionView?
    private var timer: Timer?
    
    private struct AnimeListConstants {
        static let padding: CGFloat = 20
        static let aspectRatio: CGFloat = 1.6
        static let itemPerRow: CGFloat = 2
    }
    
    // MARK: - Init & ViewDidLoad
    init(presenter: AnimeListPresentation) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter.getAnime(with: .random)
    }
    
    // MARK: - Private func
    /// Настройка UI
    private func setupUI() {
        title = "AnimeBook".localize()
        
        setupSearchBar()
        setupNavBar()
        setupCollectionView()
    }
    
    func currentAppleLanguage() -> String {
        let appleLanguageKey = "AppleLanguages"
        let userdef = UserDefaults.standard
        var currentWithoutLocale = "Base"
        if let langArray = userdef.object(forKey: appleLanguageKey) as? [String] {
            if var current = langArray.first {
                if let range = current.range(of: "-") {
                    current = String(current[..<range.lowerBound])
                }
                currentWithoutLocale = current
            }
        }
        return currentWithoutLocale
    }
    
    /// Настройка collectionView
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: AnimeListConstants.padding,
                                           left: AnimeListConstants.padding,
                                           bottom: AnimeListConstants.padding,
                                           right: AnimeListConstants.padding)
        layout.minimumInteritemSpacing = AnimeListConstants.padding
        layout.itemSize = calculateItemSize()
        
        animeListCollectionView = UICollectionView(frame: view.frame,
                                                   collectionViewLayout: layout)
        animeListCollectionView?.register(AnimeCell.self,
                                          forCellWithReuseIdentifier: String(describing: AnimeCell.self))
        animeListCollectionView?.backgroundColor = Constants.bgColor
        animeListCollectionView?.delegate = self
        animeListCollectionView?.dataSource = self
        view.addSubview(animeListCollectionView ?? UICollectionView())
    }
    
    /// Рассчитывает размер Item
    private func calculateItemSize() -> CGSize {
        let itemPerRow: CGFloat = AnimeListConstants.itemPerRow
        let paddingWidht = AnimeListConstants.padding * (itemPerRow + 1)
        let availableWidth = (view.bounds.width - paddingWidht) / 2
        return CGSize(width: availableWidth,
                      height: availableWidth * AnimeListConstants.aspectRatio)
    }
    
    /// Настройка navigationBar
    private func setupNavBar() {
        if let font = Constants.titleFont {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.backgroundColor = Constants.bgColor
            navigationBarAppearance.titleTextAttributes = [.font : font,
                                                           .foregroundColor: Constants.textColor]
            navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        }
        
        navigationItem.rightBarButtonItem = createCustomBarButton(imageName: "gearshape",
                                                                  title: nil,
                                                                  selector: #selector(rightBarButtonPressed))
        search(shouldShow: false)
    }
    
    /// Настройка searchBar
    private func setupSearchBar() {
        searchBar.tintColor = Constants.textColor
        searchBar.searchTextField.defaultTextAttributes = [.foregroundColor: Constants.textColor]
        searchBar.delegate = self
    }
    
    /// Устанавливает/скрывает кнопку поиска
    private func showSearchBarButton(shouldShow: Bool) {
        if shouldShow {
            navigationItem.leftBarButtonItem = createCustomBarButton(imageName: "magnifyingglass",
                                                                     title: nil,
                                                                     selector: #selector(leftBarButtonPressed))
        } else {
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    /// Устанавливает/скрывает searchBar
    private func search(shouldShow: Bool) {
        showSearchBarButton(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        navigationItem.titleView = shouldShow ? searchBar : nil
    }
    
    @objc private func leftBarButtonPressed() {
        search(shouldShow: true)
        searchBar.becomeFirstResponder()
    }
    
    @objc private func rightBarButtonPressed() {
        showSetupRequestAlert { parameters in
            self.presenter.getAnime(with: .search(with: parameters))
        }
    }
}

// MARK: - UICollectionViewDataSource
extension AnimeListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        presenter.animeModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(AnimeCell.self,
                                                      indexPath: indexPath)
        let model = presenter.animeModels[indexPath.item]
        cell.configure(with: model)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension AnimeListViewController: UICollectionViewDelegate {
    /// Обрабатывает нажатие на ячейку
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = presenter.animeModels[indexPath.item]
        presenter.tapAnime(model)
    }
}

// MARK: - AnimeListPresenterDelegate
extension AnimeListViewController: AnimeListPresenterDelegate {
    func updateUI() {
        DispatchQueue.main.async {
            self.animeListCollectionView?.reloadData()
        }
    }
    
    func showError(_ rError: RecoverableError) {
        DispatchQueue.main.async {
            self.showAlertError(rError)
        }
    }
}

// MARK: - UISearchBarDelegate
extension AnimeListViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow: false)
    }
    
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5,
                                     repeats: false) { [weak self] _ in
            var parameters = AnimeParameters()
            parameters.letter = "\(searchText)"
            self?.presenter.getAnime(with: .search(with: parameters))
        }
    }
}

