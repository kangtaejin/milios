import Foundation
import Combine

import Foundation

final class ArticleViewModel: ObservableObject {
  
  @Published var arrArticle: [Article] = []
  private var cancellables = Set<AnyCancellable>()
  
  private let repository: ArticleRepository = ArticleRepository(context: PersistenceController.shared.container.viewContext)
  
  func fetchArticle (){
    ApiService.fetchArticle().sink(
      receiveCompletion: { completion in
        switch completion {
        case .finished:
          break
        case .failure(_):
          self.arrArticle = self.repository.fetchStoreArticles()
         break
        }
      },
      receiveValue: { headlines in
        let storedArticles = self.repository.fetchStoreArticles()
        let storedArticleDict = Dictionary(uniqueKeysWithValues: storedArticles.map { ($0.url, $0) })
        var updatedArticles: [ArticleDTO] = []
        for article in headlines.articles {
          if storedArticleDict[article.url] == nil {
            updatedArticles.append(article)
          }
        }
        self.repository.save(articles: updatedArticles)
        self.arrArticle = self.repository.fetchStoreArticles()
      })
    .store(in: &cancellables)
  }
  
  func setReadUrl(url: String){
    repository.setRead(url: url)
    self.arrArticle = repository.fetchStoreArticles()
  }
  
}
