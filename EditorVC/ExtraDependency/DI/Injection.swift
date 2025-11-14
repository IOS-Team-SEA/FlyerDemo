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

        container.register(EditorVM.self) { (_, templateInfo: TemplateInfo, thumbImage: UIImage) in
            EditorVM(templateInfo: templateInfo, thumbImage: thumbImage)
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
    
    func inject<T: AnyObject>(id: String, type: T.Type , argumentA: Any? = nil, argumentB: Any? = nil ) -> T? {
       
       
        // Check if the ViewModel is already cached as a weak reference
        if let weakViewModel = viewModels[id] as? Weak<T>, let viewModel = weakViewModel.value {
            return viewModel  // Return the cached ViewModel if it exists
        } else {
            // Resolve a new instance from the container with the argument (id)
            if let templateInfo = argumentA as? TemplateInfo,
               let thumbImage = argumentB as? UIImage,
               let viewModel = appLevelResolver.resolve(T.self, arguments: templateInfo, thumbImage) {
                viewModels[id] = Weak(value: viewModel)
                return viewModel
            }
            
            if let argA = argumentA {
                if let intArg = argA as? Int,
                   let viewModel = appLevelResolver.resolve(T.self, argument: intArg) {
                    viewModels[id] = Weak(value: viewModel)
                    return viewModel
                } else if let dictArg = argA as? [String: String],
                          let viewModel = appLevelResolver.resolve(T.self, argument: dictArg) {
                    viewModels[id] = Weak(value: viewModel)
                    return viewModel
                } else if let viewModel = appLevelResolver.resolve(T.self, argument: argA) {
                    viewModels[id] = Weak(value: viewModel)
                    return viewModel
                }
            }
            
            if let viewModel = appLevelResolver.resolve(T.self) {
                viewModels[id] = Weak(value: viewModel)
                return viewModel
            }
            return nil  // Return nil if the ViewModel could not be resolved
        }
    }
    
    func remove(id: String) {
        viewModels.removeValue(forKey: id)
    }
    
 
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
