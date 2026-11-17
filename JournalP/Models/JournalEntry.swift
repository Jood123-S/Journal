import Foundation

struct JournalEntry: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var content: String
    var date: Date
    var isBookmarked: Bool = false
}
