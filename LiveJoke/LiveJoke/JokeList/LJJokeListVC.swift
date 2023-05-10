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
        self.view.backgroundColor = UIColor(hexString: "F0F5FE")
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
        self.table.backgroundColor = .clear
        self.table.translatesAutoresizingMaskIntoConstraints = false
        self.table.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        self.table.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        self.table.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        self.table.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        
        LJJokeCell.register(table: self.table)
        self.table.dataSource = self
        self.table.delegate = self
        
        self.table.separatorStyle = .none
        self.table.separatorColor = .clear
        self.addHeader()
    }
    
    func addHeader() {
        let hView = UIView.init(frame: CGRect.init(x: 0, y: 50, width: 300, height: 40))
        hView.backgroundColor = UIColor.clear

        let lbl = UILabel.init(frame: CGRect.init(x: 15, y: 10, width: 300, height: 24))
        lbl.font = UIFont.boldSystemFont(ofSize: 30)
        lbl.text = "Jokes"
        lbl.textColor = UIColor(hexString: "23447B")
        hView.addSubview(lbl)
        self.table.tableHeaderView = hView
    }
}

extension LJJokeListVC: LJJokePresenterDelegate {
    
    func insert(joke: LJJokeInfo, at: Int) {
        DispatchQueue.main.async {
            self.table.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
    
    func remove(joke: LJJokeInfo?, from: Int) {
//        DispatchQueue.main.async {
//            self.table.deleteRows(at: [IndexPath(item: from, section: 0)], with: .fade)
//        }
    }
}


// MARK: - UITableViewDataSource
extension LJJokeListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.allJokes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LJJokeCell.cellId, for: indexPath) as! LJJokeCell
        cell.display(joke: self.presenter.allJokes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


class LJJokeCell: UITableViewCell {
    
    private(set) var jokeLbl: UILabel?
    private(set) var jokeContV: UIView?

    class var cellId: String { return "kJokeTableCell"}
    class func register(table: UITableView) {
        table.register(LJJokeCell.self, forCellReuseIdentifier: LJJokeCell.cellId)
    }
    
    func display(joke: LJJokeInfo) {
        self.backgroundColor = .clear
        if jokeContV == nil {
            let contV = UIView()
            contV.translatesAutoresizingMaskIntoConstraints = false
            contV.backgroundColor = UIColor.white
            contV.sizeToFit()
            self.contentView.addSubview(contV)
          
            NSLayoutConstraint.activate([
                contV.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 15),
                contV.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor,constant: 10),
                contV.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -30 ),
                contV.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -15 ),
            ])
            
            jokeContV = contV
            contV.roundWith(border: 1, color: UIColor(hexString: "FEFEFA"), rad: 5)
            
            let lbl = UILabel()
            lbl.numberOfLines = 0
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.textColor = UIColor(hexString: "494A50")
            lbl.text = joke.content
            lbl.sizeToFit()
            lbl.font = UIFont(name: "Halvetica", size: 15)
            contV.addSubview(lbl)
            jokeLbl = lbl
            
            NSLayoutConstraint.activate([
                lbl.leadingAnchor.constraint(equalTo: contV.leadingAnchor,constant: 14),
                lbl.topAnchor.constraint(equalTo: contV.safeAreaLayoutGuide.topAnchor,constant: 10),
                lbl.widthAnchor.constraint(equalTo: contV.widthAnchor, constant: -30 ),
                lbl.heightAnchor.constraint(equalTo: contV.heightAnchor, constant: -25 ),
            ])
        }
        jokeLbl?.text = joke.content
    }
}
