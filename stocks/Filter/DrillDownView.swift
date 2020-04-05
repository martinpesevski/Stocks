import UIKit
import SnapKit

protocol DrillDownDelegate: class {
    func didSelect(filter: FilterType)
}

class DrillDownView: AccessoryView {
    var filter: FilterType {
        didSet {
            setup(filter)
        }
    }
    weak var delegate: DrillDownDelegate?
    
    lazy var drillDown: UIImageView = {
        let view = UIImageView(image: UIImage.init(named: "right"))
        view.tintColor = .label
        view.snp.makeConstraints { make in make.width.height.equalTo(36) }
        return view
    }()
    
    override func onTap() {
        delegate?.didSelect(filter: filter)
    }
    
    init(filter: FilterType, delegate: DrillDownDelegate? = nil) {
        self.filter = filter
        self.delegate = delegate
        super.init()

        content.addArrangedSubview(drillDown)
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
