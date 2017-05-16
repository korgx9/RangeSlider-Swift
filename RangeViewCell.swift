import Foundation
import UIKit
import Eureka
import TTRangeSlider

// Custom Cell with value type: Bool
// The cell is defined using a .xib, so we can set outlets :)

public class RangeViewCell: Cell<String>, CellType, TTRangeSliderDelegate {
    
    @IBOutlet weak var rangeSlider: TTRangeSlider!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    private var umt = ""
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func setup() {
        super.setup()
        rangeSlider.delegate = self
        accessoryType = .none
        editingAccessoryType =  .none
        textLabel?.text = nil
        detailTextLabel?.text = nil
        
        titleLabel.text = row.title
        
        rangeSlider.minValue        = rangeViewRow.minValue
        rangeSlider.maxValue        = rangeViewRow.maxValue
        
        if let selectedMin = rangeViewRow.selectedMinimumValue {
            rangeSlider.selectedMinimum = selectedMin
        }
        
        if let selectedMax = rangeViewRow.selectedMaximumValue {
            rangeSlider.selectedMaximum = selectedMax
        }
        
        if let step = rangeViewRow.step {
            rangeSlider.step = step
        }
        
        umt = ""
        if let umtC = rangeViewRow.unitMeassureText {
            umt = umtC
        }
        
        rangeSlider.enableStep = true
        updateLabelsValues(min: rangeSlider.selectedMinimum, max: rangeSlider.selectedMaximum)
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    public override func update() {
        super.update()
        accessoryType = .none
        editingAccessoryType =  .none
        textLabel?.text = nil
        detailTextLabel?.text = nil
    }
    
    public override func didSelect() {
        
    }
    
    public func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        updateLabelsValues(min: selectedMinimum, max: selectedMaximum)
    }
    
    private var rangeViewRow: RangeViewRow {
        return row as! RangeViewRow
    }
    
    func updateLabelsValues(min:Float, max: Float) {
        
        if min == rangeSlider.minValue && max == rangeSlider.maxValue {
            fromLabel.isHidden    = false
            toLabel.isHidden      = true
            fromLabel.text = NSLocalizedString("Все", comment: "Eureka range slider label if all sekected")
        }
        else if min == rangeSlider.minValue && max != rangeSlider.maxValue {
            fromLabel.isHidden    = true
            toLabel.isHidden      = false
            
            toLabel.text = NSLocalizedString("до", comment: "Eureka range slider label to") + " " + max.description + " " + umt
        }
        else if min != rangeSlider.minValue && max == rangeSlider.maxValue {
            fromLabel.isHidden    = false
            toLabel.isHidden      = true
            
            fromLabel.text = NSLocalizedString("от", comment: "Eureka range slider label to") + " " + min.description + " " + umt
        }
        else {
            fromLabel.isHidden    = false
            toLabel.isHidden      = false
            fromLabel.text = NSLocalizedString("от", comment: "Eureka range slider label from") + " " + min.description + " " + umt
            toLabel.text = NSLocalizedString("до", comment: "Eureka range slider label to") + " " + max.description + " " + umt
        }
        
        row.value = "\(min):\(max)"
    }
}
public final class RangeViewRow: Row<RangeViewCell>, RowType {
    public var minValue: Float = 0.0
    public var maxValue: Float = 1.0
    public var selectedMinimumValue: Float?
    public var selectedMaximumValue: Float?
    public var unitMeassureText: String?
    public var step: Float?


    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<RangeViewCell>(nibName: "RangeViewCell")
    }
}
