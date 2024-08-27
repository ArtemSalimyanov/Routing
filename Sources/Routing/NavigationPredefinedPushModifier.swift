import SwiftUI

struct NavigationPredefinedPushModifier<Destination: View>: ViewModifier {
  private let isActive: Binding<Bool>
  private let destination: Destination?
  
  init(isActive: Binding<Bool>, destination: Destination?) {
    self.isActive = isActive
    self.destination = destination
  }
  
  func body(content: Content) -> some View {
    ZStack {
      if #available(iOS 16.0, *) {
        content
          .navigationDestination(isPresented: isActive, destination: { destination } )
      } else {
        content
        NavigationLink(destination: destination, isActive: isActive) {
          EmptyView()
        }
        .isDetailLink(false)
        .hidden()
      }
    }
  }
}

public extension View {
  func push<Destination: View>(
    isActive: Binding<Bool>,
    @ViewBuilder destination: @escaping () -> Destination
  ) -> some View {
    self.modifier(
      NavigationPredefinedPushModifier(
        isActive: isActive,
        destination: isActive.wrappedValue ? destination() : nil
      )
    )
  }
}
