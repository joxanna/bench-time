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

//struct BottomSheet<Item: Identifiable, SheetContent: View>: ViewModifier {
//    
//    @Binding var item: Item?
//
//    let onDismiss: (() -> Void)?
//    @ViewBuilder let sheetContent: (Binding<Item>) -> SheetContent
//
//    @ViewBuilder func body(content: Content) -> some View {
//        content
//            .sheet(item: self.$item, onDismiss: self.onDismiss) { newItem in
//                self.sheetContent(Binding {
//                    newItem
//                } set: {
//                    self.item = $0
//                }) // sheetContent
//            } // .sheet
//    }
//}
//
//
//extension View {
//    @ViewBuilder func sheet<Item, Content>(item: Binding<Item?>, onDimiss: (() -> Void)? = nil, @ViewBuilder content: @escaping (Binding<Item>) -> Content) -> some View where Item: Identifiable, Content: View {
//        self.modifier(SheetBinding(item: item, onDismiss: onDimiss, sheetContent: content))
//    }
//}
