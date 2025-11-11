//
//  Injection.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 17/01/25.
//
import Swinject
import IOS_CommonEditor
import UIKit

final class Injection {
    static var shared = Injection()

    private var _appLevelContainer: Container?
    private var _appLevelResolver: Resolver?
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
    
    var appLevelResolver: Resolver {
        if let resolver = _appLevelResolver {
            return resolver
        }
        let resolver = appLevelContainer.synchronize()
        _appLevelResolver = resolver
        return resolver
    }

    private init() {}

    // Build App-level container (Global dependencies)
    private func buildAppLevelContainer() -> Container {
        let container = Container()

        container.register(AppRouter.self) { resolver in

            MainActor.assumeIsolated {
                return AppRouter()
                }
           
        }.inObjectScope(.transient)

        container.register(EditorVM.self) { (_, templateId: Int, thumbImage: UIImage) in
            EditorVM(templateId: templateId, thumbImage: thumbImage)
        }
        .inObjectScope(.transient)
        
        container.register(ApiService.self) { _ in ApiService() }
            .inObjectScope(.transient)
//        container.register(RSVPAPIStrore.self) { _ in RSVPAPIStrore() }
//            .inObjectScope(.container)
        
        container.register(Repository.self) { r in
            Repository()
        }
        .inObjectScope(.transient)
        
        container.register(IAPViewModel.self) { resolver in

            MainActor.assumeIsolated {
                return IAPViewModel()
                }
           
        }.inObjectScope(.container)


        container.register(Repository.self) { r in
            Repository()
        }
        .inObjectScope(.container)
            

        container.register(RSVPNetworkManager.self) { _ in RSVPNetworkManager() }
            .inObjectScope(.container)

        container.register(RSVPRepository.self) { _ in RSVPRepository() }
            .inObjectScope(.container)
        
        container.register(IOS_CommonEditor.ShaderLibrary.self) { _ in
//            MainActor.assumeIsolated {
            IOS_CommonEditor.ShaderLibrary()
//            }
        }.inObjectScope(.container)
        
        container.register(PipelineLibrary.self) { _ in
            PipelineLibrary()
            
        }.inObjectScope(.container)
                
        container.register(MVertexDescriptorLibrary.self) { _ in
                MVertexDescriptorLibrary()
            
        }.inObjectScope(.container)
        
        
       
        _appLevelResolver = container.synchronize()
        return container
    }

}

// MARK: - Extension for On-Demand Resolution of ViewModels by Type and ID using Enum
extension Injection {
    
    func inject<T: AnyObject>(type:T.Type) -> T? {
       return  appLevelResolver.resolve(type)
    }
    // Generic method to resolve ViewModel dynamically based on type, ID, and ContainerType
    func inject<T: AnyObject>(id: String, type: T.Type , argument: Any? = nil ) -> T? {
       
       
        // Check if the ViewModel is already cached as a weak reference
        if let weakViewModel = viewModels[id] as? Weak<T>, let viewModel = weakViewModel.value {
            return viewModel  // Return the cached ViewModel if it exists
        } else {
            // Resolve a new instance from the container with the argument (id)
           
            
            
             if let argument1 = argument as? Int, let viewModel = appLevelResolver.resolve(T.self, argument: argument1 ) {
                 viewModels[id] = Weak(value: viewModel)
                 return viewModel

             }
           else if let argument1 = argument, let viewModel = appLevelResolver.resolve(T.self, argument: argument1 ) {
                viewModels[id] = Weak(value: viewModel)
                return viewModel

            }
            else if let viewModel = appLevelResolver.resolve(T.self) {
                // Cache the newly resolved ViewModel using weak reference
                viewModels[id] = Weak(value: viewModel)
                return viewModel
            }
            else if let argument1 = argument as? [String: String]? , let viewModel = appLevelResolver.resolve(T.self, argument: argument1 ) {
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
           
             if let viewModel = appLevelResolver.resolve(T.self, argument: dictArgument ) {
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
            guard let resolved = Injection.shared.appLevelResolver.resolve(Dependency.self) else {
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
   

extension Injection: DependencyResolverProtocol {
    func resolve<T>(_ type: T.Type) -> T? {
        appLevelResolver.resolve(type)
    }

    func resolve<T, Arg>(_ type: T.Type, argument: Arg) -> T? {
        appLevelResolver.resolve(type, argument: argument)
    }

    func resolve<T>(id: String, type: T.Type, argument: Any?) -> T? {
        viewModels[id] as? T
    }

    func register<T>(_ instance: T, for type: T.Type) {
        viewModels[String(describing: type)] = instance
    }
}
