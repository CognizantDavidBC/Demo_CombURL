//
//  InteractiveImageView.swift
//  AstroPic
//
//  Created by m_944879 on 23/5/22.
//

import SwiftUI

struct InteractiveImageView: View {
    @State private var steadyStateMagnification: CGFloat = 1
    @State private var steadyStateOffset: CGSize = .zero
    @GestureState private var gestureMagnification: CGFloat = 1
    @GestureState private var gestureOffset: CGSize = .zero
    
    let image: UIImage
    let minimumScaleFactor: CGFloat = 0.5
    
    var magnification: CGFloat {
        steadyStateMagnification * gestureMagnification
    }
    
    var offset: CGSize {
        (steadyStateOffset + gestureOffset) * magnification
    }
    
    var pinch: some Gesture {
        MagnificationGesture()
            .updating($gestureMagnification) { latestState, gestureMagnification, transaction in
                if steadyStateMagnification * latestState >= minimumScaleFactor {
                    gestureMagnification = latestState
                }
            }
            .onEnded { value in
                if steadyStateMagnification * value >= minimumScaleFactor {
                    steadyStateMagnification *= value
                } else {
                    steadyStateMagnification = minimumScaleFactor
                }
            }
    }
    
    var doubleTap: some Gesture {
        TapGesture(count: 2)
            .onEnded { _ in
                if magnification > 1 {
                    steadyStateMagnification = 1
                    steadyStateOffset = .zero
                } else {
                    steadyStateMagnification = 2
                }
            }
    }
    
    var body: some View {
        GeometryReader{ geometry in
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .scaleEffect(magnification)
                .offset(offset)
                .gesture(pinch)
                .gesture(doubleTap)
                .gesture(drag(in: geometry.size))
                .clipped()
                .animation(.easeInOut(duration: 0.4))
        }
        .edgesIgnoringSafeArea([.bottom, .vertical])
        .navigationBarTitle(Text(""), displayMode: .inline)
    }
    
    private func drag(in size: CGSize) -> some Gesture {
        let imageSize = size.width * magnification
        let availableWidth = (imageSize - size.width) / 2
        
        return DragGesture(minimumDistance: 10, coordinateSpace: .local)
            .updating($gestureOffset) { latestState, offset, transaction in
                let newOffset = latestState.translation.width + steadyStateOffset.width * magnification
                if availableWidth > newOffset.magnitude {
                    offset = latestState.translation / magnification
                }
            }
            .onEnded { value in
                let newValue = value.translation.width + steadyStateOffset.width * magnification
                
                if availableWidth >= newValue.magnitude {
                    steadyStateOffset = steadyStateOffset + (value.translation / magnification)
                } else {
                    if value.translation.width < 0 {
                        steadyStateOffset = CGSize(width: -availableWidth / magnification, height: steadyStateOffset.height)
                    } else {
                        steadyStateOffset = CGSize(width: availableWidth / magnification, height: steadyStateOffset.height)
                    }
                }
            }
    }
}
