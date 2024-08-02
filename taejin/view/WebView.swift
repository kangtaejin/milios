import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
  let url: URL
  
  func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) {
    uiView.load(URLRequest(url: url))
  }
  
}

struct WebViewScreen: View {
    let article: Article

    var body: some View {
      if let url = URL(string: article.url ?? "") {
            WebView(url: url)
          .navigationTitle(article.title ?? "")
                .navigationBarTitleDisplayMode(.inline)
        } else {
            Text("Invalid URL")
        }
    }
}
