import UIKit

import SnapKit

final class MyPageTableViewCell: UITableViewCell {
    
    static let identifier = "MyPageTableViewCell"
    
    private let separatorLine: UIView = UIView().then {
        $0.backgroundColor = UIColor(named: "grey07")
        $0.isHidden = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSeparatorLine()
        configureMargins()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSeparatorLine() {
        addSubview(separatorLine)
        separatorLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(8)
        }
    }
    
    private func configureMargins() {
        layoutMargins = UIEdgeInsets.zero
        separatorInset = UIEdgeInsets.zero
        contentView.layoutMargins = UIEdgeInsets.zero
    }
    
    func showSeparatorLine(_ show: Bool) {
        separatorLine.isHidden = !show
    }
}
