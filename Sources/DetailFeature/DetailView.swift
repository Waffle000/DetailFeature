// The Swift Programming Language
// https://docs.swift.org/swift-book


import SwiftUI
import Core

public struct DetailView: View {
    @State var parameter : ConnectionStatus
    
    @EnvironmentObject private var viewModel: DetailViewModel
    
    @State var id : Int
    
    @State var name: String

    public init(parameter: ConnectionStatus, id: Int, name: String) {
//           _viewModel = StateObject(wrappedValue: viewModel)
           self.parameter = parameter
        self.id = id
        self.name = name
       }
    
   
    
    public var body: some View {
        
        NavigationStack {
            ZStack {
                Color(Color.black).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                if viewModel.isLoading {
                    ZStack(alignment:.center) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                    }.frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            HStack {
                                CacheAsyncImage(url: URL(string: viewModel.gameDetail?.background_image ?? "https://media.rawg.io/media/games/20a/20aa03a10cda45239fe22d035c0ebe64.jpg")!) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 100)
                                            .cornerRadius(16)
                                            .clipped()
                                    case .empty:
                                        VStack {
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                                .scaleEffect(1.5)
                                        }
                                        .frame(width: 100, height: 100)
                                        .background(Color.gray.opacity(0.3))
                                        .cornerRadius(16)
                                    default:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 120, height: 120)
                                            .cornerRadius(16)
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(viewModel.gameDetail?.name ?? "").font(.title3).fontWeight(.semibold).foregroundColor(.white)
                                    
                                                HStack {
                                                    ForEach(viewModel.gameDetail?.genres ?? [], id: \.id) { item in
                                                        Text(item.name).font(.callout).foregroundColor(Color.orange)
                                                    }
                                                }.padding(.top, 4)
                                                
                                     
                                    HStack {
                                        Image(systemName: "star").resizable().frame(width: 16, height: 16).foregroundColor(Color.yellow)
                                        Text(String(format: "%.2f", viewModel.gameDetail?.rating ?? 0.0)).font(.callout).foregroundColor(.white)
                                        Spacer()
                                        Button(action: {
                                            
                                            if !viewModel.isFavorite {
                                                viewModel.insertGameLocal(gameDetail: viewModel.gameDetail!)
                                            } else {
                                                viewModel.deleteGameLocal(game: viewModel.gameDetail!)
                                            }
                                        }) {
                                            Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                                        }
                                        
                                    }.padding(.top, 4)
                                }
                            }
                            
                            Text("Description").font(.headline).foregroundColor(.white).padding(.top, 16)
                            
                            Text(RemovedHtml(from: viewModel.gameDetail?.description ?? "")).font(.footnote).foregroundColor(.white).padding(.top, 8)
                        }.padding()
                    }
                    
                }
                
            }
        }.onAppear {
            viewModel.checkingFavorite(for: id)
            switch parameter {
            case .online:
                viewModel.loadGameDetail(for: id)
            case .offline:
                viewModel.loadGameDetailLocal(for: id)
            }
            
        }.toolbar {
            ToolbarItem(placement: .principal) {
                Text("Detail")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        
        
    }
}
