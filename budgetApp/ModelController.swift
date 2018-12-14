//
//  ModelController.swift
//  mapApp
//
//  Created by 木下岳 on 2018/07/07.
//  Copyright © 2018年 gakukinoshita. All rights reserved.
//

import UIKit

class ModelController: NSObject, UIPageViewControllerDataSource {
    
    var pageData: [String] = []
    
    
    override init() {
        super.init()
        for i in 0 ..< 199 {
            pageData.append(String(i))
        }
    }
    
    func viewControllerAtIndex(_ index: Int, storyboard: UIStoryboard) -> selectViewController? {
        // Return the data view controller for the given index.
        if (self.pageData.count == 0) || (index >= self.pageData.count) {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let dataViewController = storyboard.instantiateViewController(withIdentifier: "DataViewController") as! selectViewController
        dataViewController.dataObject = self.pageData[index]
        return dataViewController
    }
    
    func indexOfViewController(_ viewController: selectViewController) -> Int {
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
        return pageData.index(of: viewController.dataObject) ?? NSNotFound
    }
    
    // MARK: - Page View Controller Data Source
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! selectViewController)
        index -= 1
        return self.viewControllerAtIndex(self.enableDataIndex(index), storyboard: viewController.storyboard!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! selectViewController)
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        return self.viewControllerAtIndex(self.enableDataIndex(index), storyboard: viewController.storyboard!)
    }
    
    func enableDataIndex(_ index: Int) -> Int {
        var dataIndex       = index
        let pageDataCount   = self.pageData.count
        var isMinus         = false
        
        if dataIndex < 0 {
            dataIndex *= -1
            isMinus = true
        }
        while dataIndex >= pageDataCount {
            dataIndex -= pageDataCount
        }
        if isMinus {
            dataIndex = pageDataCount - dataIndex
        }
        return dataIndex
    }
    
}

