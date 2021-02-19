import UIKit
import SideMenu

class HouseViewController: UIViewController, MenuControllerDelegate {

    private var sideMenu: SideMenuNavigationController?
    private let childController = SideMenuController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleImage()
        self.setInitialProperties()
    }
    
    @IBAction func didTapSlider() {
        present(sideMenu!, animated: true)
    }
    
    func didSelectMenu(named: String) {
        sideMenu?.dismiss(animated: true, completion: { [weak self] in
            self!.childController.DidSelectMenu(menuItem: named, viewController: self!)
        })
    }
    
    private func setInitialProperties() {
        let menu =  MenuController()
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        menu.delegate = self
        sideMenu?.leftSide = true
        sideMenu?.presentationStyle = .menuSlideIn
        sideMenu?.navigationBar.topItem?.title =  NSLocalizedString("Lbl_Menu_Assets", comment: "")
        sideMenu?.navigationBar.barTintColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        self.childController.AddChildControllers(viewController: self)
    }
}


