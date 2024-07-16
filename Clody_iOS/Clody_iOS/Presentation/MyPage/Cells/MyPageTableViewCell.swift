import UIKit

import SnapKit

struct Item {
    let text: String
    let detail: String?
}

final class MyPageTableViewCell: UITableViewCell {
    
    static let identifier = "MyPageTableViewCell"
    
    private let separatorLine = UIView()
    private var latestVersionLabel: UILabel?
    
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
    
    func configure(with setting: Setting, at indexPath: IndexPath) {
        textLabel?.attributedText = UIFont.pretendardString(text: setting.rawValue, style: .body1_medium)
        
        if setting == .version {
            configureVersionLabel(with: "최신 버전")
        } else {
            accessoryType = .disclosureIndicator
            latestVersionLabel?.isHidden = true
        }
    }
    
    private func configureVersionLabel(with text: String) {
        if latestVersionLabel == nil {
            latestVersionLabel = UILabel().then {
                $0.attributedText = UIFont.pretendardString(text: text, style: .body3_medium)
                $0.textColor = .grey05
            }
            contentView.addSubview(latestVersionLabel!)
            latestVersionLabel!.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().offset(-23)
            }
        } else {
            latestVersionLabel?.attributedText = UIFont.pretendardString(text: text, style: .body3_medium)
        }
        latestVersionLabel?.isHidden = false
    }
}
