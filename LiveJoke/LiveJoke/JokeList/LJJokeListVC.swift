//
//  LJJokeListVC.swift
//  LiveJoke
//
//  Created by Prakash Raj on 06/05/23.
//

import UIKit

class LJJokeListVC: UIViewController {
    
    private let presenter = LJJokePresenter()
    private let table = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.delegate = self
        self.presenter.getNextJoke()
        self.addTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.presenter.stop()
        self.presenter.cacheCurrentList()
        
    }
}

// MARK: - Private funtions
private extension LJJokeListVC {
    func addTable() {
        self.view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        table.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        table.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "kJokeTableCell")
        table.dataSource = self
        table.delegate = self
        
        self.addHeader()
    }
    
    func addHeader() {
        let hView = UIView.init(frame: CGRect.init(x: 0, y: 50, width: 300, height: 50))
        hView.backgroundColor = UIColor.clear

        let lbl = UILabel.init(frame: CGRect.init(x: 15, y: 10, width: 300, height: 24))
        lbl.font = UIFont.boldSystemFont(ofSize: 30)
        lbl.text = "Jokes".uppercased()

        hView.addSubview(lbl)
        self.table.tableHeaderView = hView
    }
}

extension LJJokeListVC: LJJokePresenterDelegate {
    func presenterDidupdateData() {
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
}


// MARK: - UITableViewDataSource
extension LJJokeListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.allJokes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "kJokeTableCell", for: indexPath)
        cell.textLabel?.text = self.presenter.allJokes[indexPath.row].content
        cell.textLabel?.numberOfLines = 0
      return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
