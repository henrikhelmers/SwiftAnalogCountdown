import SwiftUI
import SwiftBlob

struct DrawAnimation: View {
    let size: CGFloat = 350

    let colorShadow: Color = .black
    let colorForeground = Color(hex: "#007A85")
    let colorBackgroundLighter = Color(hex: "#E1F9F8")
    let colorBackgroundLight = Color(hex: "#B0EEEC")
    let colorBackground = Color(hex: "#87E7E4")
    let colorBackgroundDark = Color(hex: "#66CCCC")
    let colorBackgroundDarker = Color(hex: "#10CFC9")


    /*
    let ixia: NTColor = NTColor(
        w50: Color(hex: "#F9FFFC"),
        w100: Color(hex: "#E1F9F8"),
        w200: Color(hex: "#B0EEEC"),
        w300: Color(hex: "#87E7E4"),
        w400: Color(hex: "#66CCCC"),
        w500: Color(hex: "#10CFC9"),
        w600: Color(hex: "#007A85"),
        w700: Color(hex: "#00454B"),
        w800: Color(hex: "#00454B"),
        w900: Color(hex: "#00454B"))
    */

    @State var isVisible: CGFloat = 0
    @State var date: Date = .now
    @State var timer: Timer?

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

    var body: some View {
        Circle()
            .foregroundColor(.clear)
            .overlay {
                ZStack {
                    dialBackgrounds
                    dialDecorations
                    hands
                    Circle()
                        .shadow(color: colorShadow, radius: 0, y: 8 * isVisible)
                        .foregroundColor(colorForeground)
                        .frame(maxWidth: size * 0.15)
                        .scaleEffect(isVisible)
                        .animation(.bouncy, value: isVisible)
                    Circle()
                        .foregroundColor(colorBackgroundLighter)
                        .frame(maxWidth: size * 0.05)
                        .scaleEffect(isVisible)
                        .animation(.bouncy, value: isVisible)
                    Button("Toggle") {
                        withAnimation {
                            isVisible = isVisible == 0 ? 1 : 0
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .offset(y: 260)
                    Text(date.getFormattedDate(format: "HH:mm"))
                        .offset(y: 300)
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
            Rectangle()
                .shadow(color: colorShadow, radius: 0, y: 8)
                .foregroundColor(colorForeground)
                .frame(maxHeight: size * 0.075)
                .frame(width: size / 4)
                .offset(x: -(size / 6))
                .rotationEffect(hourAngle)
                .rotationEffect(.degrees(90))
                .animation(.bouncy, value: hourAngle)
                .scaleEffect(isVisible)
            Rectangle()
                .shadow(color: colorShadow, radius: 0, y: 8)
                .foregroundColor(colorForeground)
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
                    .foregroundColor(colorBackgroundLight)
                    .frame(size * 0.015)
                    .offset(x: -(size * 0.36))
                    .rotationEffect(.degrees(Double($0) * 9) - (secondAngle * 0.8))
                    .scaleEffect(x: 0.95)
                    .scaleEffect(isVisible == 1 ? 1 : 2)
                    .opacity(isVisible)
                    .animation(.bouncy(duration: 0.6, extraBounce: 0.35), value: isVisible)
                    .animation(.linear(duration: 1), value: secondAngle)
            }
            ForEach(Range(0...30), id: \.self) {
                Rectangle()
                    .foregroundColor(colorBackgroundLighter)
                    .frame(size * 0.016)
                    .offset(x: -(size * 0.25))
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
            BlobView(spikyness: 0.2, isAnimated: false)
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(colorForeground)
                .shadow(color: colorShadow, radius: 0, y: 8)
                .scaleEffect(isVisible)
                .animation(.bouncy(duration: 0.5, extraBounce: 0.3), value: isVisible)
            BlobView(spikyness: 0.2, isAnimated: false)
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(colorBackground)
                .frame(maxWidth: size * 0.92)
                .scaleEffect(isVisible)
                .animation(.smooth, value: isVisible)
            BlobView(spikyness: 0.2, isAnimated: false)
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(colorBackgroundLight)
                .frame(maxWidth: size * 0.77)
                .scaleEffect(isVisible)
                .animation(.smooth, value: isVisible)
            BlobView(spikyness: 0.2, isAnimated: false)
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(colorBackgroundLighter)
                .frame(maxWidth: size * 0.4)
                .scaleEffect(isVisible)
                .animation(.bouncy, value: isVisible)
        }
    }
}

#Preview {
    DrawAnimation()
        .frame(600)
}
