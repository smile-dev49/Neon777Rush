import AudioToolbox
import UIKit

enum GameSound {
    case tap
    case spin
    case win
    case jackpot
    case coin
}

final class SoundHapticsService {
    static let shared = SoundHapticsService()

    private init() {}

    func play(_ sound: GameSound) {
        let id: SystemSoundID
        switch sound {
        case .tap:
            id = 1104
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .spin:
            id = 1156
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .win:
            id = 1025
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .jackpot:
            id = 1027
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .coin:
            id = 1057
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        }
        AudioServicesPlaySystemSound(id)
    }
}
