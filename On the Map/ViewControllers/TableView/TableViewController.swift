//
//  TableViewController.swift
//  On the Map
//
//  Created by Laxman Nyamagouda on 5/24/20.
//  Copyright © 2020 Laxman Nyamagouda. All rights reserved.
//

import Foundation

import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet var Table: UITableView!
    
    var dataUser = UserData.shared.usersData
    
    var locations: [StudentLocationsResponse] = [] {
        didSet {
            Table.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUsers()
    }
    
    func getUsers(){
        NetworkMananger.shared.getStudentLocations(){(locations, success, error)in
            if success {
                guard let userLocation = locations else {return}
                self.dataUser = userLocation as [StudentLocationsResponse]
                DispatchQueue.main.async {
                    self.Table.reloadData()}
            }else{
                let alert = UIAlertController(title: "Erorr", message: "Failed Request", preferredStyle: .alert )
                    alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                }))
                self.present(alert, animated: true, completion: nil)
                return}
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataUser.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableView") as! TableViewCell
        let data = self.dataUser[indexPath.row] as! StudentLocationsResponse
        
        cell.icon?.image = UIImage(named: "icon_pin")
        let fullName = "\(data.firstName ?? "first name") \(data.lastName ?? "last name")"
        cell.nameLabel.text = fullName
        let mediaUrl = data.mediaURL
        cell.urlLabel.text = mediaUrl
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.dataUser[indexPath.row] as! StudentLocationsResponse
        if let url =  URL(string: data.mediaURL!){
            UIApplication.shared.open(url, options: [:])
        }else{
            let alert = UIAlertController(title: "Erorr", message: "Failed open URL", preferredStyle: .alert )
            alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                return
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        NetworkMananger.shared.logout() { (success) in
            DispatchQueue.main.async {
                if success {
                    self.tabBarController?.dismiss(animated: true, completion: nil)
                    
                }else {
                    let alert = UIAlertController(title: "Erorr", message: "Error in Logout", preferredStyle: .alert )
                    alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return}
            }
        }
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        getUsers()
    }
    
    @IBAction func addButton(_ sender: Any) {
        if let addLocationController = self.storyboard?.instantiateViewController(withIdentifier: "AddLocation") {
            self.present(addLocationController, animated: true, completion: nil)}
    }
    
}
