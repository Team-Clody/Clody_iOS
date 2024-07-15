import UIKit

import Then
import SnapKit

final class SettingNotificationTimeView: BaseView {

    // MARK: - Properties
    
    var selectedTime: String = "오후 9시 30분"
    var closeHandler: (() -> Void)?
    var doneHandler: ((String) -> Void)?

    private var dimmingView: UIView?
    private var notificationBottomSheetView: NotificationBottomSheetView?

    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    
    override func setStyle() {
        backgroundColor = .clear
    }

    override func setHierarchy() {
        dimmingView = UIView().then {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.55)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCloseButton))
            $0.addGestureRecognizer(tapGesture)
        }

        notificationBottomSheetView = NotificationBottomSheetView().then {
            $0.titleLabel.text = "다른 시간 보기"
            $0.closeButton.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
            $0.doneButton.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
        }

        guard let dimmingView = dimmingView, let notificationBottomSheetView = notificationBottomSheetView else { return }

        addSubviews(dimmingView, notificationBottomSheetView)
    }

    override func setLayout() {
        dimmingView?.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        notificationBottomSheetView?.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(ScreenUtils.getHeight(360))
        }
    }

    // MARK: - Actions
    
    @objc private func handleCloseButton() {
        closeHandler?()
    }

    @objc private func handleDoneButton() {
        if let pickerView = notificationBottomSheetView?.pickerView {
            let selectedPeriodIndex = pickerView.selectedRow(inComponent: 0)
            let selectedHourIndex = pickerView.selectedRow(inComponent: 1)
            let selectedMinuteIndex = pickerView.selectedRow(inComponent: 2)

            let period = selectedPeriodIndex == 0 ? "오전" : "오후"
            let selectedHour = selectedHourIndex + 1
            let selectedMinute = selectedMinuteIndex * 10

            selectedTime = String(format: "%@ %d시 %02d분", period, selectedHour, selectedMinute)
            doneHandler?(selectedTime)
        }
        handleCloseButton()
    }
}

