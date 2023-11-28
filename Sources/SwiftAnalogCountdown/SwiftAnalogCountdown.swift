import SwiftUI
import SwiftBlob

struct SACPalette {
    let shadow: Color
    let foreground: Color
    let background: Color
    let backgroundLight: Color
    let backgroundLighter: Color

    static let altA = SACPalette(shadow: .black,
                                 foreground: .init(hex: "#34beed"),
                                 background: .init(hex: "#84defd"),
                                 backgroundLight: .init(hex: "#a4eaff"),
                                 backgroundLighter: .init(hex: "#c4ffff").opacity(0.75))
    static let altB = SACPalette(shadow: .black,
                                 foreground: .red,
                                 background: .white.opacity(0.75),
                                 backgroundLight: .white.opacity(0.25),
                                 backgroundLighter: .white.opacity(0.25))
    static let altC = SACPalette(shadow: .black,
                                 foreground: .init(hex: "#007A85"),
                                 background: .init(hex: "#87E7E4"),
                                 backgroundLight: .init(hex: "#B0EEEC"),
                                 backgroundLighter: .init(hex: "#E1F9F8"))
}

public struct SACAnimation: View {
    let size: CGFloat = 400

    let colors = SACPalette.altA

    let blobPointsOuter = BlobView.getPoints(for: 0.1)
    let blobPointsInner = BlobView.getPoints(for: 0.2)
    let blobPointsCenter = BlobView.getPoints(for: 0.15)

    @State var isVisible: CGFloat
    @State var date: Date
    @State var timer: Timer?

    public init(isVisible: CGFloat = 0, date: Date = .now, timer: Timer? = nil) {
        _isVisible = State(initialValue: isVisible)
        _date = State(initialValue: date)
        _timer = State(initialValue: timer)
    }

    var hourAngle: Angle {
        let hour = Calendar.current.component(.hour, from: date)
        let minute = Double(Calendar.current.component(.minute, from: date))
        let degrees = (minute / 2) + (Double(hour) / 12) * 360
        return .degrees(Double(degrees))
    }

    var minuteAngle: Angle {
        let hour = Double(Calendar.current.component(.hour, from: date))
        let minute = Double(Calendar.current.component(.minute, from: date))
        let degrees = (hour + (minute / 60)) * 360
        return .degrees(degrees)
    }

    var secondAngle: Angle {
        let hour = Calendar.current.component(.hour, from: date)
        let minute = Double(Calendar.current.component(.minute, from: date))
        let second = Double(Calendar.current.component(.second, from: date))
        let degrees = second + (minute * 60) + (Double(hour) * 360) * 360
        return .degrees(Double(degrees))
    }

    public var body: some View {
        Circle()
            .foregroundColor(.clear)
            .overlay {
                ZStack {
                    dialBackgrounds
                    dialDecorations
                    hands
                    BlobView(spikyness: 0.2, isAnimated: false, points: blobPointsCenter)
                        .shadow(color: colors.shadow, radius: 0, y: 8 * isVisible)
                        .foregroundColor(colors.foreground)
                        .frame(maxWidth: size * 0.15)
                        .scaleEffect(isVisible)
                        .animation(.bouncy, value: isVisible)
                    BlobView(spikyness: 0.2, isAnimated: false, points: blobPointsCenter)
                        .foregroundColor(colors.backgroundLighter)
                        .frame(maxWidth: size * 0.05)
                        .scaleEffect(isVisible)
                        .animation(.bouncy, value: isVisible)
                    Button("Toggle") {
                        withAnimation {
                            isVisible = isVisible == 0 ? 1 : 0
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .offset(y: size * 0.5)
                    Text(date.getFormattedDate(format: "HH:mm"))
                        .offset(y: size * 0.55)
                }
            }
            .onAppear {
                isVisible = 1
                date = date.addingTimeInterval(60)
                timer = .scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    date = date.addingTimeInterval(60)
                }
            }
            .frame(width: size, height: size)
    }


    var hands: some View {
        ZStack {
            // Mark: Shadows
            Rectangle()
                .foregroundColor(colors.shadow)
                .frame(maxHeight: size * 0.075)
                .frame(width: size / 4)
                .offset(x: -(size / 6))
                .rotationEffect(hourAngle)
                .rotationEffect(.degrees(90))                .animation(.bouncy, value: hourAngle)
                .offset(y: 8)
                .scaleEffect(isVisible)

            Rectangle()
                .foregroundColor(colors.shadow)
                .frame(maxHeight: size * 0.04)
                .frame(width: size / 3)
                .offset(x: -(size / 5))
                .rotationEffect(minuteAngle)
                .rotationEffect(.degrees(90))
                .offset(y: 8)
                .animation(.bouncy, value: minuteAngle)
                .scaleEffect(isVisible)

            // Mark: Hands
            Rectangle()
                // .shadow(color: colors.shadow, radius: 0, y: 8)
                .foregroundColor(colors.foreground)
                .frame(maxHeight: size * 0.075)
                .frame(width: size / 4)
                .offset(x: -(size / 6))
                .rotationEffect(hourAngle)
                .rotationEffect(.degrees(90))
                .animation(.bouncy, value: hourAngle)
                .scaleEffect(isVisible)
            Rectangle()
                // .shadow(color: colors.shadow, radius: 0, y: 8)
                .foregroundColor(colors.foreground)
                .frame(maxHeight: size * 0.04)
                .frame(width: size / 3)
                .offset(x: -(size / 5))
                .rotationEffect(minuteAngle)
                .rotationEffect(.degrees(90))
                .animation(.bouncy, value: minuteAngle)
                .scaleEffect(isVisible)
        }
    }

    var dialDecorations: some View {
        ZStack {
            ForEach(Range(0...40), id: \.self) {
                Rectangle()
                    .foregroundColor(colors.backgroundLighter)
                    .frame(size * 0.015)
                    .offset(x: -(size * 0.32))
                    .rotationEffect(.degrees(Double($0) * 9) - (secondAngle * 0.8))
                    .scaleEffect(x: 0.95)
                    .scaleEffect(isVisible == 1 ? 1 : 2)
                    .opacity(isVisible)
                    .animation(.bouncy(duration: 0.6, extraBounce: 0.35), value: isVisible)
                    .animation(.linear(duration: 1), value: secondAngle)
            }
            ForEach(Range(0...30), id: \.self) {
                Rectangle()
                    .foregroundColor(colors.backgroundLighter)
                    .frame(size * 0.016)
                    .offset(x: -(size * 0.2))
                    .rotationEffect(.degrees(Double($0) * 12) - secondAngle)
                    .scaleEffect(y: 0.95)
                    .scaleEffect(isVisible == 1 ? 1 : 2)
                    .opacity(isVisible)
                    .animation(.bouncy(duration: 0.4, extraBounce: 0.25), value: isVisible)
                    .animation(.linear(duration: 1), value: secondAngle)
            }
        }
    }

    var dialBackgrounds: some View {
        ZStack {
            BlobView(spikyness: 0.2, isAnimated: false, points: blobPointsOuter)
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(colors.shadow)
                // .shadow(color: colors.shadow, radius: 0, y: 8)
                .scaleEffect(isVisible)
                .opacity(isVisible)
                .animation(.bouncy(duration: 0.3, extraBounce: 0.3), value: isVisible)
                .offset(y: 8)

            BlobView(spikyness: 0.2, isAnimated: false, points: blobPointsOuter)
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(colors.foreground)
                // .shadow(color: colors.shadow, radius: 0, y: 8)
                .scaleEffect(isVisible)
                .animation(.bouncy(duration: 0.5, extraBounce: 0.3), value: isVisible)
            BlobView(spikyness: 0.2, isAnimated: false, points: blobPointsOuter)
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(colors.background)
                .frame(maxWidth: size * 0.92)
                .scaleEffect(isVisible)
                .animation(.smooth, value: isVisible)
            BlobView(spikyness: 0.2, isAnimated: false, points: blobPointsInner)
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(colors.backgroundLight)
                .frame(maxWidth: size * 0.6)
                .scaleEffect(isVisible)
                .animation(.smooth, value: isVisible)
            BlobView(spikyness: 0.2, isAnimated: false, points: blobPointsInner)
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(colors.backgroundLighter)
                .frame(maxWidth: size * 0.35)
                .scaleEffect(isVisible)
                .animation(.bouncy, value: isVisible)
        }
    }
}

#Preview {
    SACAnimation()
        .frame(500)
}
