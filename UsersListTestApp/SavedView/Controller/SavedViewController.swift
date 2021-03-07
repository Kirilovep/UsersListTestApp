//
//  SavedViewController.swift
//  UsersListTestApp
//
//  Created by shizo663 on 06.03.2021.
//

import UIKit

class SavedViewController: UIViewController {
    
    
    //MARK: Properties -
    var usersData: [UsersCoreData] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - IBOutlets -
    @IBOutlet weak var savedTableView: UITableView! {
        didSet {
            let nib = UINib(nibName: Cells.UsersCellNib.rawValue, bundle: nil)
            
            savedTableView.register(nib, forCellReuseIdentifier: Cells.UsersCellIdentifier.rawValue)
            
            savedTableView.dataSource = self
            savedTableView.delegate = self
            savedTableView.rowHeight = 75
        }
    }
    
    //MARK: - LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Saved"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    //MARK: - Functions -
    private func getData() {
        do {
            usersData = try context.fetch(UsersCoreData.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
        self.savedTableView.reloadData()
    }
    
    
}

//MARK: - TableView extension -
extension SavedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.UsersCellIdentifier.rawValue) as! UsersTableViewCell
        
        cell.configureFromCoreData(usersData[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = usersData[indexPath.row]
            context.delete(task)
            usersData.remove(at: indexPath.row)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
        }
        savedTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(identifier: VC.EditProfileVC.rawValue) as! EditProfileViewController
        let currentUser = usersData[indexPath.row]
        vc.userName = currentUser.firstName
        vc.profileData.firstName = currentUser.firstName
        vc.profileData.lastName = currentUser.lastName
        vc.profileData.email = currentUser.email
        vc.profileData.image = currentUser.imageUrl
        vc.profileData.phone = currentUser.phone
        if let userImage = currentUser.imageData {
            if let image = UIImage(data: userImage) {
                vc.userNewImage = image
            }
        }
        
        navigationController?.pushViewController(vc, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
