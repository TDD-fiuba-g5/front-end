//
//  ViewController.swift
//  front-end
//
//  Created by Santiago Lazzari on 30/04/2018.
//  Copyright © 2018 Santiago Lazzari. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
//        self.tableView.delegate = self
        self.tableView.reloadData()
    }
}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return RuleTableViewCell()
    }
}

