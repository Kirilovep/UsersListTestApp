//
//  NetworkManager.swift
//  UsersListTestApp
//
//  Created by shizo663 on 06.03.2021.
//

import Foundation


class NetworkManager {
    
    static func fetchUsersData(_ completionHandler: @escaping (UsersList?) -> Void) {
        if let url = URL(string: Urls.randomUserUrl.rawValue) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                }
                
                if let response = response {
                    
                }
                
                if let data = data {
                    let objects = try? JSONDecoder().decode(UsersList.self, from: data)
                    completionHandler(objects)
                }
            }
            task.resume()
        }
    }
}
