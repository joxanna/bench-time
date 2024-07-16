//
//  BottomSheet.swift
//  benchTime
//
//  Created by Joanna Xue on 16/7/2024.
//

import SwiftUI

//struct BottomSheet: ViewModifier {
//    @Binding var isExpanded: Bool
//    let content: AnyView
//    
//    init(isExpanded: Binding<Bool>, content: AnyView) {
//        self._isExpanded = isExpanded
//        self.content = AnyView(content)
//    }
//    
//    func body(content: Content) -> some View {
//        VStack {
//            Spacer()
//            if isExpanded {
//                self.content
//                    .transition(.move(edge: .bottom))
//                    .animation(.easeInOut(duration: 0.3), value: isExpanded)
//                    .gesture(
//                        DragGesture()
//                            .onChanged { value in
//                                if value.translation.height < 0 {
//                                    isExpanded = true
//                                } else if value.translation.height > 0 {
//                                    isExpanded = false
//                                }
//                            }
//                    )
//            } else {
//                self.content
//                    .frame(height: 300)  // Adjust the height of the bottom sheet
//                    .transition(.move(edge: .bottom))
//                    .animation(.easeInOut(duration: 0.3), value: isExpanded)
//                    .gesture(
//                        DragGesture()
//                            .onChanged { value in
//                                if value.translation.height < 0 {
//                                    isExpanded = true
//                                } else if value.translation.height > 0 {
//                                    isExpanded = false
//                                }
//                            }
//                    )
//            }
//        }
//    }
//}
//
//extension View {
//    func bottomSheet(isExpanded: Binding<Bool>, content: AnyView) -> some View {
//        self.modifier(BottomSheet(isExpanded: isExpanded, content: AnyView(content)))
//    }
//}

//import SwiftUI
//
//struct BottomSheet<Content: View>: ViewModifier {
//    @Binding var isExpanded: Bool
//    let content: Content
//    
//    init(isExpanded: Binding<Bool>, @ViewBuilder content: () -> Content) {
//        self._isExpanded = isExpanded
//        self.content = content()
//    }
//    
//    func body(content: Content) -> some View {
//        VStack {
//            Spacer()
//            self.content
//                .background(Color.white)
//                .cornerRadius(20)
//                .transition(.move(edge: .bottom))
//                .animation(.easeInOut(duration: 0.3), value: isExpanded)
//                .gesture(
//                    DragGesture()
//                        .onChanged { value in
//                            if value.translation.height < 0 {
//                                isExpanded = true
//                            } else if value.translation.height > 0 {
//                                isExpanded = false
//                            }
//                        }
//                )
//                .frame(height: isExpanded ? nil : 300)  // Adjust the height of the bottom sheet
//        }
//    }
//}
//
//extension View {
//    func bottomSheet<Content: View>(isExpanded: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
//        self.modifier(BottomSheet(isExpanded: isExpanded, content: content))
//    }
//}
