//
//  PageStoriesViewController.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/13/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

private struct Constants {
    public static let storyViewControllerIdentifier = "StoryViewController"
}

class PageStoriesViewController: UIViewController {

    var storiesArray: [StoryModel]?
    var pageViewController: UIPageViewController!
    var beginPageIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal,
            options: nil)
        pageViewController.dataSource = self
        pageViewController.view.frame = view.bounds
        let initViewController = viewControllerAtIndex(index: beginPageIndex)
        let viewControllers: [StoryViewController] = [initViewController]
        pageViewController.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
        view.addSubview(pageViewController.view)
        addChildViewController(pageViewController)
        pageViewController.didMove(toParentViewController: self)
    }

    func viewControllerAtIndex(index: Int) -> StoryViewController {
        guard let storyViewController = storyboard?.instantiateViewController(
            withIdentifier: Constants.storyViewControllerIdentifier) as? StoryViewController,
            let storiesArray = storiesArray, index >= 0, index < storiesArray.count else {
                return StoryViewController()
        }
        storyViewController.storyModel = storiesArray[index]
        storyViewController.index = index
        storyViewController.delegate = self
        return storyViewController
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

}

extension PageStoriesViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let storyViewController = viewController as? StoryViewController else {
            return nil
        }
        let index = storyViewController.index + 1
        guard let storiesArray = storiesArray else {
            return nil
        }
        if index == storiesArray.count {
            dismiss(animated: true, completion: nil)
        }
        return viewControllerAtIndex(index: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let storyViewController = viewController as? StoryViewController else {
            return nil
        }
        let index = storyViewController.index - 1
        if index < 0 {
            return nil
        }
        return viewControllerAtIndex(index: index)
    }

}

extension PageStoriesViewController: StoryViewControllerDelegate {

    func exitAction() {
        dismiss(animated: true, completion: nil)
    }

    func goToNextPage() {
        pageViewController.goToNextPage()
    }

}

extension UIPageViewController {

    func goToNextPage() {
        guard let currentViewController = viewControllers?.first,
            let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController)
            else {
            return
        }
        setViewControllers([nextViewController], direction: .forward, animated: false, completion: nil)
    }

}
