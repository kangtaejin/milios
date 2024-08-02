import SwiftUI
import CoreData

struct ContentView: View {
  
  @StateObject private var viewModel = ArticleViewModel()
  @Environment(\.managedObjectContext) private var viewContext
  @State private var selectedArticle: Article?

  var body: some View {
    NavigationStack {
      GeometryReader { geometry in
        let isPortrait = geometry.size.width < geometry.size.height
        ScrollView {
          LazyVGrid(columns: Array(repeating: .init(.flexible()), count: isPortrait ? 1 : 2), spacing: 16) {
            ForEach(viewModel.arrArticle, id: \.self) { article in
              Button(action: {
                viewModel.setReadUrl(url: article.url ?? "")
                selectedArticle = article
              }) {
                VStack {
                  if let urlToImage = article.urlToImage, !urlToImage.isEmpty {
                    AsyncImage(url: URL(string: urlToImage)) { image in
                      image.image?
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 120)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(8)
                  }
                  VStack(alignment: .leading) {
                    Text(article.title ?? "")
                      .font(.headline)
                      .foregroundColor(article.read == 1 ? .red : .primary)
                      .lineLimit(1)
                    HStack {
                      Text(article.publishedAt ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                  }
                  .padding()
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 5)
              }
              .buttonStyle(PlainButtonStyle())
              .background(
                NavigationLink(
                  destination: WebView(url: URL(string: article.url ?? "")!)
                    .navigationTitle(article.title ?? "")
                    .navigationBarTitleDisplayMode(.inline),
                  tag: article,
                  selection: $selectedArticle
                ) {
                  EmptyView()
                }
              )
              .padding([.leading, .trailing], 8)
            }
          }
          .padding()
        }
      }
    }
    .onAppear {
      viewModel.fetchArticle()
    }
  }
}

#Preview {
  ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
