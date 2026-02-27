import SwiftUI

// MARK: - Mood Journal View
struct MoodJournalView: View {
    @State private var entries: [MoodEntry] = []
    @State private var showAddEntry = false
    @State private var selectedMood: MoodType = .calm
    @State private var noteText: String = ""
    @State private var selectedStress: StressLevel = .low
    @State private var animateList = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.calmNightSky, Color.calmDeepPurple.opacity(0.7), Color.calmMidPurple.opacity(0.4)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Mood Journal")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Spacer()
                        Button(action: { showAddEntry = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.calmLavender)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 16)

                    if entries.isEmpty {
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: "book.closed.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.calmWhite50)
                            Text("No entries yet")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(.calmWhite50)
                            Text("Tap + to log your first mood")
                                .font(.system(size: 14, weight: .regular, design: .rounded))
                                .foregroundColor(.calmWhite50.opacity(0.7))
                        }
                        Spacer()
                    } else {
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVStack(spacing: 12) {
                                ForEach(Array(entries.enumerated()), id: \.element.id) { index, entry in
                                    moodCell(entry: entry, index: index)
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 30)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddEntry) {
                addEntrySheet
            }
            .onAppear { animateList = true }
        }
    }

    private func moodCell(entry: MoodEntry, index: Int) -> some View {
        HStack(spacing: 14) {
            Text(entry.mood.emoji)
                .font(.system(size: 34))

            VStack(alignment: .leading, spacing: 4) {
                Text(entry.mood.rawValue)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                if !entry.note.isEmpty {
                    Text(entry.note)
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(.calmWhite70)
                        .lineLimit(2)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(.calmWhite50)
                Text(entry.stressLevel.rawValue)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(entry.stressLevel.color)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
        )
        .opacity(animateList ? 1 : 0)
        .offset(y: animateList ? 0 : 15)
        .animation(.calmStagger(index: index), value: animateList)
    }

    private var addEntrySheet: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.calmNightSky, Color.calmDeepPurple],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        Text("How are you feeling?")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.top, 20)

                        // Mood picker
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 14) {
                            ForEach(MoodType.allCases, id: \.rawValue) { mood in
                                VStack(spacing: 6) {
                                    Text(mood.emoji)
                                        .font(.system(size: 36))
                                    Text(mood.rawValue)
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(selectedMood == mood ? mood.color.opacity(0.3) : Color.white.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(selectedMood == mood ? mood.color : Color.clear, lineWidth: 2)
                                        )
                                )
                                .onTapGesture { selectedMood = mood }
                            }
                        }
                        .padding(.horizontal, 24)

                        // Stress picker
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Stress Level")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)

                            HStack(spacing: 10) {
                                ForEach(StressLevel.allCases, id: \.rawValue) { level in
                                    Text(level.rawValue)
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(selectedStress == level ? level.color.opacity(0.5) : Color.white.opacity(0.1))
                                        )
                                        .onTapGesture { selectedStress = level }
                                }
                            }
                        }
                        .padding(.horizontal, 24)

                        // Note
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Add a Note")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)

                            TextField("What's on your mind...", text: $noteText, axis: .vertical)
                                .font(.system(size: 15, design: .rounded))
                                .foregroundColor(.white)
                                .padding(16)
                                .frame(minHeight: 100, alignment: .topLeading)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                        )
                                )
                                .lineLimit(5...10)
                        }
                        .padding(.horizontal, 24)

                        // Save button
                        Button(action: saveEntry) {
                            Text("Save Entry")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                                .background(
                                    RoundedRectangle(cornerRadius: 27)
                                        .fill(LinearGradient.calmCTA)
                                )
                                .shadow(color: Color.calmDeepPurple.opacity(0.4), radius: 10, x: 0, y: 5)
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 30)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { showAddEntry = false }
                        .foregroundColor(.calmLavender)
                }
            }
        }
    }

    private func saveEntry() {
        let entry = MoodEntry(
            mood: selectedMood,
            stressLevel: selectedStress,
            note: noteText
        )
        entries.insert(entry, at: 0)
        noteText = ""
        showAddEntry = false
    }
}
