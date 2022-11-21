//
//  ViewController.swift
//  Demo
//
//  Created by Дмитрий Поляков on 20.11.2022.
//

import UIKit
import AVKit
import DPMedia

class ViewController: UIViewController {
    
    // MARK: - Props
    private lazy var imageView = UIImageView()
    
    private lazy var mediaAdapter: DPMediaAdapterInterface = {
        DPMediaAdapter(
            viewController: self,
            didFinish: { [weak self] result in
                switch result {
                case let .failure(error):
                    let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
                    alert.addAction(.init(title: "OK", style: .cancel))
                    self?.present(alert, animated: true)
                case let .success(medias):
                    switch medias.first {
                    case .none:
                        break
                    case let .image(image):
                        self?.imageView.image = image.image
                    case let .video(video):
                        self?.imageView.image = video.preview
                        
                        let player = AVPlayer(url: video.url)
                        let vc = AVPlayerViewController()
                        vc.player = player
                        self?.present(vc, animated: true)
                        
                    }
                }
            }
        )
    }()

    // MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.imageView.removeFromSuperview()
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.imageView)
        
        NSLayoutConstraint.activate([
            self.imageView.widthAnchor.constraint(equalToConstant: 200),
            self.imageView.heightAnchor.constraint(equalToConstant: 200),
            self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        self.navigationItem.rightBarButtonItem = .init(title: "Show picker", style: .plain, target: self, action: #selector(self.tapPicker))
    }


    @objc
    private func tapPicker() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(.init(title: "Photo", style: .default, handler: { [weak self] _ in
            self?.mediaAdapter.picker = DPMediaPicker(mediaTypes: [.image])
            self?.mediaAdapter.start()
        }))
        alert.addAction(.init(title: "Video", style: .default, handler: { [weak self] _ in
            self?.mediaAdapter.picker = DPMediaPicker(mediaTypes: [.video])
            self?.mediaAdapter.start()
        }))
        alert.addAction(.init(title: "Photo or video", style: .default, handler: { [weak self] _ in
            self?.mediaAdapter.picker = DPMediaPicker()
            self?.mediaAdapter.start()
        }))
        alert.addAction(.init(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
}

