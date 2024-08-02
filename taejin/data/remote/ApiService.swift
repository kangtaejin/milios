
import Foundation
import Combine
import Alamofire

enum ApiService {
  
  static func fetchArticle() -> AnyPublisher<HeadlineDTO, Error> {
    let params = ["country" : "kr", "apiKey" : "3f2cd89f481e4fbc844d11cd800e714a"];
    return AF.request("https://newsapi.org/v2/top-headlines", parameters: params)
      .publishDecodable(type: HeadlineDTO.self)
      .value()
      .mapError{(aFError:AFError) in
        return aFError as Error
      }
      .eraseToAnyPublisher()
  }
  
}
