//
//  Coverflow Carousel.swift
//  Animation
//
//  Created by LEE on 3/30/25.
//

import SwiftUI


struct Coverflow_Carousel: View {
    
    @State private var activeId: UUID?
    
    var images: [Model] = (1...10).map {
        .init(image: "dummy\($0)")
    }

    
    var body: some View {
        VStack {
            Spacer().frame(height: 50)
            
            Coverflow_Carousel_List(config: .init(), data: images, selectedId: $activeId) {
                item in
                Image(item.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(height: 170)

            
            Spacer()
                        
        }
        .background(.black)
    }
    
    struct Model: Identifiable {
        
        var id = UUID()
        var image: String
        
    }

}


struct Coverflow_Carousel_List<Content: View, Data: RandomAccessCollection>: View where Data.Element: Identifiable {

    var config: Config
    var data: Data
    
    @Binding var selectedId: UUID?
    @ViewBuilder var content: (Data.Element) -> Content
        
    var body: some View {
        GeometryReader {
            let size = $0.size
            ScrollView(.horizontal) {
                HStack(spacing: config.spacing) {
                    ForEach(data) { item in
                        itemView(item)
                    }
                }
                .scrollTargetLayout()
            }
            .safeAreaPadding(.horizontal, (size.width - config.cardWidth) / 2)
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .scrollIndicators(.hidden)
            .scrollPosition(id: $selectedId)
        }

    }
    
    @ViewBuilder
    private func itemView(_ item: Data.Element) -> some View {
        GeometryReader { proxy in
            
            let size = proxy.size
            
            let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
            
            /* Progress = 0이면 카드가 중앙에 있음을 뜻함.*/
            let progress = minX / (config.cardWidth + config.spacing)
            
            /* 가장 작을 때 넓이 */
            let minimumCardwidth = config.minumumCardWidth
            
            /* 가장 클 때 넓이 - 가장 작을 때 넓이 */
            let diffWidth = config.cardWidth - minimumCardwidth
            
            /* 카드의 축소 폭 */
            let reducingWidth = progress * diffWidth
            
            /* 카드의 축소 폭이 diffWidth를 넘지 않도록. */
            let cappedWidth = min(reducingWidth, diffWidth)
            
            let resizedFrameWidth = size.width - (minX > 0 ? cappedWidth : min(-cappedWidth, diffWidth))
            
            let negativeProgress = max(-progress, 0)
            
            let scaleValue = config.scaleValue * abs(progress)
            let opacityValue = config.opacityValue * abs(progress)
            
            
            content(item)
                .frame(width: resizedFrameWidth)
                .opacity(1 - opacityValue)
                .scaleEffect(1 - scaleValue)
                .mask {
                    let scaleHeight = (1 - scaleValue) * size.height
                    RoundedRectangle(cornerRadius: config.cornerRadius)
                        .frame(height: scaleHeight)
                }
                .offset(x: -reducingWidth)
                .offset(x: min(progress, 1) * diffWidth)
                .offset(x: negativeProgress * diffWidth)
        }
        .frame(width: config.cardWidth)
    }
    
    struct Config {
        
        var hasOpacity = false
        var opacityValue = 0.5
        
        var hasScale = false
        var scaleValue: CGFloat = 0.2
        
        var cardWidth: CGFloat = 150
        var spacing: CGFloat = 10
        
        var cornerRadius: CGFloat = 15
        
        var minumumCardWidth: CGFloat = 40
    }
}

#Preview {
    Coverflow_Carousel()
}
