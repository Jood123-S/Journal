import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: JournalViewModel
    @State private var isAddingJournal = false
    @State private var entryToEdit: JournalEntry? = nil
    @State private var entryToDelete: JournalEntry? = nil
    @State private var showDeleteAlert = false
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header Bar
                HStack(alignment: .center) {
                    Text("Journal")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.appTextPrimary)
                    
                    Spacer()
                    
                    // Filter & Plus Pill Container
                    HStack(spacing: 20) {
                        Menu {
                            Button("Sort by Bookmark") {
                                viewModel.filterOption = .bookmarked
                            }
                            Button("Sort by Entry Date") {
                                viewModel.filterOption = .date
                            }
                            Button("Show All") {
                                viewModel.filterOption = .none
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.appTextAccent)
                        }

                        Button {
                            isAddingJournal = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.appTextAccent)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.appSurfaceCard)
                    .clipShape(Capsule())
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 10)
                
                // MARK: - Main Content Area
                ZStack {
                    if viewModel.entries.isEmpty {
                        // Empty State View
                        VStack(spacing: 16) {
                            Spacer()
                            Image("secp")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 140, height: 140)
                            
                            Text("Begin Your Journal")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.appTextAccent)
                            
                            Text("Craft your personal diary, tap the plus icon to begin")
                                .font(.system(size: 14))
                                .foregroundColor(.appTextSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                            Spacer()
                        }
                    } else {
                        // Journal Cards List
                        List {
                            ForEach(viewModel.filteredEntries) { entry in
                                JournalRowCard(entry: entry) {
                                    viewModel.toggleBookmark(for: entry)
                                }
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                .onTapGesture {
                                    entryToEdit = entry
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        entryToDelete = entry
                                        showDeleteAlert = true
                                    } label: {
                                        Label("Delete", systemImage: "trash.fill")
                                    }
                                    .tint(.appDestructive)
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                    
                    // MARK: - Floating Bottom Search Bar
                    VStack {
                        Spacer()
                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.appTextSecondary)
                            
                            TextField("Search", text: $viewModel.searchText)
                                .foregroundColor(.appTextPrimary)
                                .tint(.appPrimary)
                            
                            if !viewModel.searchText.isEmpty {
                                Button {
                                    viewModel.searchText = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.appTextSecondary)
                                }
                            }
                            
                            Image(systemName: "mic.fill")
                                .foregroundColor(.appTextSecondary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.appSurfaceCard)
                        .clipShape(Capsule())
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                    }
                }
            }
        }
        .sheet(isPresented: $isAddingJournal) {
            AddEditJournalView(mode: .add)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .preferredColorScheme(.dark)
        }
        .sheet(item: $entryToEdit) { entry in
            AddEditJournalView(mode: .edit(entry))
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .preferredColorScheme(.dark)
        }
        .alert("Delete Journal?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let entry = entryToDelete {
                    viewModel.deleteEntry(entry)
                }
            }
        } message: {
            Text("Are you sure you want to delete this journal?")
        }
    }
}

// MARK: - Journal Card Component
struct JournalRowCard: View {
    let entry: JournalEntry
    let onBookmarkToggle: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Text(entry.title)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.appTextAccent)
                Spacer()
                Button(action: onBookmarkToggle) {
                    Image(systemName: entry.isBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 18))
                        .foregroundColor(.appTextAccent)
                }
                .buttonStyle(.plain)
            }
            
            Text(entry.date.formatted(date: .numeric, time: .omitted))
                .font(.system(size: 14))
                .foregroundColor(.appTextSecondary)
            
            Text(entry.content)
                .font(.system(size: 16))
                .foregroundColor(.appTextPrimary)
                .lineLimit(3)
        }
        .padding(20)
        .background(Color.appSurfaceCard)
        .cornerRadius(24)
    }
}
