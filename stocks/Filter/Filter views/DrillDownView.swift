import UIKit
import SnapKit

protocol DrillDownDelegate: AnyObject {
    func didSelect(filter: FilterType)
}

class DrillDownView: AccessoryView {
    var filter: FilterType {
        didSet {
            setup(filter)
        }
    }
    weak var delegate: DrillDownDelegate?
    
    override func onTap() {
        delegate?.didSelect(filter: filter)
    }
    
    init(filter: FilterType, delegate: DrillDownDelegate? = nil) {
        self.filter = filter
        self.delegate = delegate
        super.init(accessoryType: .rightArrow)

        setup(filter)
    }
    
    private func setup(_ filterType: FilterType) {
        title.text = filter.title
        explanation.text = filter.explanation
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
