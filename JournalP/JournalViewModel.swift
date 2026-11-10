import Foundation
import SwiftUI
import Combine

// MARK: - Hex Color Extensions
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: 1.0)
    }
    
    static let appPrimary = Color(hex: "7F81FF")          // Primary / Accent (#7F81FF)
    static let appTextAccent = Color(hex: "AF99FD")       // Text / Accent (#AF99FD)
    static let appTextPrimary = Color(hex: "FFFFFF")      // Text / Primary (#FFFFFF)
    static let appTextSecondary = Color(hex: "A39A9A")    // Text / Secondary (#A39A9A)
    static let appSurfaceCard = Color(hex: "1C1C1E")      // Surface / Card (#1C1C1E)
    static let appBackground = Color(hex: "000000")       // Background / Primary (#000000)
    static let appDestructive = Color(hex: "FD453C")      // Semantic / Destructive (#FD453C)
}

// MARK: - Data Model
struct JournalEntry: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var content: String
    var date: Date
    var isBookmarked: Bool = false
}

// MARK: - ViewModel
class JournalViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = []
    @Published var searchText: String = ""
    @Published var filterOption: FilterOption = .none
    
    enum FilterOption {
        case none
        case bookmarked
        case date
    }
    
    var filteredEntries: [JournalEntry] {
        let searched = entries.filter { entry in
            searchText.isEmpty ||
            entry.title.localizedCaseInsensitiveContains(searchText) ||
            entry.content.localizedCaseInsensitiveContains(searchText)
        }
        
        switch filterOption {
        case .none:
            return searched.sorted(by: { $0.date > $1.date })
        case .bookmarked:
            return searched.filter { $0.isBookmarked }.sorted(by: { $0.date > $1.date })
        case .date:
            return searched.sorted(by: { $0.date > $1.date })
        }
    }
    
    func addEntry(title: String, content: String) {
        let newEntry = JournalEntry(title: title, content: content, date: Date())
        entries.insert(newEntry, at: 0)
    }
    
    func updateEntry(_ entry: JournalEntry, title: String, content: String) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index].title = title
            entries[index].content = content
        }
    }
    
    func deleteEntry(_ entry: JournalEntry) {
        entries.removeAll(where: { $0.id == entry.id })
    }
    
    func toggleBookmark(for entry: JournalEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index].isBookmarked.toggle()
        }
    }
}
