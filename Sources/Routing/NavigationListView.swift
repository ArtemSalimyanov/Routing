import SwiftUI

public struct NavigationListView<Content : View> : View {
  private let rootView: Content
  
  public init(@ViewBuilder rootView: () -> Content) {
    self.rootView = rootView()
  }
  
  public var body: some View {
    if #available(iOS 16.0, *) {
      NavigationStack {
        rootView
      }
    } else {
      NavigationView {
        rootView
      }
      .navigationViewStyle(.stack)
    }
  }
}
