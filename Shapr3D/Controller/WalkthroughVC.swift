//
//  WalkthroughVC.swift
//  Shapr3D
//
//  Created by Muhammad Imran on 25/07/2021.
//

import UIKit

class WalkthroughVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var getStartedButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeObservers()
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scrollView.setContentOffset(
            CGPoint(x: scrollView.bounds.size.width * CGFloat(pageControl.currentPage), y: 0.0), animated: false)
    }
    
    
    
    // MARK: - IBAction
    
    @IBAction func didTapPageControl(_ sender: UIPageControl) {
        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.size.width * CGFloat(sender.currentPage), y: 0.0), animated: true)
    }
    @IBAction func didTapGetStarted(_ sender: UIPageControl) {
        self.pushToController(from: .main, identifier: .tabbar)
    }
    
    
    // MARK: - Helper Functions
    
    func setupView() {
        addObservers()
        getStartedButton.roundView()
        if let hoverColor = UIColor(named: "hover"){
            getStartedButton.setBackgroundColor(color: hoverColor, forState: .highlighted)
        }
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = UIColor(named: "primaryColor")
    }
    // MARK: - KVO
    
    private var keyValueObservations = [NSKeyValueObservation]()
    
    private func addObservers() {
        let kvo = scrollView.observe(\.contentOffset, options: [.new]) { _, change  in
            guard let newValue = change.newValue?.x else {
                return
            }
            
            let width = self.view.frame.width
            if newValue.truncatingRemainder(dividingBy: width) == 0 {
                self.pageControl.currentPage = Int(newValue / width)
            }
        }
        keyValueObservations.append(kvo)
    }
    
    private func removeObservers() {
        for kvo in keyValueObservations {
            kvo.invalidate()
        }
        keyValueObservations.removeAll()
    }
    
}

