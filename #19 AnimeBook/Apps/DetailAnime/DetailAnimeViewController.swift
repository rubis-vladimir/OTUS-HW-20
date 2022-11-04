//
//  DetailAnimeViewController.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 21.10.2022.
//

import UIKit

/// Контроллер представления детальной информации Аниме
final class DetailAnimeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    private let presenter: DetailAnimePresenter
    private var animeImageView = UIImageView()
    
    private let pinchGestureRecognizer = UIPinchGestureRecognizer()
    private var pinchGestureAnchorScale: CGFloat?
    
    private var scale: CGFloat = 1.0 { didSet { updateViewTransform() } }
    private var rotation: CGFloat = 0.0 { didSet { updateViewTransform() } }
    
    // MARK: - Init & ViewDidLoad
    init(presenter: DetailAnimePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private func
    /// Настройка UI
    private func setupUI() {
        setupGestureRecognizers()
        view.backgroundColor = Constants.bgColor
        
        navigationItem.leftBarButtonItem = createCustomBarButton(
            imageName: "chevron.backward",
            title: " AnimeBook".localize(),
            selector: #selector(cancelLeftButtonTapped)
        )
        
        animeImageView = UIImageView(frame: view.frame)
        animeImageView.contentMode = .scaleAspectFit
        animeImageView.addGestureRecognizer(pinchGestureRecognizer)
        animeImageView.isUserInteractionEnabled = true
        
        if let imageData = presenter.model.imageData,
            let image = UIImage(data: imageData) {
            animeImageView.image = image
        }
        view.addSubview(animeImageView)
    }
    
    /// Обновления размеров View
    private func updateViewTransform() {
        animeImageView.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .rotated(by: rotation)
    }
    
    @objc private func cancelLeftButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - GestureRecognizers
fileprivate extension DetailAnimeViewController {
    /// Настройка GestureRecognizers
    private func setupGestureRecognizers() {
        pinchGestureRecognizer.addTarget(self, action: #selector(handlePinchGesture(_:)))
        pinchGestureRecognizer.delegate = self
    }
    
    /// Зуминг изображения при щипковом жесте пользователя
    @objc private func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard pinchGestureRecognizer === gestureRecognizer else { return }

        switch gestureRecognizer.state {
        case .began:
            assert(pinchGestureAnchorScale == nil)
            pinchGestureAnchorScale = gestureRecognizer.scale
        case .changed:
            guard let pinchGestureAnchorScale = pinchGestureAnchorScale else { return }
            let gestureScale = gestureRecognizer.scale
            scale += gestureScale - pinchGestureAnchorScale
            self.pinchGestureAnchorScale = gestureScale

        case .cancelled, .ended:
            pinchGestureAnchorScale = nil

        case .failed, .possible:
            assert(pinchGestureAnchorScale == nil)
            break
        @unknown default:
            fatalError()
        }
    }
}
