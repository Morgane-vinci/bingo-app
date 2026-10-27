import SwiftUI

@main
struct BingoApp: App {
    var body: some Scene {
        WindowGroup { ContentView().statusBarHidden() }
    }
}

struct Piece {
    let x, speed, drift, size, spin, phase: Double
    let color: Color
}

struct ContentView: View {
    @State private var shown = false
    @State private var wiggle = false
    private let pieces: [Piece] = (0..<120).map { _ in
        Piece(x: .random(in: 0...1), speed: .random(in: 0.08...0.2), drift: .random(in: -0.05...0.05),
              size: .random(in: 6...14), spin: .random(in: 1...4), phase: .random(in: 0...1),
              color: [.white, .yellow, .green, Color(red: 0.25, green: 0.88, blue: 0.82),
                      Color(red: 0.49, green: 0.30, blue: 1.0)].randomElement()!)
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 1, green: 0.24, blue: 0.5),
                                    Color(red: 1, green: 0.48, blue: 0.24),
                                    Color(red: 1, green: 0.67, blue: 0)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            TimelineView(.animation) { timeline in
                Canvas { ctx, size in
                    let t = timeline.date.timeIntervalSinceReferenceDate
                    for p in pieces {
                        let progress = (t * p.speed + p.phase).truncatingRemainder(dividingBy: 1)
                        let y = progress * (size.height + 40) - 20
                        let x = (p.x + sin(t * p.spin * 0.5) * p.drift) * size.width
                        let angle = t * p.spin
                        let h = max(p.size * 1.6 * abs(cos(angle)), 1)
                        var c = ctx
                        c.translateBy(x: x, y: y)
                        c.rotate(by: .radians(angle))
                        c.fill(Path(CGRect(x: -p.size / 2, y: -h / 2, width: p.size, height: h)),
                               with: .color(p.color))
                    }
                }
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)

            VStack(spacing: 4) {
                Text("Bingo")
                Text("j’ai gagné\u{00A0}!")
            }
            .font(.system(size: 60, weight: .black, design: .rounded))
            .lineLimit(1)
            .minimumScaleFactor(0.4)
            .foregroundStyle(.white)
            .shadow(color: Color(red: 0.48, green: 0.08, blue: 0.25), radius: 0, x: 0, y: 4)
            .padding(.horizontal, 16)
            .scaleEffect(shown ? (wiggle ? 1.05 : 1) : 0.01)
            .rotationEffect(.degrees(shown ? (wiggle ? 2 : -2) : -12))
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) { shown = true }
                withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true).delay(0.8)) { wiggle = true }
            }
        }
    }
}
