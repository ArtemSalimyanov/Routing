import SwiftUI

public protocol Routable: Hashable {
    associatedtype ViewType: View
    func viewToDisplay() -> ViewType
}
