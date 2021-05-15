import SwiftUI

public struct FloatingTextField: View {

    // Environments
    @Environment(\.font) private var fontEnvironment: Font?

    // Properties
    @Binding
    private var text: String
    private let placeholder: String

    // Styling
    private var color: Color = .black
    private var lineColor: Color = .blue

    // Actions
    private var onEditingChanged: (Bool) -> Void
    private var onCommit: () -> Void

    public init(
        text: Binding<String>,
        placeholder: String = "",
        color: Color = .black,
        lineColor: Color = .accentColor,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = {}
    ) {
        self._text = text
        self.placeholder = placeholder
        self.color = color
        self.lineColor = lineColor
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
    }

    // Animated layout variables
    @State private var size: CGSize?

    public var body: some View {
        VStack(spacing: 3) {
            ZStack(alignment: .leading) {
                Text(placeholder)
                    .font(fontEnvironment)
                    .fixedSize()
                    .foregroundColor(color.opacity(0.5))
                    .scaleEffect(text.isEmpty ? 1 : 0.7, anchor: .leading)
                    .offset(y: text.isEmpty ? 0 : -(size?.height ?? 0))
                    .animation(Animation.interpolatingSpring(stiffness: 10, damping: 4).speed(4))

                TextField(
                    "",
                    text: $text,
                    onEditingChanged: onEditingChanged,
                    onCommit: onCommit
                    )
                .foregroundColor(color)
                .onSizeChange { self.size = $0 }
            }

            Rectangle()
                .foregroundColor(lineColor)
                .frame(height: 2, alignment: .leading)
                .scaleEffect(x: text.isEmpty ? 0 : 1, y: 1, anchor: .leading)
                .animation(.linear)
        }
    }
}

struct ContentView: View {
    @State var text = ""

    var body: some View {
        FloatingTextField(
            text: $text,
            placeholder: "Placeholder text",
            color: .black,
            lineColor: .blue,
            onEditingChanged: { print("editing changed", $0) },
            onCommit: { print("commit") }
        )
        .font(.callout)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewLayout(.sizeThatFits)
    }
}
