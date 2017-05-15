//
//  StatsPageViewController.swift
//  Pokulator
//
//  Created by Edward Huang on 5/14/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import UIKit

class StatsPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    lazy var pageArr: [UIViewController] = {
        return [self.VCInstance(name: "1"),
                self.VCInstance(name: "2")]
    }()
    
    
    private func VCInstance(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pageArr.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pageArr.count else {
            return pageArr.first
        }
        
        guard pageArr.count > nextIndex else {
            return nil
        }
        
        return pageArr[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pageArr.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return pageArr.last
        }
        
        guard pageArr.count > previousIndex else {
            return nil
        }
        
        return pageArr[previousIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageArr.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstVC = viewControllers?.first, let firstVCIndex = pageArr.index(of: firstVC) else {
            return 0
        }
        return firstVCIndex
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.dataSource = self
        self.delegate = self
        
        if let firstVC = pageArr.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
