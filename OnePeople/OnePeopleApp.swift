import SwiftUI

@main
struct OnePeopleApp: App {
    @StateObject private var appModel = OnePeopleAppModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appModel)
        }
    }
}
