import Foundation

struct HeadlineDTO: Decodable, Hashable {
  var status: String = ""
  var totalResults: Int = 0
  var articles: [ArticleDTO]
}

struct ArticleDTO: Decodable, Hashable {
  var title: String = ""
  var content: String?
  var url: String = ""
  var urlToImage: String?
  var publishedAt: String = ""
}
