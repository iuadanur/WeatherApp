//
//  SearchBarCell.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 28.01.2024.
//

import UIKit

protocol SearchBarCellDelegate: AnyObject {
    func searchBarCell(_ cell: SearchBarCell, didTapSearchButtonWith searchTerm: String)
}

class SearchBarCell: UITableViewCell {

    weak var delegate: SearchBarCellDelegate?
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.backgroundColor = UIColor.clear
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard let searchTerm = searchBar.text else { return }
        
        City.shared.name = searchBar.text!
        delegate?.searchBarCell(self, didTapSearchButtonWith: searchTerm)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
