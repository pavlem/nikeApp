//
//  ZoomableImageView.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 20. 4. 2025..
//

import SwiftUI

struct ZoomableImageView: View {
    let imageURL: URL
    @Environment(\.dismiss) private var dismiss

    @State private var zoomScale: CGFloat = 1.0

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()
            
            VStack {
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding()
                    }
                }
                
                GeometryReader { geometry in
                    ScrollView(zoomScale > 1 ? [.horizontal, .vertical] : [], showsIndicators: false) {
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(
                                    width: geometry.size.width * zoomScale
                                )
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        zoomScale = zoomScale == 1.0 ? 2.0 : 1.0
                                    }
                                }
                        } placeholder: {
                            Color.gray.opacity(0.2)
                        }
                    }
                }
            }
        }
    }
}



