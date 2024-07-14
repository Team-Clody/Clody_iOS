import UIKit
import SnapKit
import Then

final class MyPageViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = MyPageViewModel()
    
    // MARK: - UI Components
     
    private let rootView = MyPageView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setDelegate()
    }
}

// MARK: - Private Extension

private extension MyPageViewController {
    
    func setStyle() {
        view.backgroundColor = .white
    }

    func setDelegate() {
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource

extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyPageViewModel.Setting.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MyPageTableViewCell.identifier,
            for: indexPath
        ) as! MyPageTableViewCell
        
        let setting = MyPageViewModel.Setting.allCases[indexPath.row]
        cell.configure(with: setting, at: indexPath)

        if indexPath.row == 0 || indexPath.row == 3 {
            cell.showSeparatorLine(true)
        } else {
            cell.showSeparatorLine(false)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MyPageViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 62
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = MyPageViewModel.Setting.allCases[indexPath.row]
        if setting == .profile {
            let accountViewController = AccountViewController()
            self.navigationController?.pushViewController(accountViewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}




#if DEBUG

import SwiftUI

struct MyPageViewController_Previews: PreviewProvider {

static var previews: some View {

MyPageViewController().toPreview()

}

}

extension UIViewController {

private struct Preview: UIViewControllerRepresentable {

let viewController: UIViewController

func makeUIViewController(context: Context) -> UIViewController {

return viewController

}

func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

}

func toPreview() -> some View {

Preview(viewController: self)

}

}

#endif
