import SwiftUI
import UniformTypeIdentifiers

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel
    @State private var showResetConfirmation = false
    @State private var showShareSheet = false
    @State private var csvData: String = ""
    @Environment(\.modelContext) private var modelContext
    
    init(sessionRepository: SessionRepository) {
        self._viewModel = StateObject(wrappedValue: SettingsViewModel(sessionRepository: sessionRepository))
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Notifications") {
                    Toggle("Weekly Review Reminders", isOn: $viewModel.notificationsEnabled)
                        .onChange(of: viewModel.notificationsEnabled) { _, enabled in
                            if enabled {
                                NotificationManager.shared.requestAuthorization()
                            } else {
                                NotificationManager.shared.cancelWeeklyReviewNotification()
                            }
                        }
                }
                
                Section("Data") {
                    Button(action: {
                        csvData = viewModel.exportCSV()
                        showShareSheet = true
                    }) {
                        HStack {
                            Text("Export to CSV")
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section {
                    Button(role: .destructive, action: {
                        showResetConfirmation = true
                    }) {
                        Text("Reset All Data")
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Reset All Data?", isPresented: $showResetConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    viewModel.resetAllData(modelContext: modelContext)
                }
            } message: {
                Text("This will permanently delete all your sessions and reviews. This action cannot be undone.")
            }
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: [csvData])
            }
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
