//
//  OnboardingViewController.swift
//  AnimalCare
//
//  Created by Sofa on 8.02.24.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides: [OnboardingSlide] = []
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextBtn.setTitle("Get started", for: .normal)
            } else {
                nextBtn.setTitle("Next", for: .normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        slides = [OnboardingSlide(title: "", description: "Надежный сервис для вас и ваших питомцев", image:#imageLiteral(resourceName: "launchScreen.jpeg")),
                  OnboardingSlide(title: "AnimalCare", description: "С любовью к вашим питомцам", image:#imageLiteral(resourceName: "pets.jpg")),
                  OnboardingSlide(title: "AnimalCare", description: "Только положительные эмоции", image:#imageLiteral(resourceName: "dogwalk.jpeg"))]
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        if currentPage == slides.count - 1 {
            let controller = storyboard?.instantiateViewController(withIdentifier: "HomeNC") as! UINavigationController
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    

}
