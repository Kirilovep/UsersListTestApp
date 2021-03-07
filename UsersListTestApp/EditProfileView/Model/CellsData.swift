//
//  CellsData.swift
//  UsersListTestApp
//
//  Created by shizo663 on 06.03.2021.
//

import Foundation

struct CellsData {
    var type: DataType
    var data: Any?
}


enum DataType {
    case textInput
    case image
}
