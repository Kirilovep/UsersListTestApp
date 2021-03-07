//
//  EditProfileViewController.swift
//  UsersListTestApp
//
//  Created by shizo663 on 06.03.2021.
//

import UIKit
import CoreData
class EditProfileViewController: UIViewController {
    
    //MARK: Properties -
    var cellData: [CellsData] = []
    var profileData = ProfileData()
    let saveButton = UIBarButtonItem()
    var userName: String?
    var userNewImage: UIImage?
    
    //MARK: - IBOutlets -
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let headerNib = UINib(nibName: Cells.HeaderCellNib.rawValue, bundle: nil)
            let firstNameNib = UINib(nibName: Cells.FirstNameCellNib.rawValue, bundle: nil)
            let lastNameNib = UINib(nibName: Cells.LastNameCellNib.rawValue, bundle: nil)
            let emailNib = UINib(nibName: Cells.EmailCellNib.rawValue, bundle: nil)
            let phoneNib = UINib(nibName: Cells.PhoneCellNib.rawValue, bundle: nil)
            
            tableView.register(phoneNib, forCellReuseIdentifier: Cells.PhoneCellIdentifier.rawValue)
            tableView.register(emailNib, forCellReuseIdentifier: Cells.EmaiCellIdentifier.rawValue)
            tableView.register(lastNameNib, forCellReuseIdentifier: Cells.LastNameCellIdentifier.rawValue)
            tableView.register(firstNameNib, forCellReuseIdentifier: Cells.FirstNameCellIdentifier.rawValue)
            tableView.register(headerNib, forCellReuseIdentifier: Cells.HeaderCellIdentifier.rawValue)
            
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.tableFooterView = UIView()
        }
    }
    
    //MARK: - LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit user profile"
        createCellsData()
        setButton()
        
    }
    
    //MARK: - Functions -
    private func setButton() {
        saveButton.title = "Save"
        saveButton.style = .plain
        saveButton.target = self
        saveButton.action = #selector(saveTapped)
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc private func saveTapped() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if userName == nil {
            let usersData = UsersCoreData(context: context)
            usersData.firstName = profileData.firstName
            usersData.lastName = profileData.lastName
            usersData.imageUrl = profileData.image
            usersData.phone = profileData.phone
            usersData.email = profileData.email
            if let imageData = userNewImage?.pngData() {
                usersData.imageData = imageData
            }
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            
        } else {
            let user: UsersCoreData!
            let fetchUser: NSFetchRequest<UsersCoreData> = UsersCoreData.fetchRequest()
            fetchUser.predicate = NSPredicate(format: "firstName = %@", userName!)
            let results = try? context.fetch(fetchUser)
            
            if results?.count == 0{
                
            } else {
                user = results?.first
                
                user.firstName = profileData.firstName
                user.lastName = profileData.lastName
                user.email = profileData.email
                user.imageUrl = profileData.image
                user.phone = profileData.phone
                if let imageData = userNewImage?.pngData() {
                    user.imageData = imageData
                }
            }
            
            try! context.save()
            
        }
        tabBarController?.selectedIndex = 1
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    private func createCellsData() {
        cellData.append(CellsData(type: .image, data: UIImage()))
        cellData.append(CellsData(type: .textInput, data: "firstName"))
        cellData.append(CellsData(type: .textInput, data: "lastName"))
        cellData.append(CellsData(type: .textInput, data: "email"))
        cellData.append(CellsData(type: .textInput, data: "phone"))
    }
    
    
    private func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
}


//MARK: - TableView extenstion -
extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentData = cellData[indexPath.row]
        
        switch currentData.type {
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.HeaderCellIdentifier.rawValue) as! HeaderTableViewCell
            if userNewImage == nil {
                cell.setUpImage(profileData.image)
            } else {
                cell.configure(userNewImage)
            }
            
            cell.delegate = self
            
            return cell
        case .textInput:
            if currentData.data as! String == "firstName" {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.FirstNameCellIdentifier.rawValue) as! FirstNameTableViewCell
                
                cell.firstNameTextField.text = profileData.firstName
                cell.firstNameTextField.tag = indexPath.row
                cell.firstNameTextField.delegate = self
                
                return cell
            } else if currentData.data as! String == "lastName" {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.LastNameCellIdentifier.rawValue) as! LastNameTableViewCell
                
                cell.lastNameTextField.text = profileData.lastName
                cell.lastNameTextField.tag = indexPath.row
                cell.lastNameTextField.delegate = self
                
                return cell
            } else if currentData.data as! String == "email" {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.EmaiCellIdentifier.rawValue) as! EmailTableViewCell
                
                cell.emailTextField.text = profileData.email
                cell.emailTextField.tag = indexPath.row
                cell.emailTextField.delegate = self
                
                return cell
            } else if currentData.data as! String == "phone" {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.PhoneCellIdentifier.rawValue) as! PhoneTableViewCell
                
                cell.phoneTextField.text = profileData.phone
                cell.phoneTextField.tag = indexPath.row
                cell.phoneTextField.delegate = self
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        } else {
            return 50
        }
    }
    
}

//MARK: - TextField extension -
extension EditProfileViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
    }
    
    @objc func valueChanged(_ textField: UITextField){
        
        if let newTextField = textField.text {
            switch textField.tag {
            case TextFieldData.firstNameTextField.rawValue:
                profileData.firstName = newTextField
                
                if newTextField.count > 0 && newTextField.trimmingCharacters(in: .whitespaces).isEmpty {
                    saveButton.isEnabled = false
                } else {
                    saveButton.isEnabled = true
                }
                if newTextField.count == 0{
                    saveButton.isEnabled = false
                }
            case TextFieldData.lastNameTextField.rawValue:
                profileData.lastName = newTextField
                
                if newTextField.count > 0 && newTextField.trimmingCharacters(in: .whitespaces).isEmpty {
                    saveButton.isEnabled = false
                } else {
                    saveButton.isEnabled = true
                }
                if newTextField.count == 0{
                    saveButton.isEnabled = false
                }
                
            case TextFieldData.emailTextField.rawValue:
                profileData.email = newTextField
                if isValidEmail(email: newTextField) {
                    saveButton.isEnabled = true
                } else {
                    saveButton.isEnabled = false
                }
            case TextFieldData.phoneTextField.rawValue:
                profileData.phone = newTextField
                
                if newTextField.count == 0 {
                    saveButton.isEnabled = false
                } else {
                    saveButton.isEnabled = true
                }
            default:
                break
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        func validation() -> Bool {
            guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 30
        }
        
        
        switch textField.tag {
        case TextFieldData.firstNameTextField.rawValue:
            return validation()
        case TextFieldData.lastNameTextField.rawValue:
            return validation()
        default:
            return true
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

//MARK: - ImagePicker extension -
extension EditProfileViewController: HeaderTableViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func buttonPressed() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        let alert = UIAlertController(title: "From", message: "", preferredStyle: .alert)
        
        let albumAction = UIAlertAction(title: "Album", style: .default) { (_ ) in
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
            
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(albumAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userNewImage = image
            
        }
        
        tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
