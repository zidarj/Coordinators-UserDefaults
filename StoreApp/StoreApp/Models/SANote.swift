//
//  SANote.swift
//  StoreApp
//
//  Created by Josip Zidar on 12.05.2021..
//

import Foundation
import UIKit

class SANote: Codable {
    private enum CodingKeys: String, CodingKey {
        case title,
             note,
             date
    }
    
    var title: String
    var note: String
    var date: Date
    
    init(with title: String, note: String, date: Date) {
        self.title = title
        self.note = note
        self.date = date
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        note = try container.decode(String.self, forKey: .note)
        date = try container.decode(Date.self, forKey: .date)
    }
}
