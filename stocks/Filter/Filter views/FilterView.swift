import UIKit
import SnapKit

protocol FilterViewDelegate: AnyObject {
    func didChangeSelection(view: FilterView, isSelected: Bool, isLocked: Bool)
}

class FilterView: AccessoryView {
    var filter: TitleDescription
    weak var delegate: FilterViewDelegate?
    
    var isSelected = false {
        didSet {
            onSelectedChanged(isSelected)
        }
    }
    
    func onSelectedChanged(_ selected: Bool) {
        accessoryType = isSelected ? .checkboxFull : .checkboxEmpty
    }
    
    var isLocked: Bool
    
    override func onTap() {
        if !isLocked { isSelected = !isSelected }
        delegate?.didChangeSelection(view: self, isSelected: isSelected, isLocked: isLocked)
    }
    
    init(filter: TitleDescription, delegate: FilterViewDelegate? = nil, isLocked: Bool = false) {
        self.filter = filter
        self.delegate = delegate
        self.isLocked = isLocked
        isSelected = UserDefaults.standard.bool(forKey: filter.title)

        super.init(accessoryType: isLocked ? .locked : (isSelected ? .checkboxFull : .checkboxEmpty))

        title.text = filter.title
        explanation.text = filter.explanation
    }
    
    func setup(isLocked: Bool, isSelected: Bool) {
        self.isLocked = isLocked
        accessoryType = isLocked ? .locked : (isSelected ? .checkboxFull : .checkboxEmpty)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
