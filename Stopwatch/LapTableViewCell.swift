import UIKit

class LapTableViewCell: UITableViewCell {
    @IBOutlet var labelNumber: UILabel!
    @IBOutlet var labelTime: UILabel!
    
    func bind(_ lap: Lap) {
        labelNumber.text = String(lap.number)
        labelTime.text = formatTotalMilliseconds(lap.time)
    }
}
