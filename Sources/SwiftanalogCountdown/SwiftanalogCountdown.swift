import SwiftUI
import SwiftBlob

struct DrawAnimation: View {
    let size: CGFloat = 350
    let squishedCirclePoints = BlobShape.createPoints(minGrowth: 9, edges: 8)

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
                        .shadow(color: .nt.primary.w700, radius: 0, y: 8 * isVisible)
                        .foregroundColor(.nt.primary.w600)
                        .frame(maxWidth: size * 0.15)
                        .scaleEffect(isVisible)
                        .animation(.bouncy, value: isVisible)
                    Circle()
                        .foregroundColor(.nt.pink.w300)
                        .frame(maxWidth: size * 0.05)
                        .scaleEffect(isVisible)
                        .animation(.bouncy, value: isVisible)
                    Button("Se om du vant") {
                        withAnimation {
                            isVisible = isVisible == 0 ? 1 : 0
                        }
                    }
                    .buttonStyle(NTButton(.primary))
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
            .frame(size)
    }


    var hands: some View {
        ZStack {
            Rectangle()
                .shadow(color: .nt.primary.w700, radius: 0, y: 8)
                .foregroundColor(.nt.primary.w600)
                .frame(maxHeight: size * 0.075)
                .frame(width: size / 4)
                .offset(x: -(size / 6))
                .rotationEffect(hourAngle)
                .rotationEffect(.degrees(90))
                .animation(.bouncy, value: hourAngle)
                .scaleEffect(isVisible)
            Rectangle()
                .shadow(color: .nt.primary.w700, radius: 0, y: 8)
                .foregroundColor(.nt.primary.w600)
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
                    .foregroundColor(.nt.primary.w300)
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
                    .foregroundColor(.nt.primary.w200)
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
            BlobShape(controlPoints: squishedCirclePoints)
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(.nt.primary.w600)
                .shadow(color: .nt.primary.w700, radius: 0, y: 8)
                .scaleEffect(isVisible)
                .animation(.bouncy(duration: 0.5, extraBounce: 0.3), value: isVisible)
            BlobShape(controlPoints: squishedCirclePoints)
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(.nt.primary.w400)
                .frame(maxWidth: size * 0.92)
                .scaleEffect(isVisible)
                .animation(.smooth, value: isVisible)
            BlobShape(controlPoints: squishedCirclePoints)
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(.nt.primary.w300)
                .frame(maxWidth: size * 0.77)
                .scaleEffect(isVisible)
                .animation(.smooth, value: isVisible)
            BlobShape(controlPoints: squishedCirclePoints)
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(.nt.primary.w200)
                .frame(maxWidth: size * 0.4)
                .scaleEffect(isVisible)
                .animation(.bouncy, value: isVisible)
        }
    }
}

#Preview {
    DrawAnimation()
}
