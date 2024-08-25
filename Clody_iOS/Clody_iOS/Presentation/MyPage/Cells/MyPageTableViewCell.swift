import UIKit

import SnapKit

final class MyPageTableViewCell: UITableViewCell {
    
    static let identifier = "MyPageTableViewCell"
    
    private let separatorLine = UIView()
    private var latestVersionLabel: UILabel?
    private let arrowImageView = UIImageView()
    
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
        self.backgroundColor = .white
        
        separatorLine.do {
            $0.backgroundColor = .grey08
            $0.isHidden = true
        }
        
        arrowImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.image = .icArrowRightGrey
        }
        
        layoutMargins = UIEdgeInsets.zero
        separatorInset = UIEdgeInsets.zero
        contentView.layoutMargins = UIEdgeInsets.zero
    }
    
    private func setHierarchy() {
        contentView.addSubviews(separatorLine, arrowImageView)
    }
    
    private func setLayout() {
        separatorLine.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(8))
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints {
            $0.size.equalTo(ScreenUtils.getHeight(25))
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(14))
        }
    }
    
    func showSeparatorLine(_ show: Bool) {
        separatorLine.isHidden = !show
    }
    
    func configure(with setting: Setting, at indexPath: IndexPath) {
        textLabel?.attributedText = UIFont.pretendardString(text: setting.rawValue, style: .body1_medium)
        textLabel?.textColor = .grey03
        
        if setting == .version {
            configureVersionLabel(with: "최신 버전")
            arrowImageView.isHidden = true
        } else {
            latestVersionLabel?.isHidden = true
            arrowImageView.isHidden = false
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
                $0.trailing.equalToSuperview().inset(23)
            }
        } else {
            latestVersionLabel?.attributedText = UIFont.pretendardString(text: text, style: .body3_medium)
        }
        latestVersionLabel?.isHidden = false
    }
}
