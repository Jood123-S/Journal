import SwiftUI

struct AddEditJournalView: View {
    enum Mode {
        case add
        case edit(JournalEntry)
    }
    
    let mode: Mode
    @EnvironmentObject var viewModel: JournalViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var initialTitle: String = ""
    @State private var initialContent: String = ""
    @State private var showDiscardAlert = false
    
    @FocusState private var isTitleFocused: Bool
    
    var hasChanges: Bool {
        title != initialTitle || content != initialContent
    }
    
    var isSaveDisabled: Bool {
        title.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                // MARK: - Header Actions
                HStack {
                    Button {
                        if hasChanges {
                            showDiscardAlert = true
                        } else {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.appTextPrimary)
                            .frame(width: 36, height: 36)
                            .background(Color.appSurfaceCard)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button {
                        saveEntry()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .frame(width: 36, height: 36)
                            .background(isSaveDisabled ? Color.appPrimary.opacity(0.4) : Color.appPrimary)
                            .clipShape(Circle())
                    }
                    .disabled(isSaveDisabled)
                }
                .padding(.top, 12)
                
                // MARK: - Title Input
                TextField("Title", text: $title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.appTextPrimary)
                    .tint(.appPrimary)
                    .focused($isTitleFocused)
                
                // MARK: - Date Label
                Text(Date().formatted(date: .numeric, time: .omitted))
                    .font(.system(size: 14))
                    .foregroundColor(.appTextSecondary)
                
                // MARK: - Text Content Editor
                ZStack(alignment: .topLeading) {
                    if content.isEmpty {
                        Text("Type your Journal...")
                            .font(.system(size: 16))
                            .foregroundColor(Color.appTextSecondary.opacity(0.5))
                            .padding(.top, 8)
                            .padding(.leading, 4)
                    }
                    
                    TextEditor(text: $content)
                        .font(.system(size: 16))
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .foregroundColor(.appTextPrimary)
                        .tint(.appPrimary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .onAppear {
            if case .edit(let entry) = mode {
                title = entry.title
                content = entry.content
                initialTitle = entry.title
                initialContent = entry.content
            } else {
                isTitleFocused = true
            }
        }
        .alert("Are you sure you want to discard changes on this journal?", isPresented: $showDiscardAlert) {
            Button("Discard Changes", role: .destructive) {
                dismiss()
            }
            Button("Keep Editing", role: .cancel) { }
        }
    }
    
    private func saveEntry() {
        switch mode {
        case .add:
            viewModel.addEntry(title: title, content: content)
        case .edit(let entry):
            viewModel.updateEntry(entry, title: title, content: content)
        }
        dismiss()
    }
}
