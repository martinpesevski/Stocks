import UIKit
import SnapKit

protocol FilterViewDelegate: class {
    func didChangeSelection(view: FilterView, isSelected: Bool)
}

class FilterView: AccessoryView {
    var filter: TitleDescription
    weak var delegate: FilterViewDelegate?
    
    var isSelected = false {
        didSet {
            accessoryType = isSelected ? .checkboxFull : .checkboxEmpty
        }
    }
    
    override func onTap() {
        isSelected = !isSelected
        delegate?.didChangeSelection(view: self, isSelected: isSelected)
    }
    
    init(filter: TitleDescription, delegate: FilterViewDelegate? = nil) {
        self.filter = filter
        self.delegate = delegate
        isSelected = UserDefaults.standard.bool(forKey: filter.title)

        super.init(accessoryType: .checkboxEmpty)
        accessoryType = isSelected ? .checkboxFull : .checkboxEmpty

        title.text = filter.title
        explanation.text = filter.explanation
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
