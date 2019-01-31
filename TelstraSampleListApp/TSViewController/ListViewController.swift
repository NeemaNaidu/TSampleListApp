//
//  ListViewController.swift
//  TelstraSampleProject
//
//  Created by cts on 23/01/19.
//  Copyright © 2019 cts. All rights reserved.
//

import Foundation
import UIKit
let navBarHeight: CGFloat = 64.0
let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var telstraSampleViewModel = TelstraSampleViewModel()
    private var myTableView: UITableView!
    let cellId = Contants.cellId
    var customValues : [TSCustomTableValues]  = [TSCustomTableValues]()
    var refreshControl = UIRefreshControl()
    var imageCache:NSCache<AnyObject, AnyObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageCache = NSCache()
        addActivityIndicator()
        // Do any additional setup after loading the view, typically from a nib.
        telstraSampleViewModel.fetchJSONList
        {
           self.createInitialTableViewAndNavBar()
           self.addRefreshcontrol()
           self.myTableView.reloadData()
           activityIndicator.stopAnimating()
        }
    }
    
    func addActivityIndicator()
    {
        activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        activityIndicator.color = UIColor.darkGray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    func addRefreshcontrol()
    {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: Contants.pullToRefresh)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.myTableView.addSubview(refreshControl)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  telstraSampleViewModel.numberOfItemsToDisplay(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = TSCustomTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
        cell.sizeToFit()
        cell.selectionStyle = .none
        cell.nameLabel.text = telstraSampleViewModel.appTitleToDisplay(for: indexPath)
        cell.descriptionTxtView.text = telstraSampleViewModel.appDescriptionToDisplay(for: indexPath)
        cell.listImage.image = UIImage(named:"noImage")!
        
        if (self.imageCache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil){
            // Use cache
            print("Cached image used, no need to download it")
            cell.listImage.image = self.imageCache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
        }
        else
        {
            let url = URL(string: telstraSampleViewModel.imagesURLToDisplay(for: indexPath))
            if let url = url {
                 DispatchQueue.global().async { [weak cell] in
                 let data = try? Data(contentsOf: url)
                    if let data = data {
                        DispatchQueue.main.async {
                            let img:UIImage! = UIImage(data: data)
                            cell?.listImage.image = img
                            self.imageCache.setObject(img, forKey: (indexPath as NSIndexPath).row as AnyObject)
                          }
                    }
                    else{
                     print("image not available")
                   }
                }
             }
          }
     return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        return UITableViewAutomaticDimension
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        createInitialTableViewAndNavBar()
    }
    
    @objc func refresh(_ sender: Any) {
        telstraSampleViewModel.fetchJSONList {
            self.myTableView.reloadData()
        }
        refreshControl.endRefreshing()
        activityIndicator.stopAnimating()
    }

    func createInitialTableViewAndNavBar()
    {
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = UIScreen.main.bounds.width
        let displayHeight: CGFloat = UIScreen.main.bounds.height

        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: barHeight, width: UIScreen.main.bounds.width, height: navBarHeight))
        self.view.addSubview(navBar);
        var navItem = UINavigationItem()
        if let modelHeaderText = telstraSampleViewModel.titleToDisplay() {
           navItem = UINavigationItem(title: modelHeaderText);
        }
        navBar.setItems([navItem], animated: true);

        myTableView = UITableView(frame: CGRect(x: 0, y: navBar.frame.size.height, width: displayWidth, height: displayHeight - barHeight))
        myTableView.register(TSCustomTableViewCell.self, forCellReuseIdentifier: cellId)
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
        
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        myTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        myTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navBar.bottomAnchor.constraint(equalTo: myTableView.topAnchor).isActive = true
        navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

