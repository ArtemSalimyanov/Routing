import Foundation
import SwiftUI


struct NavigationRoutePushModifier<Route: Routable>: ViewModifier {
  @State private var isActive: Bool = false
  @State private var isOldActive: Bool = false
  
  private let route: Binding<Route?>
  @State private var oldRoute: Route? = nil
  
  init(route: Binding<Route?>) {
    self.route = route
  }
  
  func body(content: Content) -> some View {
    ZStack {
      if #available(iOS 16.0, *) {
        content
          .navigationDestination(isPresented: $isActive, destination: { route.wrappedValue?.viewToDisplay() } )
      } else {
        content
        NavigationLink(destination: route.wrappedValue?.viewToDisplay(), isActive: $isActive) {
          EmptyView()
        }
        .isDetailLink(false)
        .hidden()
      }
      
      let _ = update()
    }
  }
  
  private func `update`() {
    if isOldActive != isActive {
        Task { @MainActor in
            isOldActive = isActive
            if !isActive {
              route.wrappedValue = nil
            }
        }
    }
      if oldRoute != route.wrappedValue {
          Task { @MainActor in
            oldRoute = route.wrappedValue
            changeItem(route.wrappedValue)
          }
      }
  }
  
  private func changeItem(_ newRoute: Route?){
    if newRoute != nil {
          isActive = true
      } else {
          isActive = false
      }
  }
}

public extension View {
  func navigate<Destination: Routable>(_ routeType: Destination?.Type, route: Binding<Destination?>) -> some View {
    self.modifier(NavigationRoutePushModifier(route: route))
  }
}
