//
//  ComicHostingController.swift
//  Comix
//
//  Created by Scott Lewis on 4/4/22.
//

import UIKit
import SwiftUI
import Foundation

class ComicDetailHostingController: UIHostingController<DetailSwiftUIView> {
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: DetailSwiftUIView())
    }
}

struct DetailSwiftUIView: View {
    var comic: MarvelComicResult?
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                AsyncImage(url: comic?.thumbnail.imageURL(size: .portraitIncredible)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width - 40)
                } placeholder: {
                    ProgressView()
                }
                Spacer()
                Text("Title").font(.title)
                Text(comic?.title ?? "No comic set").font(.subheadline)
                Spacer()
                if let characters = comic?.characters.items, characters.count > 0 {
                    Text("Characters").font(.title)
                    ForEach(characters, id: \.self) { character in
                        Text(character.name)
                            .font(.subheadline)
                    }
                }
                Spacer()
                if let creators = comic?.creators.items, creators.count > 0 {
                    Text("Creators").font(.title)
                    ForEach(creators, id: \.self) { creator in
                        Text("\(creator.name): \(creator.role.capitalized)")
                            .font(.subheadline)
                    }
                }
                Spacer()
                if let textObjects = comic?.textObjects, textObjects.count > 0 {
                    Text("Info").font(.title)
                    ForEach(textObjects, id: \.self) {textObj in
                        Text(textObj.text)
                    }
                }
                
            }
            .frame(width: UIScreen.main.bounds.width - 40)
        }
        
    }
}
