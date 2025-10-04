import SwiftUI
import ElegantEmojiPicker

@available(iOS 14.0, *)
struct SwiftUIDemoView: View {
    @State private var selectedEmoji: Emoji? = placeholderEmoji
    @State private var isEmojiPickerPresented: Bool = false

    @State private var animate = true
    
    var body: some View {
        VStack(spacing: 30) {
            Text(selectedEmoji?.emoji ?? "")
                .font(.system(size: 50))
                .scaleEffect(animate ? 1.0 : 0.1)
                .animation(
                    .interpolatingSpring(stiffness: 400, damping: 20),
                    value: animate
                )
                .onChange(of: selectedEmoji) { _ in
                    animate = false
                    DispatchQueue.main.async {
                        animate = true
                    }
                }

            Button("Select emoji") {
                isEmojiPickerPresented.toggle()
            }
            .frame(width: 200, height: 40)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .navigationTitle(Text("Swift UI Demo"))
        .emojiPicker(
            isPresented: $isEmojiPickerPresented,
            selectedEmoji: $selectedEmoji,
        )
    }
}

@available(iOS 14.0, *)
struct SwiftUIDemoView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIDemoView()
    }
}

let placeholderEmoji: Emoji = Emoji(emoji: "😀", description: "", category: .SmileysAndEmotion, aliases: [], tags: [], supportsSkinTones: false, iOSVersion: "")
