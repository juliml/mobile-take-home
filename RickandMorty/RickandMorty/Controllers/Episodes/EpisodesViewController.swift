//
//  EpisodesViewController.swift
//  RickandMorty
//
//  Created by Juliana Lacerda on 2019-07-06.
//  Copyright © 2019 Juliana Lacerda. All rights reserved.
//

import UIKit

class EpisodesViewController: UITableViewController {

    var episodesViewModel: EpisodesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Rick and Morty - Episodes"

        self.showLoading()
        self.episodesViewModel = EpisodesViewModel()
        self.makeEpisodesRequest(firstPage: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func makeEpisodesRequest(firstPage: Bool ) {
        
        self.episodesViewModel?.getAllEpisodes(firstPage: firstPage, completionHandler: { (error) in
            
            self.hideLoading()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            if let error = error {
                print("-->> Error get episodes [VC]: \(error.localizedDescription)")
                self.showAlert(title: "Sorry..." , message: error.localizedDescription)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow, let charactersView = segue.destination as? CharactersViewController else {
            fatalError("indexPath, view nil")
        }
        
        if let episodeResult: Episode = episodesViewModel?.getEpisodeResponseBy(index: indexPath.row) {
            charactersView.episode = episodeResult
        }
        
    }
    
    // MARK: - UITableView Datasource & Delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodesViewModel?.numberOfRows() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath)
        if let episodeResult: Episode = episodesViewModel?.getEpisodeResponseBy(index: indexPath.row) {
            cell.textLabel?.text = episodeResult.name! + " (\(episodeResult.episode!))"
            cell.detailTextLabel?.text = episodeResult.airDate
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        if indexPath.row == lastRowIndex - 1 {
            self.makeEpisodesRequest(firstPage: false)
        }
    }

}

var viewSpinner : UIView?
extension UIViewController {
    
    // MARK: - Loading
    
    func showLoading() {
        let spinnerView = UIView.init(frame: view.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .white)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            self.view.addSubview(spinnerView)
        }
        
        viewSpinner = spinnerView
    }
    
    func hideLoading(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            viewSpinner?.removeFromSuperview()
            viewSpinner = nil
        }
    }
    
    // MARK: - Alert
    
    func showAlert(title:String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

