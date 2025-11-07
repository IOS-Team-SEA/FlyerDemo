//
//  Container.swift
//  HomeScreenPartyza
//
//  Created by HKBeast on 10/09/24.
//

import Swinject

//let container = Container() {
//    // Register ViewModelA with a factory closure that accepts the id
//    $0.register(ViewModelA.self) { resolver, id in
//      
//        return ViewModelA(id: id)
//    }.inObjectScope(.transient)  // Use weak scope to ensure the instance is kept for reuse but allows cleanup
//
//    
//    $0.register(ApiService.self) { _ in ApiService() }
////    $0.register(URLGenerator.self) { _ in URLGenerator() }
//    
//    $0.register(Repository.self) { r in
//        Repository()
//    }
//    .inObjectScope(.transient)
//    
//    $0.register(ArticleViewModel.self) { r in
//        ArticleViewModel()
//    }
//    
//    $0.register(HomeScreenViewModel.self) { (r)  in
//        HomeScreenViewModel()
//        
//    }
//    .inObjectScope(.graph)
//    
//    $0.register(ArticleCellViewModel.self) { (r,article: ArticleADataModel) in ArticleCellViewModel(article: article, repository: r.resolve(Repository.self)!) }
//        .inObjectScope(.transient)
//    
//    $0.register(CategoriesViewModel.self) { (r) in
//        CategoriesViewModel()}
//            .inObjectScope(.transient)
//    
//    $0.register(CategoryViewModel.self) { (r,category: [String:String]) in
//        CategoryViewModel(filter: category)
//    }
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
   
    

