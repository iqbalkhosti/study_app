import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel: HistoryViewModel
    @State private var selectedSession: FocusSession?
    
    init(sessionRepository: SessionRepository) {
        self._viewModel = StateObject(wrappedValue: HistoryViewModel(sessionRepository: sessionRepository))
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.sessions.isEmpty {
                    emptyState
                } else {
                    sessionList
                }
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        WeeklyReviewListView()
                    } label: {
                        Text("Reviews")
                    }
                }
            }
            .sheet(item: $selectedSession) { session in
                SessionDetailView(session: session)
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock.badge.xmark")
                .font(.system(size: 64))
                .foregroundColor(.secondary)
            
            Text("No Sessions Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Start your first focus session to see it here")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    private var sessionList: some View {
        List {
            ForEach(viewModel.groupedSessions, id: \.date) { group in
                Section {
                    ForEach(group.sessions, id: \.id) { session in
                        SessionCard(session: session)
                            .onTapGesture {
                                selectedSession = session
                            }
                    }
                } header: {
                    Text(group.date, style: .date)
                        .font(.headline)
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}
