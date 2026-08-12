import SwiftUI

struct RootView: View {
    @EnvironmentObject private var store: GameStore

    var body: some View {
        ZStack {
            NeonBackground()

            Group {
                switch store.selectedTab {
                case .home:
                    HomeView()
                case .play:
                    SlotGameplayView()
                case .missions:
                    MissionsView()
                case .rewards:
                    RewardsView()
                case .profile:
                    ProfileView()
                case .event:
                    JackpotEventView()
                }
            }
            .transition(.opacity.combined(with: .move(edge: .trailing)))

            VStack {
                Spacer()
                BottomNav()
            }
        }
    }
}
