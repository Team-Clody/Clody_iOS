//
//  CalendarViewController.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 6/28/24.
//

import UIKit

import FSCalendar
import RxCocoa
import RxSwift
import SnapKit
import Then

enum CalendarCellState {
    case today
    case selected
    case normal
}

final class CalendarViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = CalendarViewModel()
    private let disposeBag = DisposeBag()
    
    private let tapDateRelay = PublishRelay<Date>()
    private let currentPageRelay = PublishRelay<Date>()
    private var calendarData: [CalendarCellModel] = []
    
    // MARK: - UI Components
    
    private let rootView = CalendarView()
    private let deleteBottomSheetView = DeleteBottomSheetView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        setDelegate()
        bindViewModel()
        setStyle()
        setupDeleteBottomSheet()
    }
}

// MARK: - Extensions

private extension CalendarViewController {
    
    func bindViewModel() {
        let input = CalendarViewModel.Input(
            viewDidLoad: Observable.just(()),
            tapDateCell: tapDateRelay.asSignal(),
            tapResponseButton: rootView.calendarButton.rx.tap.asSignal(),
            tapListButton: rootView.calendarNavigationView.listButton.rx.tap.asSignal(),
            tapSettingButton: rootView.calendarNavigationView.settingButton.rx.tap.asSignal(),
            currentPageChanged: currentPageRelay.asSignal()
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.dateLabel
            .drive(rootView.dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.diaryData
            .drive(onNext: { [weak self] data in
                guard let self = self else { return }
                self.rootView.emptyDiaryView.isHidden = data.count != 0
            })
            .disposed(by: disposeBag)

        output.diaryData
            .drive(rootView.dailyDiaryCollectionView.rx.items(cellIdentifier: DailyCalendarCollectionViewCell.description(), cellType: DailyCalendarCollectionViewCell.self)) { index, model, cell in
                cell.bindData(data: model, index: "\(index + 1).")
            }
            .disposed(by: disposeBag)
        
        output.responseButtonStatus
            .drive(onNext: { status in
                print("Status: \(status)")
                // 이후 status에 따른 분기 처리
            })
            .disposed(by: disposeBag)
        
        output.calendarData
            .drive(onNext: { [weak self] data in
                guard let self = self else { return }
                self.calendarData = data
            })
            .disposed(by: disposeBag)
        
        output.selectedDate
            .drive(onNext: { [weak self] data in
                guard let self = self else { return }
                self.rootView.mainCalendarView.reloadData()
                
            })
            .disposed(by: disposeBag)
        
        output.changeToList
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                let listViewController = ListViewController()
                self.navigationController?.pushViewController(listViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.changeToSetting
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                let myPageViewController = MyPageViewController()
                self.navigationController?.pushViewController(myPageViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.calendarButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.responseButtonStatusRelay.accept(self?.viewModel.dailyDiaryDummyDataRelay.value.status ?? "")
            }
            .disposed(by: disposeBag)
        
        rootView.kebabButton.rx.tap
            .bind { [weak self] in
                self?.presentBottomSheet()
            }
            .disposed(by: disposeBag)
    }
    
    func setDelegate() {
        rootView.mainCalendarView.delegate = self
        rootView.mainCalendarView.dataSource = self
    }
    
    func setStyle() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func registerCells() {
        rootView.mainCalendarView.register(CalendarDateCell.self, forCellReuseIdentifier: CalendarDateCell.description())
        rootView.dailyDiaryCollectionView.register(DailyCalendarCollectionViewCell.self, forCellWithReuseIdentifier: DailyCalendarCollectionViewCell.description())
    }
    
    private func setupDeleteBottomSheet() {
        view.addSubview(deleteBottomSheetView)
        
        deleteBottomSheetView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        deleteBottomSheetView.isHidden = true
        
        deleteBottomSheetView.deleteContainer.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.dismissBottomSheet(animated: true, completion: {
                    print("tap delete")
                })
            })
            .disposed(by: disposeBag)
        
        deleteBottomSheetView.dimmedView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.dismissBottomSheet(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func presentBottomSheet() {
        deleteBottomSheetView.isHidden = false
        deleteBottomSheetView.dimmedView.alpha = 0.0
        deleteBottomSheetView.animateShow()
    }
    
    private func dismissBottomSheet(animated: Bool, completion: (() -> Void)?) {
        deleteBottomSheetView.animateHide {
            self.deleteBottomSheetView.isHidden = true
            completion?()
        }
    }
}


extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CalendarDateCell.description(), for: date, at: position) as? CalendarDateCell else { return FSCalendarCell() }
        
        let data = calendarData.first { DateFormatter.string(from: date, format: "yyyy-MM-dd") == $0.date }
        let dateStatus: CalendarCellState = {
            if Calendar.current.isDateInToday(date) {
                return .today
            } else if Calendar.current.isDate(date, inSameDayAs: self.viewModel.selectedDateRelay.value) {
                return .selected
            } else {
                return .normal
            }
        }()
        
        cell.configure(data: data ?? CalendarCellModel(date: "", cloverStatus: ""), dataStatus: dateStatus)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        tapDateRelay.accept(date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return .clear // 날짜 숫자를 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleDefaultColorFor date: Date) -> UIColor? {
        return .clear // 서브타이틀 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return .clear // 선택된 날짜 숫자를 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleSelectionColorFor date: Date) -> UIColor? {
        return .clear // 선택된 날짜의 서브타이틀 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        return .clear // 기본 테두리 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        return .clear // 선택된 날짜의 테두리 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return .clear // 기본 배경색 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .clear // 선택된 날짜의 배경색 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titlePlaceholderColorFor date: Date) -> UIColor? {
        return .clear // 이전/다음 달 날짜 숨김
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0 // 이벤트 숨김
    }
}
