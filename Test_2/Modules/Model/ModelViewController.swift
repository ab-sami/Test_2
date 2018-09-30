//
//  ModelViewController.swift
//  Test_2
//
//  Created by Abdul Sami on 29/09/2018.
//  Copyright © 2018 Abdul Sami. All rights reserved.
//

import UIKit

class ModelViewController: UIViewController, BaseViewModelDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "ModelCell"
    var selectedManufactureTuple: (key: String, value: String) = ("","")
    var viewModel: ModelsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = ModelsViewModel(manufacturerId: selectedManufactureTuple.key)
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
    
    private func showVehicleDetail(vehicleModel: String) {
        let alertView = UIAlertController(title: "\(selectedManufactureTuple.value) \(vehicleModel)", message: nil, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Drive It!!", style: .destructive, handler: { (action) in
            alertView.dismiss(animated: true, completion: nil)
        }))
        self.present(alertView, animated: true, completion: nil)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ModelViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getModelListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CarTableViewCell
        cell.titleLabel.text = viewModel.getModelTitleBy(idx: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? CarTableViewCell else { return }
        cell.backgroundColor = indexPath.row % 2 == 1 ? Color.background : UIColor.white
        cell.titleLabel.textColor = indexPath.row % 2 == 0 ? Color.text : UIColor.white
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showVehicleDetail(vehicleModel: viewModel.getModelTitleBy(idx: indexPath.row))
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
