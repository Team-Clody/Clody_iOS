//
//  OnBoardingViewController.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/12/24.
//

import UIKit

import RxCocoa
import RxSwift
import Then

final class OnBoardingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private lazy var pageControl = rootView.pageControl
    
    // MARK: - UI Components
     
    private let rootView = OnBoardingView()
    private lazy var pageViewController = rootView.pageViewController
    private var viewControllers: [UIViewController] = []
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setUI()
        setDelegate()
        setPageViewController()
    }
}

// MARK: - Extensions

private extension OnBoardingViewController {

    func bindViewModel() {
    }

    func setUI() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setDelegate() {
        pageViewController.delegate = self
        pageViewController.dataSource = self
    }
    
    func setPageViewController() {
        self.addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        addViewControllersData()
        guard let firstVC = viewControllers.first else { return }
        pageViewController.setViewControllers([firstVC], direction: .forward, animated: true)
    }
    
    func addViewControllersData() {
        for i in 0 ..< 4 {
            let viewController = UIViewController()
            viewController.view = OnBoardingDetailView(type: OnBoardingType.allCases[i])
            viewControllers.append(viewController)
        }
    }
    
    func setPage(from currentIndex: Int, to newIndex: Int) {
        guard 0 <= newIndex && newIndex < viewControllers.count else { return }
        let direction: UIPageViewController.NavigationDirection = currentIndex < newIndex ? .forward : .reverse
        pageViewController.setViewControllers([viewControllers[newIndex]], direction: direction, animated: true)
    }
}

extension OnBoardingViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
            let viewController = pageViewController.viewControllers?.first,
            let index = viewControllers.firstIndex(of: viewController) {
            pageControl.currentPage = index
        }
    }
}

extension OnBoardingViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        return previousIndex < 0 ? nil : viewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        return nextIndex == viewControllers.count ? nil : viewControllers[nextIndex]
    }
}
