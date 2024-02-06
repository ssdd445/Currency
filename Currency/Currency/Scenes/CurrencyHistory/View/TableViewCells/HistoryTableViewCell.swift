import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(history: History) {
        self.lblDate.text = history.date
        
        var detail = ""
        for (_, value) in history.rates.enumerated() {
            detail.append("\(value.key) \(value.value) \n")
        }
        self.lblDescription.text = detail
    }
    
}
