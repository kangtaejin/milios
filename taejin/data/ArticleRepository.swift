import CoreData
import Combine

class ArticleRepository {
  private let context: NSManagedObjectContext
  
  @Published var articles: [Article] = []
  
  init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  func save(articles: [ArticleDTO]) {
    for dto in articles {
      let article = Article(context: context)
      article.url = dto.url
      article.title = dto.title
      article.urlToImage = dto.urlToImage
      article.publishedAt = dto.publishedAt
    }
    
    do {
      try context.save()
    } catch {
    }
  }
  
  
  func fetchStoreArticles() -> [Article] {
    let request: NSFetchRequest<Article> = Article.fetchRequest()
    
    do {
      articles = try context.fetch(request)
      return articles
    } catch {
      return []
    }
  }
  
  func setRead(url: String) {
    if let index = articles.firstIndex(where: { $0.url == url }) {
      articles[index].read = 1
      do {
        try context.save()
      } catch {
      }
    }
  }
  
}
