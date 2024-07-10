import UIKit

import SnapKit

final class MyPageTableViewCell: UITableViewCell {
    
    static let identifier = "MyPageTableViewCell"
    
    private let separatorLine = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setStyle()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        separatorLine.do {
            $0.backgroundColor = .grey07
            $0.isHidden = true
        }
        
        layoutMargins = UIEdgeInsets.zero
        separatorInset = UIEdgeInsets.zero
        contentView.layoutMargins = UIEdgeInsets.zero
    }
    
    private func setHierarchy() {
        addSubview(separatorLine)
    }
    
    private func setLayout() {
        separatorLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(8)
        }
    }
    
    func showSeparatorLine(_ show: Bool) {
        separatorLine.isHidden = !show
    }
}
