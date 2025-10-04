import SwiftUI
import UIKit

@available(iOS 14.0, *)
struct ElegantEmojiPickerRepresentable: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var selectedEmoji: Emoji?
    let configuration: ElegantConfiguration
    let localization: ElegantLocalization

    func makeUIViewController(context: Context) -> ElegantEmojiPicker {
        let picker = ElegantEmojiPicker(
            delegate: context.coordinator,
            configuration: configuration,
            localization: localization
        )
        return picker
    }

    func updateUIViewController(_ uiViewController: ElegantEmojiPicker, context: Context) {
        // Updates can be handled here if needed, for example, if configuration or localization could change
        // while the picker is presented. For now, we assume they are set at initialization.
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, ElegantEmojiPickerDelegate, UIAdaptivePresentationControllerDelegate {
        var parent: ElegantEmojiPickerRepresentable

        init(_ parent: ElegantEmojiPickerRepresentable) {
            self.parent = parent
        }

        // MARK: - ElegantEmojiPickerDelegate
        func emojiPicker(_ picker: ElegantEmojiPicker, didSelectEmoji emoji: Emoji?) {
            parent.selectedEmoji = emoji
        }

        // MARK: - UIAdaptivePresentationControllerDelegate
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            // Handle dismissal by swipe or other non-programmatic means
            if parent.isPresented {
                parent.isPresented = false
            }
        }
        
        // Optional delegate methods that we can leave to their default implementations for now
        // or expose further if advanced customization is needed.
        // func emojiPicker(_ picker: ElegantEmojiPicker, focusedSectionChanged to: Int, from: Int) {}
        // func emojiPicker(_ picker: ElegantEmojiPicker, searchResultFor prompt: String, fromAvailable: [EmojiSection]) -> [Emoji] {
        //     return ElegantEmojiPicker.getSearchResults(prompt, fromAvailable: fromAvailable)
        // }
        // func emojiPicker(_ picker: ElegantEmojiPicker, didStartPreview emoji: Emoji) {}
        // func emojiPicker(_ picker: ElegantEmojiPicker, didChangePreview emoji: Emoji, from: Emoji) {}
        // func emojiPicker(_ picker: ElegantEmojiPicker, didEndPreview emoji: Emoji) {}
        // func emojiPickerDidStartSearching(_ picker: ElegantEmojiPicker) {}
        // func emojiPickerDidEndSearching(_ picker: ElegantEmojiPicker) {}
        // func emojiPickerShouldDismissAfterSelection (_ picker: ElegantEmojiPicker) -> Bool { return true }
        // func emojiPicker (_ picker: ElegantEmojiPicker, loadEmojiSections withConfiguration: ElegantConfiguration, _ withLocalization: ElegantLocalization) -> [EmojiSection] {
        //     return ElegantEmojiPicker.getDefaultEmojiSections(config: withConfiguration, localization: withLocalization)
        // }
    }
}

@available(iOS 14.0, *)
struct EmojiPickerViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var selectedEmoji: Emoji?
    var detents: Set<AvailablePresentationDetent> = [.medium, .large]
    var configuration: ElegantConfiguration = ElegantConfiguration()
    var localization: ElegantLocalization = ElegantLocalization()

    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                ElegantEmojiPickerRepresentable(
                    isPresented: $isPresented,
                    selectedEmoji: $selectedEmoji,
                    configuration: configuration,
                    localization: localization
                )
                .ignoresSafeArea(.container, edges: .bottom)
                .withPresentationDetents(detents)
            }
    }
}

@available(iOS 14.0, *)
public extension View {
    func emojiPicker(
        isPresented: Binding<Bool>,
        selectedEmoji: Binding<Emoji?>,
        detents: Set<AvailablePresentationDetent> = [.medium, .large],
        configuration: ElegantConfiguration = ElegantConfiguration(),
        localization: ElegantLocalization = ElegantLocalization()
    ) -> some View {
        self.modifier(
            EmojiPickerViewModifier(
                isPresented: isPresented,
                selectedEmoji: selectedEmoji,
                detents: detents,
                configuration: configuration,
                localization: localization
            )
        )
    }
}


@available(iOS 14.0, *)
struct PresentationDetendsModifier: ViewModifier {
    let detents: Set<AvailablePresentationDetent>
    
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .presentationDetents(Set(detents.compactMap(\.systemDetent)))
        } else {
            content
        }
    }
}

@available(iOS 14.0, *)
extension View {
    func withPresentationDetents(_ detents: Set<AvailablePresentationDetent>) -> some View {
        self.modifier(PresentationDetendsModifier(detents: detents))
    }
}


@available(iOS 14.0, *)
public enum AvailablePresentationDetent: Hashable {
    case medium
    case large
    case fraction(CGFloat)
    case height(CGFloat)
    
    @available(iOS 16.0, *)
    var systemDetent: PresentationDetent {
        switch self {
        case .medium:
            return .medium
        case .large:
            return .large
        case .fraction(let value):
            return .fraction(value)
        case .height(let value):
            return .height(value)
        }
    }
}
