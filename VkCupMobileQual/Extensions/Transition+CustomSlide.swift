// Transition+CustomSlide.swift

import SwiftUI

extension AnyTransition {
    static var customSlide: AnyTransition {
        get {
            AnyTransition.modifier(
                active: ClipShapeModifier(shape: CustomSlideShape(animatableData: 0)),
                identity: ClipShapeModifier(shape: CustomSlideShape(animatableData: 1))
            )
        }
    }
}

struct ClipShapeModifier<S>: ViewModifier where S: Shape {
    let shape: S
    
    func body(content: Content) -> some View {
        content.clipShape(shape)
    }
}

struct CustomSlideShape: Shape {
    
    var animatableData: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        var bigRect = rect
        bigRect.size.width *= animatableData
        
        path = RoundedRectangle(cornerRadius: 12).path(in: bigRect)
        
        return path
    }
}
