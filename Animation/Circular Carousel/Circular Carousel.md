# Circular Carousel.md 

## 시뮬레이터 
![Simulator Screen Recording - iPhone 16 Pro - 2025-03-29 at 18 50 06](https://github.com/user-attachments/assets/8be61d43-5d16-40f9-9764-b54ce32fdcf4)

---
## 코드 

```swift
//
//  Circular Carousel.swift
//  Animation
//
//  Created by LEE on 3/28/25.
//

import SwiftUI

struct CircularCarousel: View {
        
    var models: [Model] = [
        
            .init(number: "0002", color: .red),
            .init(number: "0003", color: .green),
            .init(number: "0004", color: .blue),
            .init(number: "0005", color: .yellow),
            .init(number: "0006", color: .orange),
            .init(number: "0007", color: .purple),
            .init(number: "0008", color: .pink),
            .init(number: "0009", color: .brown),
            .init(number: "0010", color: .gray),
            .init(number: "0011", color: .cyan),
            .init(number: "0012", color: .mint),
            .init(number: "0013", color: .indigo),
            .init(number: "0014", color: .teal)
        
    ]
    
    var body: some View {
        
        GeometryReader {
            let size = $0.size
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(models, id: \.id) { model in
                        cardView(model)
                            .frame(width: 220, height: 150)
                            .visualEffect { content, proxy in
                                content
                                    .offset(x: 150)
                                    .rotationEffect(.degrees(rotationCard(proxy)), anchor: .leading)
                                    .offset(x: -100, y: -proxy.frame(in: .scrollView(axis: .vertical)).minY)
                                    .scaleEffect(scaleCard(proxy))

                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .scrollTargetLayout()
            }
            .safeAreaPadding(.vertical, size.height * 0.5 - 75)
            .border(.black)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .toolbar(.hidden, for: .navigationBar)
            .background {
                Color.black
                
                Circle()
                    .fill(.ultraThinMaterial).opacity(0.25)
                    .frame(width: size.width * 1.2, height: size.height * 1.2)
                    .offset(x: -size.width / 1.5)
            }
        }
        
        
    }
    
    @ViewBuilder
    func cardView(_ model: Model) -> some View {
     
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(model.color.gradient)
            
            VStack {
                HStack {
                    Image("visa")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 60, height: 40)
                        .foregroundStyle(.white)
                        .tint(.white)
                        
                    Spacer()
                }
                
                Spacer()
                
                HStack {
                    
                    ForEach(0..<3, id: \.self) {_ in
                        Text("****")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                    }
                    Text(model.number)
                        .font(.subheadline)
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.top, 30)
                
                Spacer()
                
                HStack {
                    Text(model.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)

                    
                    Spacer()
                    
                    Text(model.date)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)


                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
        }
    }
        
    
    func rotationCard(_ proxy: GeometryProxy) -> CGFloat {
        
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let height = proxy.size.height
        
        let progress = minY / height
        
        let angle: CGFloat = 50
        
        let cappedProgress = progress < 0 ? min(max(progress, -2), 0) : max(min(progress, 2), 0)
        
        return cappedProgress * angle
        
    }
    
    func scaleCard(_ proxy: GeometryProxy) -> CGFloat {
            let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
            let height = proxy.bounds(of: .scrollView(axis: .vertical))!.height
            
            let progress = minY / height
            
            let maxScale: CGFloat = 1.0
            let minScale: CGFloat = 0.75
            
            let scale = maxScale - abs(progress) * (maxScale - minScale)
            return max(minScale, min(scale, maxScale))
        }
    
    struct Model {
        
        var id: UUID = UUID()
        var number: String
        var name: String = "이준혁"
        var date: String = "03/28"
        var color: Color

    }
    
}



#Preview {
    CircularCarousel()
}
```
