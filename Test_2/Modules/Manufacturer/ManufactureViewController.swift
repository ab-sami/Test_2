//
//  ManufactureViewController.swift
//  Test_2
//
//  Created by Abdul Sami on 29/09/2018.
//  Copyright © 2018 Abdul Sami. All rights reserved.
//

import UIKit

class ManufactureViewController: UIViewController, BaseViewModelDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "ManufacturerCell"
    var selectedManufactureTuple: (key: String, value: String) = ("","")
    public var viewModel: ManufactureViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ManufactureViewModel()
        viewModel.delegate = self
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ContentLoadingView.shared.show(self)
        viewModel.load()
    }

    private func setUpView() {
        self.tableView.refreshControl = createRefreshControl()
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    @objc func forceRefresh() {
        ContentLoadingView.shared.show(self)
        viewModel.load()
    }
    
    private func createRefreshControl() -> UIRefreshControl {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(forceRefresh), for: .valueChanged)
        return refresher
    }
    
    //MARK:- Base view model delegate
    
    func onViewModelReady(_ viewModel: BaseViewModel) {
        if (self.tableView.refreshControl?.isRefreshing)! {
            self.tableView.refreshControl?.endRefreshing()
        }
        ContentLoadingView.shared.hide()
        tableView.reloadData()
    }
    
    func onViewModelError(_ viewModel: BaseViewModel, error: Error) {
        if (self.tableView.refreshControl?.isRefreshing)! {
            self.tableView.refreshControl?.endRefreshing()
        }
        ContentLoadingView.shared.hide()
        self.handleError()
    }
    
    func handleError() {
        let alertView = UIAlertController(title: "Error!!", message: "OOPS! An error occured. Pull down to refresh again.", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            alertView.dismiss(animated: true, completion: nil)
        }))
        self.present(alertView, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let modelsVC = segue.destination as? ModelViewController {
            modelsVC.selectedManufactureTuple = self.selectedManufactureTuple
        }
    }
}

extension ManufactureViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getManufactureListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CarTableViewCell
        cell.titleLabel.text = viewModel.getManufactureTitleBy(idx: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedManufactureTuple = viewModel.getManufacturerDetailBy(idx: indexPath.row)
        self.performSegue(withIdentifier: "ShowCarModels", sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? CarTableViewCell else { return }
        cell.backgroundColor = indexPath.row % 2 == 1 ? Color.background : UIColor.white
        cell.titleLabel.textColor = indexPath.row % 2 == 0 ? Color.text : UIColor.white
    }
    
    //MARK: - ScrollView Delegate
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            checkHasScrolledToBottom(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        checkHasScrolledToBottom(scrollView)
    }
    
    func checkHasScrolledToBottom(_ scrollView: UIScrollView) {
        
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height + 150
        if bottomEdge >= scrollView.contentSize.height {
            guard viewModel.hasNextPage() else {
                return
            }
            ContentLoadingView.shared.show(self, .bottom)
            viewModel.loadNextPage(completion: { [weak self] (page) in
                ContentLoadingView.shared.hide()
                self?.tableView.reloadData()
                self?.tableView.reloadRows(at: [IndexPath(row: page * 15, section: 0)], with: .automatic)
            }, onError: { [weak self] (error) in
                ContentLoadingView.shared.hide()
                self?.handleError()
            })
        }
    }
}

