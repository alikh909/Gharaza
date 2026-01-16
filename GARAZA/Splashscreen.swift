import SwiftUI
import SwiftUI
import AVKit
import AVFoundation

struct VideoBackground: View {
    @State private var player: AVPlayer?

    var body: some View {
        Group {
            if let player = player {
                VideoPlayer(player: player)
                    .ignoresSafeArea()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        player.play()
                    }
            } else {
                // Fallback if video not found
                Color.black.ignoresSafeArea()
                Text("Video not found: hall.mp4")
                    .foregroundColor(.white)
            }
        }
        .onAppear {
            // ✅ Safe load
            guard let url = Bundle.main.url(forResource: "hall", withExtension: "mp4") else {
                print("❌ hall.mp4 NOT in bundle")
                return
            }
            print("✅ Video URL:", url)

            let p = AVPlayer(url: url)
            p.isMuted = true
            p.actionAtItemEnd = .none

            // ✅ Loop
            NotificationCenter.default.addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: p.currentItem,
                queue: .main
            ) { _ in
                p.seek(to: .zero)
                p.play()
            }

            player = p
            p.play()
        }
        .onDisappear {
            player?.pause()
            player = nil
            NotificationCenter.default.removeObserver(self)
        }
    }
}

struct Splashscreen: View {
    @State private var animate = false
    @State private var goNext = false

    var body: some View {
        ZStack {
            VideoBackground()

            Color.black.opacity(0.35).ignoresSafeArea()

            VStack(spacing: 12) {
                Text("Gharaza")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 18)
                    .opacity(animate ? 1 : 0)
                    .offset(y: animate ? 0 : 14)
                    .scaleEffect(animate ? 1.0 : 0.98)
                    .animation(
                        .easeInOut(duration: 1.6).delay(0.3),
                        value: animate
                    )

            }
        }
        .onAppear {
            animate = true

            // ⏱ move to ContentView after splash
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                goNext = true
            }
        }
        .fullScreenCover(isPresented: $goNext) {
            ContentView()   // ✅ THIS IS THE MAPPING
        }
    }
}

#Preview {
    Splashscreen()
}
