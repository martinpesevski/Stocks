import UIKit
import SnapKit

class FilterView: AccessoryView {
    var filter: TitleDescription

    lazy var selectionBox: UIImageView = {
        let view = UIImageView(image: UIImage.init(named: "checkbox-empty"))
        view.tintColor = .label
        view.snp.makeConstraints { make in make.width.height.equalTo(36) }
        return view
    }()
    
    var isSelected = false {
        didSet {
            selectionBox.image = UIImage(named: isSelected ? "checkbox" : "checkbox-empty")
            selectionBox.tintColor = isSelected ? .systemGreen : .label
        }
    }
    
    override func onTap() {
        isSelected = !isSelected
        UserDefaults.standard.set(isSelected, forKey: filter.title)
    }
    
    init(filter: TitleDescription) {
        self.filter = filter
        super.init()

        content.addArrangedSubview(selectionBox)
        title.text = filter.title
        explanation.text = filter.explanation
        
        isSelected = UserDefaults.standard.bool(forKey: filter.title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
