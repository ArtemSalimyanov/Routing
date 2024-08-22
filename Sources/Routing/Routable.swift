import SwiftUI

public protocol Routable: Equatable {
    associatedtype ViewType: View
    func viewToDisplay() -> ViewType
}
