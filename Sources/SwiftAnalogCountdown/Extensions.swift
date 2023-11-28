import SwiftUI

extension Color {
    init(hex hexString: String) {
        let trimHex = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let dropHash = String(trimHex.dropFirst()).trimmingCharacters(in: .whitespacesAndNewlines)
        let hexString = trimHex.starts(with: "#") ? dropHash : trimHex
        let ui64 = UInt64(hexString, radix: 16)
        let value = ui64 != nil ? Int(ui64!) : 0
        let rgb = (
            R: CGFloat((value >> 16) & 0xff) / 255,
            G: CGFloat((value >> 08) & 0xff) / 255,
            B: CGFloat((value >> 00) & 0xff) / 255,
            a: CGFloat(1)
        )
        #if os(iOS)
        self.init(UIColor(red: rgb.R, green: rgb.G, blue: rgb.B, alpha: 1))
        #else
        self.init(NSColor(red: rgb.R, green: rgb.G, blue: rgb.B, alpha: 1))
        #endif
   }
}


extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.locale = Locale.init(identifier: Locale.preferredLanguages[0])
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

extension View {
    func frame(_ size: CGFloat?, alignment: Alignment = .center) -> some View {
        frame(width: size, height: size, alignment: alignment)
    }
}
