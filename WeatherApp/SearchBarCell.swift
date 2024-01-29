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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.backgroundColor = UIColor.clear
        
    }
    
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        guard let searchTerm = searchBar.text else { return }
        
        city.shared.name = searchBar.text!
        delegate?.searchBarCell(self, didTapSearchButtonWith: searchTerm)
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
