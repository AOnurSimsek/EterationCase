//
//  MainTabbarController.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 21.07.2025.
//

import UIKit

final class MainTabbarController: UITabBarController {
    override func loadView() {
        super.loadView()
        setTabbarUI()
        setTabItems()
        addNotificationObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadCartBadge()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(cartChanged),
                                               name: .cartChange, object: nil)
    }

    @objc private func cartChanged() {
        reloadCartBadge()
    }
    
    private func setTabbarUI() {
        tabBar.backgroundColor = .backgroundWhite
        tabBar.tintColor = .textBlack
        tabBar.unselectedItemTintColor = .textBlack
        
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 10,
                                           height: 0)
        tabBar.layer.shadowRadius = 10
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.masksToBounds = false
    }
    
    private func setTabItems() {
        let productService: ProductService = ProductServiceImp()
        let coreDataService: CoreDataManager = CoreDataManager.shared
        
        let homeViewModel: HomeViewModelImpl = .init(service: productService,
                                                     coreDataService: coreDataService)
        let homeController: HomeViewController = .init(viewModel: homeViewModel)
        homeViewModel.setView(homeController)
        let homeNavigationController: UINavigationController = .init(rootViewController: homeController)
        homeNavigationController.tabBarItem = .init(title: nil,
                                                    image: .iconHomeOutline,
                                                    selectedImage: .iconHomeOutline)
        homeNavigationController.setNavigationBarHidden(true, animated: false)
        homeNavigationController.tabBarItem.imageInsets = .init(top: 0, left: 0,
                                                                bottom: -10, right: 0)
        
        let cartViewModel: CartViewModelImpl = CartViewModelImpl(coreDataService: coreDataService,
                                                                 productService: productService)
        let cartController: CartViewController = .init(viewModel: cartViewModel)
        cartViewModel.setView(cartController)
        let cartNavigationController: UINavigationController = .init(rootViewController: cartController)
        cartNavigationController.tabBarItem = .init(title: nil,
                                                    image: .iconBasketOutline,
                                                    selectedImage: .iconBasketOutline)
        cartNavigationController.setNavigationBarHidden(true, animated: false)
        cartNavigationController.tabBarItem.imageInsets = .init(top: 0, left: 0,
                                                                bottom: -10, right: 0)
        
        let favoritesViewModel: FavoritesViewModelImpl = FavoritesViewModelImpl(service: productService,
                                                                                coreDataService: coreDataService)
        let favoritesViewController: FavoritesViewController = .init(viewModel: favoritesViewModel)
        favoritesViewModel.setView(favoritesViewController)
        let favoritesNavigationController: UINavigationController = .init(rootViewController: favoritesViewController)
        favoritesNavigationController.tabBarItem = .init(title: nil,
                                                         image: .iconStarOutline,
                                                         selectedImage: .iconStarOutline)
        favoritesNavigationController.setNavigationBarHidden(true, animated: false)
        favoritesNavigationController.tabBarItem.imageInsets = .init(top: 0, left: 0,
                                                                     bottom: -10, right: 0)
        
        let profileViewController: ProfileViewController = .init()
        profileViewController.tabBarItem = .init(title: nil,
                                                 image: .iconPerson,
                                                 selectedImage: .iconPerson)
        profileViewController.tabBarItem.imageInsets = .init(top: 0, left: 0,
                                                             bottom: -10, right: 0)
        
        viewControllers = [homeNavigationController,
                           cartNavigationController,
                           favoritesNavigationController,
                           profileViewController]
    }
    
    private func reloadCartBadge() {
        guard let tabBarItems = tabBar.items,
              tabBarItems.count > 1
        else { return }
        
        let cartProducts = CoreDataManager.shared.getCartProducts()
        let count = cartProducts.reduce(0) { $0 + $1.quantity }
        
        let cartTabBarItem = tabBarItems[1]
        
        if count > 0 {
            cartTabBarItem.badgeColor = .red
            cartTabBarItem.badgeValue = String(count)
        } else {
            cartTabBarItem.badgeValue = nil
        }
        
    }
    
}
