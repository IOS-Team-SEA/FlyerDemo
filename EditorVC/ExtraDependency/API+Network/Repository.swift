//
//  Repository.swift
//  HomeScreenPartyza
//
//  Created by HKBeast on 10/09/24.
//

import IOS_CommonEditor

class Repository{
    
    @Injected var apiServiceManager:ApiService
    
//    let articleURL = "https://gopartyza.com/wp-json/wp/v2/posts?_fields=id,title,link,featured_media"
    let articleURL = "https://prod-api.backendcore.com/webservices/Psma_PartyZa_Prod/getArticles.php?page=1&limit=10"
    
    
    init(){}
    
//    func fetchArticle()async throws->ArticleResponse?{
//      try await apiServiceManager.getArticleFromServer()
//    }
    
//    func fetchArticle(page : Int = 1)async throws->ArticleResponse?{
//        try await apiServiceManager.getArticleFromServer(page: page)
//    }
//    
//    func fetchMedia(for mediaID:Int)async throws->MediaURLResponse?{
//       try await apiServiceManager.getArticleMedia(id: mediaID)
//    }
//    
    func fetchCategories()async throws->[CategoryModel]?{
        try await apiServiceManager.getAllCategories()
    }
    
    
//    func fetchSearchResult(searchValue:String,filter:[String:String]? = nil,page:Int)async throws->TemplatesResponse?{
//    
//        try await apiServiceManager.getTemplatesFromServer(page: page, filters:filter,search: searchValue)
//    }
//    
//    func fetchTrendingtemplates(country:String)async throws->TrendingResponse?{
//    
//        try await apiServiceManager.getTrendingTemplates(country: country)
//      
//    }
//    
//    func increaseTemplateScore(templateId: Int, country: String) async throws{
//       
//        try await apiServiceManager.increaseTemplateScore(templateId: templateId, country: country)
//    }
//    
//    
//    func fetchFilters()async throws->FilterResponse?{
//    
//        try await apiServiceManager.getFilters( )
//    
//    }
//    
//    func fetchSearchResult(for filter:[String:String],page:Int)async throws->TemplatesResponse?{
//       
//        try await apiServiceManager.getTemplatesFromServer(page: page, filters: filter)
//      
//    }
    
//    func fetchServerTemplate(for endPoint)async throws ->ServerDBTemplate?{
//        try await NetworkManager.shared.fetchTemplateData(endPoint: endPoint)
//    }
    
}




