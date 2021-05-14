//
//  SANoteTableViewCell.swift
//  StoreApp
//
//  Created by Josip Zidar on 12.05.2021..
//

import UIKit

final class SANoteTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    final func config(with note: SANote) {
        titleLabel.text = note.title
        dateLabel.text = note.date.dateToString
    }
}
