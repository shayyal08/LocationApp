//
//  ShowLocationUpdateViewController.swift
//  LocationApp
//
//  Created by Shilpa Hayyal on 18/03/21.
//

import UIKit

class ShowLocationUpdateViewController: UIViewController,Storyboarded {
    var viewModel:LocationViewModel!
    var totalLocationsSavedToday:Int = 0
    var lastUpdatedTimestamp:Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel?.fetchDataListener()
        bindViewModel()
        viewModel.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.viewModel.removeListener()
    }
    
    @IBOutlet private weak var showLastUpdatedTimeLabel:UILabel!
    @IBOutlet private weak var showTotalNumberOfUpdatesLabel:UILabel!
    
    func updateUI() {
        self.showLastUpdatedTimeLabel.text = "Database last updated time: " + Date.dateInStringForm(time:lastUpdatedTimestamp)
        self.showTotalNumberOfUpdatesLabel.text = "Today database is updated" + " " + "\(totalLocationsSavedToday)" + " times."
    }
    
    @IBAction func closeViewController(_ sender:UIButton) {
        //self.dismiss(animated:true, completion:nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func bindViewModel() {
        viewModel.didChangeData = { [weak self] data in
            guard let strongSelf = self else { return }
    

            strongSelf.totalLocationsSavedToday = data.count
            strongSelf.lastUpdatedTimestamp = data.lastUpdated
            strongSelf.updateUI()
        }
    }

}
