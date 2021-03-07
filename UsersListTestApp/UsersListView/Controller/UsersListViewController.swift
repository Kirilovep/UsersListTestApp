//
//  ViewController.swift
//  UsersListTestApp
//
//  Created by shizo663 on 06.03.2021.
//

import UIKit

class UsersListViewController: UIViewController {
    
    //MARK: - Properties -
    var usersData: [Result] = []
    
    //MARK: - IBOutlets -
    @IBOutlet weak var usersTableView: UITableView! {
        didSet {
            let nib = UINib(nibName: Cells.UsersCellNib.rawValue, bundle: nil)
            
            usersTableView.register(nib, forCellReuseIdentifier: Cells.UsersCellIdentifier.rawValue)
            usersTableView.delegate = self
            usersTableView.dataSource = self
            usersTableView.rowHeight = 75
            
            self.tabBarController?.delegate = self
        }
    }
    
    //MARK: - LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
    }
    
    private func fetchData() {
        NetworkManager.fetchUsersData { [weak self] (users) in
            guard let self = self else { return }
            self.usersData += users?.results ?? []
            DispatchQueue.main.async {
                self.usersTableView.reloadData()
            }
        }
    }
}

//MARK:- TableView extenstion
extension UsersListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.UsersCellIdentifier.rawValue, for: indexPath) as? UsersTableViewCell
        
        guard let usersCell = cell else { return UITableViewCell() }
        
        usersCell.configure(usersData[indexPath.row])
        usersCell.accessoryType = .disclosureIndicator
        
        if indexPath.row == usersData.count - 3 {
            fetchData()
        }
        
        return usersCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(identifier: VC.EditProfileVC.rawValue) as! EditProfileViewController
        let currentUser = usersData[indexPath.row]
        vc.profileData.firstName = currentUser.name?.first
        vc.profileData.lastName = currentUser.name?.last
        vc.profileData.email = currentUser.email
        vc.profileData.image = currentUser.picture?.large
        vc.profileData.phone = currentUser.phone
        navigationController?.pushViewController(vc, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK:- TabBar extenstion
extension UsersListViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        
        if tabBarIndex == 0 {
            self.usersTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition(rawValue: 0)!, animated: true)
        }
    }
}

