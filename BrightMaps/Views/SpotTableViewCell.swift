import UIKit

class SpotTableViewCell: UITableViewCell {

    @IBOutlet weak var spotName: UILabel!
    @IBOutlet weak var initialDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
