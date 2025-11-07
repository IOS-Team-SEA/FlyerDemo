//
//  Injection.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 17/01/25.
//
import Swinject
import IOS_CommonEditor
//import IOS_LoginAuthSPM

//final class Injection{
//    
//    static var shared = Injection()
//    
//    var container: Container{
//        get{
//            if _container == nil{
//                _container = buildContainer()
//            }
//            return _container!
//        }
//        
//        set{
//            _container = newValue
//        }
//    }
//    
//    private var _container: Container?
//    
//    private func buildContainer() -> Container{
//        let container = Container()
//        
//        container.register(AnalyticsLogger.self) { _ in
//            AnalyticsLogger(firebaseLogger: FirebaseAnalyticsManager(), inHouseLogger: InHouseLoggerManager())
//        }
//        
//        
//        return container
//    }
//}



final class Injection {
    static var shared = Injection()

    private var _appLevelContainer: Container?
    private var _homeScreenContainer: Container?
//    private var _editorContainer: Container?

    // Dictionary to store weak references of ViewModels by ID
    private var viewModels: [String: Any] = [:]

    var appLevelContainer: Container {
        if _appLevelContainer == nil {
            _appLevelContainer = buildAppLevelContainer()
        }
        return _appLevelContainer!
    }

//    var homeScreenContainer: Container {
//        if _homeScreenContainer == nil {
//            _homeScreenContainer = buildHomeScreenContainer()
//        }
//        return _homeScreenContainer!
//    }

//    var editorContainer: Container {
//        if _editorContainer == nil {
//            _editorContainer = buildEditorContainer()
//        }
//        return _editorContainer!
//    }

    private init() {}

    // Build App-level container (Global dependencies)
    private func buildAppLevelContainer() -> Container {
        let container = Container()

        container.register(AppRouter.self) { resolver in

            MainActor.assumeIsolated {
                return AppRouter()
                }
           
        }.inObjectScope(.transient)
        
//        container.register(ThumbnailDataSource.self) { resolver in
//
//            MainActor.assumeIsolated {
//                return ThumbnailDataSource()
//                }
//           
//        }.inObjectScope(.container)
        
//        container.register(DBMigrationOldToNewV3.self) { resolver in
//
//            MainActor.assumeIsolated {
//                return DBMigrationOldToNewV3()
//                }
//           
//        }.inObjectScope(.container)
        
        
//        container.register(TemplateRepository.self) { resolver in
//
//            MainActor.assumeIsolated {
//                return TemplateRepository()
//                }
//           
//        }.inObjectScope(.container)
//        
//        // Remote Config
//        container.register(RemoteConfigManager.self) { _ in
//            return RemoteConfigManager()
//        }
        
        
        container.register(ApiService.self) { _ in ApiService() }
            .inObjectScope(.transient)
//        container.register(RSVPAPIStrore.self) { _ in RSVPAPIStrore() }
//            .inObjectScope(.container)
        
        container.register(Repository.self) { r in
            Repository()
        }
        .inObjectScope(.transient)
        
//        container.register(AnalyticsLogger.self) { _ in
//            AnalyticsLogger(firebaseLogger: FirebaseAnalyticsManager(), inHouseLogger: InHouseLoggerManager())
//        }.inObjectScope(.container)
//        
//        container.register(TrendingVM.self) { resolver in
//
//            MainActor.assumeIsolated {
//                return TrendingVM()
//                }
           
//        }.inObjectScope(.transient)
        container.register(IAPViewModel.self) { resolver in

            MainActor.assumeIsolated {
                return IAPViewModel()
                }
           
        }.inObjectScope(.container)

//        container.register(PremiumPurchaseProviding.self) { _ in
//            MainActor.assumeIsolated {
//                return StoreKitPurchaseProvider(plans: PremiumPlanCatalog.entitlementPlans)
//            }
//        }.inObjectScope(.container)
//
//        container.register(PremiumAnalyticsTracking.self) { resolver in
//            MainActor.assumeIsolated {
//                let analytics = resolver.resolve(AnalyticsLogger.self)!
//                return PremiumAnalyticsBridge(analytics: analytics)
//            }
//        }.inObjectScope(.container)
//
//        container.register(PremiumExperimentProviding.self) { resolver in
//            MainActor.assumeIsolated {
//                let remoteConfig = resolver.resolve(RemoteConfigManager.self)!
//                return PremiumRemoteExperimentProvider(remoteConfigManager: remoteConfig)
//            }
//        }.inObjectScope(.container)

//        container.register(PremiumEligibilityProviding.self) { _ in
//            MainActor.assumeIsolated {
//                return DefaultPremiumEligibilityProvider()
//            }
//        }.inObjectScope(.container)
//
//        container.register(PremiumEntitlementStore.self) { _ in
//            MainActor.assumeIsolated {
//                return DefaultPremiumEntitlementStore(key: "premium.entitlement")
//            }
//        }.inObjectScope(.container)

//        container.register(PremiumEngine.self) { resolver in
//            MainActor.assumeIsolated {
//                let purchaseProvider = resolver.resolve(PremiumPurchaseProviding.self)!
//                let analytics = resolver.resolve(PremiumAnalyticsTracking.self)!
//                let experiments = resolver.resolve(PremiumExperimentProviding.self)!
//                let eligibility = resolver.resolve(PremiumEligibilityProviding.self)!
//                let entitlementStore = resolver.resolve(PremiumEntitlementStore.self)!
//
//                let dependencies = PremiumEngine.Dependencies(purchaseProvider: purchaseProvider,
//                                                              analytics: analytics,
//                                                              eligibility: eligibility,
//                                                              entitlementStore: entitlementStore)
//                let engine = PremiumEngine(plans: PremiumPlanCatalog.entitlementPlans,
//                                           dependencies: dependencies)
//                return engine
//            }
//        }.inObjectScope(.container)
//
//        container.register(PremiumViewModel.self) { resolver in
//            MainActor.assumeIsolated {
//                let engine = resolver.resolve(PremiumEngine.self)!
//                let experiments = resolver.resolve(PremiumExperimentProviding.self)!
//                let remoteConfig = resolver.resolve(RemoteConfigManager.self)!
//                let configuration = PremiumConfigurationFactory.makeDefaultConfiguration(remoteConfig: remoteConfig)
//                return PremiumViewModel(engine: engine,
//                                        configuration: configuration,
//                                        experiments: experiments)
//            }
//        }.inObjectScope(.transient)

//        container.register(PremiumAccess.self) { resolver in
//            MainActor.assumeIsolated {
//                let engine = resolver.resolve(PremiumEngine.self)!
//                let access = PremiumAccess(engine: engine)
//                access.attach(to: UIStateManager.shared)
//                return access
//            }
//        }.inObjectScope(.container)
//        
//        container.register(FilterResponseVM.self) { resolver in
//
//            MainActor.assumeIsolated {
//                    return FilterResponseVM()
//                }
//           
//        }.inObjectScope(.transient)
//        
//        container.register(SearchableVM.self) { resolver in
//
//            MainActor.assumeIsolated {
//                    return SearchableVM()
//                }
//           
//        }.inObjectScope(.transient)
//        
//        container.register(UserDesignVM.self) { resolver in
//
//            MainActor.assumeIsolated {
//                    return UserDesignVM()
//                }
//           
//        }.inObjectScope(.transient)
        
//        container.register(ArticlesVM.self) { resolver in
//
//            MainActor.assumeIsolated {
//                    return ArticlesVM()
//                }
//           
//        }.inObjectScope(.transient)
        
       
        
//        container.register(SearchableVM.self) { resolver in
//
//            MainActor.assumeIsolated {
//                    return SearchableVM()
//                }
//           
//        }.inObjectScope(.transient)
//        
//        
//        container.register(AllCategoriesVM.self) { (resolver) in
//            MainActor.assumeIsolated {
//                return  AllCategoriesVM()
//            }
//        }.inObjectScope(.transient)
//        container.register(ServerCategoryVM.self) { (r,category: [String:String]) in
//            MainActor.assumeIsolated {
//                return  ServerCategoryVM(filter: category)
//            }
//        }.inObjectScope(.transient)
//        
//       
//        
//        container.register(HomeVM.self) { (resolver) in
//            MainActor.assumeIsolated {
//                return  HomeVM()
//            }
//        }.inObjectScope(.transient)
//        
//        container.register(LoaderViewModel.self) { (resolver) in
//            MainActor.assumeIsolated {
//                return  LoaderViewModel()
//            }
//        }.inObjectScope(.transient)
        
//        container.register(DetailResultViewModel.self) { (resolver, argument: [String: String]?) in
//            MainActor.assumeIsolated {
//                return  DetailResultViewModel(initialCategory: argument)
//            }
//        }.inObjectScope(.transient)
           
    //    $0.register(URLGenerator.self) { _ in URLGenerator() }
        
        container.register(Repository.self) { r in
            Repository()
        }
        .inObjectScope(.container)
            
//        container.register(EditorViewManager.self) { (r) in
//            EditorViewManager()
//        }
//        
//        container.register(LoginViewModel.self) { r in
//            MainActor.assumeIsolated {
//                LoginViewModel()
//            }
//        }.inObjectScope(.transient)
        
//        container.register(UserProfileVM.self) { _ in
//            MainActor.assumeIsolated {
//                return UserProfileVM()
//            }
//        }
//        .inObjectScope(.container)
//        
//        container.register(RSVPAPIStrore.self) { _ in RSVPAPIStrore() }
//            .inObjectScope(.container)
        
        container.register(RSVPNetworkManager.self) { _ in RSVPNetworkManager() }
            .inObjectScope(.container)
//            .initCompleted { r, s in
//                s.userProfileVM = r.resolve(UserProfileVM.self)!
//            }
        
        container.register(RSVPRepository.self) { _ in RSVPRepository() }
            .inObjectScope(.container)
        
//        container.register(AuthManager.self) { _ in AuthManager() }
//            .inObjectScope(.container)
//        
//        container.register(MetalViewHandler.self) { _ in
//            MainActor.assumeIsolated {
//                MetalViewHandler()
//            }
//        }
//        .inObjectScope(.transient)
        
        
        
//        container.register(MetalEngine.self) { _ in
//                MetalEngine()
//        }
//        .inObjectScope(.transient)
        
     
        
//        container.register(EditorLauncherViewModel.self) { _ in
//            MainActor.assumeIsolated {
//                EditorLauncherViewModel()
//            }
//        }.inObjectScope(.container)
        
        // METAL SHADERS
        
        container.register(ShaderLibrary.self) { _ in
//            MainActor.assumeIsolated {
                ShaderLibrary()
//            }
        }.inObjectScope(.container)
        
        container.register(PipelineLibrary.self) { _ in
            PipelineLibrary()
            
        }.inObjectScope(.container)
        
        container.register(MVertexDescriptorLibrary.self) { _ in
                MVertexDescriptorLibrary()
            
        }.inObjectScope(.container)
        
        
       
        
        return container
    }

}

// MARK: - Extension for On-Demand Resolution of ViewModels by Type and ID using Enum
extension Injection {
    
    func inject<T: AnyObject>(type:T.Type) -> T? {
       return  appLevelContainer.resolve(type)
    }
    // Generic method to resolve ViewModel dynamically based on type, ID, and ContainerType
    func inject<T: AnyObject>(id: String, type: T.Type , argument: Any? = nil ) -> T? {
       
       
        // Check if the ViewModel is already cached as a weak reference
        if let weakViewModel = viewModels[id] as? Weak<T>, let viewModel = weakViewModel.value {
            return viewModel  // Return the cached ViewModel if it exists
        } else {
            // Resolve a new instance from the container with the argument (id)
           
            
            
             if let argument1 = argument as? Int, let viewModel = appLevelContainer.resolve(T.self, argument: argument1 ) {
                 viewModels[id] = Weak(value: viewModel)
                 return viewModel

             }
           else if let argument1 = argument, let viewModel = appLevelContainer.resolve(T.self, argument: argument1 ) {
                viewModels[id] = Weak(value: viewModel)
                return viewModel

            }
            else if let viewModel = appLevelContainer.resolve(T.self) {
                // Cache the newly resolved ViewModel using weak reference
                viewModels[id] = Weak(value: viewModel)
                return viewModel
            }
            else if let argument1 = argument as? [String: String]? , let viewModel = appLevelContainer.resolve(T.self, argument: argument1 ) {
                viewModels[id] = Weak(value: viewModel)
                return viewModel

            }
            return nil  // Return nil if the ViewModel could not be resolved
        }
    }
    func inject<T: AnyObject>(id: String, type: T.Type , dictArgument: [String:String] ) -> T? {
       
       
        // Check if the ViewModel is already cached as a weak reference
        if let weakViewModel = viewModels[id] as? Weak<T>, let viewModel = weakViewModel.value {
            return viewModel  // Return the cached ViewModel if it exists
        } else {
            // Resolve a new instance from the container with the argument (id)
           
             if let viewModel = appLevelContainer.resolve(T.self, argument: dictArgument ) {
                viewModels[id] = Weak(value: viewModel)
                return viewModel

            }
            
            return nil  // Return nil if the ViewModel could not be resolved
        }
    }
    
    func remove(id: String) {
        viewModels.removeValue(forKey: id)
    }
    
    
    
//    func injectSearchVieModel(id:String,type:SearchResultViewModel , searchKey:String) -> SearchResultViewModel? {
//        // Check if the ViewModel is already cached as a weak reference
//        if let weakViewModel = viewModels[id] as? Weak<T>, let viewModel = weakViewModel.value {
//            return viewModel  // Return the cached ViewModel if it exists
//        } else {
//            
//        }
//    }
//    func injectSearchVieModel(type:SearchResultViewModel.Type , searchValue: String, filters: [String: String]?,commonFilter:[String:String]? = nil) -> SearchResultViewModel? {
//        // Check if the ViewModel is already cached as a weak reference
////        if let weakViewModel = viewModels[searchValue] as? Weak<SearchResultViewModel>, let viewModel = weakViewModel.value {
////            return viewModel  // Return the cached ViewModel if it exists
////        } else {
//            if let viewModel = appLevelContainer.resolve(SearchResultViewModel.self, arguments: searchValue, filters, commonFilter) {
//                viewModels[searchValue] = Weak(value: viewModel)
//                return viewModel
//            }
////        }
//        return nil
//    }
    
//    func injectSearchVieModel(id:String,type:SearchResultViewModel.Type , filters: [String: String],commonFilter:[String:String]? = nil) -> SearchResultViewModel? {
//        // Check if the ViewModel is already cached as a weak reference
////        if let weakViewModel = viewModels[id] as? Weak<SearchResultViewModel>, let viewModel = weakViewModel.value {
////            return viewModel  // Return the cached ViewModel if it exists
////        } else {
//            if let viewModel = appLevelContainer.resolve(SearchResultViewModel.self, arguments: filters, commonFilter) {
////                viewModels[id] = Weak(value: viewModel)
//                return viewModel
//            }
////        }
//        return nil
//    }
}



@propertyWrapper
struct Injected<Dependency: AnyObject> {  // Ensure Dependency is a class
    let wrappedValue: Dependency

    init(key: String? = nil) {
        if let key = key {
            guard let resolved = Injection.shared.inject(id: key, type: Dependency.self) else {
                fatalError("Dependency \(Dependency.self) not found for key: \(key)")
            }
            self.wrappedValue = resolved
        } else {
            guard let resolved = Injection.shared.appLevelContainer.resolve(Dependency.self) else {
                fatalError("Dependency \(Dependency.self) not found")
            }
            self.wrappedValue = resolved
        }
    }
}


//let container2 = Container() {
//    // Register ViewModelA with a factory closure that accepts the id
//    $0.register(ViewModelA.self) { resolver, id in
//      
//        return ViewModelA(id: id)
//    }.inObjectScope(.transient)  // Use weak scope to ensure the instance is kept for reuse but allows cleanup
//
//   
//    
//    
////    $0.register(ApiService.self) { _ in ApiService() }
////    $0.register(URLGenerator.self) { _ in URLGenerator() }
//    
////    $0.register(Repository.self) { r in
////        Repository(apiServiceManager: r.resolve(ApiService.self)!)
////    }
////    .inObjectScope(.transient)
//    
//   
//    
////    $0.register(HomeScreenViewModel.self) { (r)  in
////        HomeScreenViewModel(repository: r.resolve(Repository.self)!)
////        
////    }
////    .inObjectScope(.graph)
//    
//    $0.register(ArticleCellViewModel.self) { (r,article: ArticleADataModel) in ArticleCellViewModel(article: article, repository: r.resolve(Repository.self)!) }
//        .inObjectScope(.transient)
//    
//    $0.register(CategoriesViewModel.self) { (r) in
//        CategoriesViewModel(repository:r.resolve(Repository.self)!)}
//            .inObjectScope(.transient)
//    
//    $0.register(CategoryViewModel.self) { (r,category: [String:String]) in CategoryViewModel(repository:r.resolve(Repository.self)!,filter: category)}
//            .inObjectScope(.transient)
//    
//    
//    $0.register(TrendingViewModel.self) { (r) in TrendingViewModel(repository:r.resolve(Repository.self)!)}
//            .inObjectScope(.transient)
//    
//    
//    
//    $0.register(FilterViewModel.self) { r in FilterViewModel(repository:r.resolve(Repository.self)!)}
//        .inObjectScope(.transient)
//         
//    $0.register(SearchResultViewModel.self) { (r,filter: [String:String])  in
//        SearchResultViewModel(filters: filter, repository: r.resolve(Repository.self)!)
//    }
//    .inObjectScope(.transient)
//    
//    $0.register(SearchResultViewModel.self) { (r,filter: String)  in
//        SearchResultViewModel(searchValue: filter, filters: nil, repository: r.resolve(Repository.self)!)
//    }
//    .inObjectScope(.transient)
//    
//    $0.register(EditorViewManager.self) { (r, delegate: ViewController) in
//        EditorViewManager(delegate: delegate, repository: r.resolve(Repository.self)!)
//    }
//    
//    }
   
