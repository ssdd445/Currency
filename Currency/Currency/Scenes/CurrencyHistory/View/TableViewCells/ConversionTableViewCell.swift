import UIKit

class ConversionTableViewCell: UITableViewCell {

    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var lblTo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(from currency: String, to: String, symbol: String) {
        self.lblFrom.text = "1 \(currency)"
        self.lblTo.text = "\(to) \(symbol)"
    }
    
}
