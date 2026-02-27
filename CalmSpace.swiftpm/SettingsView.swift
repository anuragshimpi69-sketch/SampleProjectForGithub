import SwiftUI

// MARK: - Settings View
struct SettingsView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true
    @AppStorage("userName") private var userName: String = ""
    @AppStorage("userSurname") private var userSurname: String = ""
    @State private var notificationsEnabled = true
    @State private var hapticFeedback = true
    @State private var darkModeOverride = false
    @State private var dailyReminder = true
    @State private var reminderTime = Date()
    @State private var showRestartAlert = false
    @State private var showProfileEdit = false

    private var displayName: String {
        let full = "\(userName) \(userSurname)".trimmingCharacters(in: .whitespaces)
        return full.isEmpty ? "CalmSpace User" : full
    }

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color.calmNightSky,
                    Color.calmDeepPurple.opacity(0.8),
                    Color.calmMidPurple.opacity(0.5),
                    Color.calmDeepPurple.opacity(0.9)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    // ── Header ──
                    Text("Settings")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 20)

                    // ── Profile Card (tappable) ──
                    Button(action: { showProfileEdit = true }) {
                        HStack(spacing: 16) {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.calmMidPurple, .calmDeepPurple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 56, height: 56)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 24))
                                )

                            VStack(alignment: .leading, spacing: 4) {
                                Text(displayName)
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                                Text("Tap to edit profile ✏️")
                                    .font(.system(size: 13, weight: .regular, design: .rounded))
                                    .foregroundColor(.white.opacity(0.6))
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.4))
                        }
                        .padding(20)
                        .background(settingsCardBG)
                    }
                    .padding(.horizontal, 24)

                    // ── Preferences Section ──
                    VStack(alignment: .leading, spacing: 0) {
                        sectionHeader("Preferences")

                        settingsToggle(icon: "bell.fill", iconColor: .calmMidPurple, title: "Notifications", isOn: $notificationsEnabled)
                        settingsDivider
                        settingsToggle(icon: "iphone.radiowaves.left.and.right", iconColor: .calmButtonBlueStart, title: "Haptic Feedback", isOn: $hapticFeedback)
                        settingsDivider
                        settingsToggle(icon: "moon.fill", iconColor: .indigo, title: "Dark Mode", isOn: $darkModeOverride)
                    }
                    .padding(20)
                    .background(settingsCardBG)
                    .padding(.horizontal, 24)

                    // ── Reminders Section ──
                    VStack(alignment: .leading, spacing: 0) {
                        sectionHeader("Daily Reminder")

                        settingsToggle(icon: "clock.fill", iconColor: .orange, title: "Daily Check-in", isOn: $dailyReminder)

                        if dailyReminder {
                            settingsDivider

                            HStack {
                                HStack(spacing: 10) {
                                    Image(systemName: "alarm.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(.calmButtonGreenStart)
                                        .frame(width: 30, height: 30)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.calmButtonGreenStart.opacity(0.2))
                                        )
                                    Text("Reminder Time")
                                        .font(.system(size: 15, weight: .medium, design: .rounded))
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .tint(.calmMidPurple)
                            }
                            .padding(.top, 12)
                        }
                    }
                    .padding(20)
                    .background(settingsCardBG)
                    .padding(.horizontal, 24)
                    .animation(.easeInOut(duration: 0.3), value: dailyReminder)

                    // ── About Section ──
                    VStack(alignment: .leading, spacing: 0) {
                        sectionHeader("About")

                        settingsRow(icon: "info.circle.fill", iconColor: .calmButtonBlueStart, title: "Version", trailing: "1.0.0")
                        settingsDivider
                        settingsRow(icon: "lock.shield.fill", iconColor: .green, title: "Privacy", trailing: "On-Device")
                        settingsDivider
                        settingsRow(icon: "doc.text.fill", iconColor: .calmLavender, title: "App", trailing: "CalmSpace")
                    }
                    .padding(20)
                    .background(settingsCardBG)
                    .padding(.horizontal, 24)

                    // ── Restart ──
                    Button(action: { showRestartAlert = true }) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 15, weight: .medium))
                            Text("Restart")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(.red.opacity(0.9))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.red.opacity(0.15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                    .padding(.horizontal, 24)

                    // Footer
                    Text("100% Private & On-Device")
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.35))
                        .padding(.top, 8)
                        .padding(.bottom, 30)
                }
            }
        }
        .alert("Restart App?", isPresented: $showRestartAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Restart", role: .destructive) {
                // Clear all user data and go back to onboarding
                userName = ""
                userSurname = ""
                hasCompletedOnboarding = false
            }
        } message: {
            Text("This will clear your profile and restart the app from the welcome screen.")
        }
        .sheet(isPresented: $showProfileEdit) {
            ProfileEditSheet(userName: $userName, userSurname: $userSurname)
        }
    }

    // MARK: - Components

    private var settingsCardBG: some View {
        RoundedRectangle(cornerRadius: 22)
            .fill(Color.white.opacity(0.08))
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
            .shadow(color: Color.calmMidPurple.opacity(0.08), radius: 8, x: 0, y: 4)
    }

    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 13, weight: .semibold, design: .rounded))
            .foregroundColor(.white.opacity(0.5))
            .textCase(.uppercase)
            .tracking(0.5)
            .padding(.bottom, 14)
    }

    private func settingsToggle(icon: String, iconColor: Color, title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(iconColor)
                    .frame(width: 30, height: 30)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(iconColor.opacity(0.2))
                    )
                Text(title)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
            }
            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(.calmMidPurple)
        }
    }

    private func settingsRow(icon: String, iconColor: Color, title: String, trailing: String) -> some View {
        HStack {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(iconColor)
                    .frame(width: 30, height: 30)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(iconColor.opacity(0.2))
                    )
                Text(title)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
            }
            Spacer()
            Text(trailing)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(.white.opacity(0.5))
        }
    }

    private var settingsDivider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.1))
            .frame(height: 1)
            .padding(.vertical, 12)
            .padding(.leading, 40)
    }
}

// MARK: - Profile Edit Sheet
struct ProfileEditSheet: View {
    @Binding var userName: String
    @Binding var userSurname: String
    @Environment(\.dismiss) private var dismiss
    @State private var editName: String = ""
    @State private var editSurname: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.calmNightSky, Color.calmDeepPurple],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 30) {
                    // Avatar
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.calmMidPurple, .calmDeepPurple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 36))
                        )
                        .padding(.top, 30)

                    Text("Edit Profile")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    // Name field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("First Name")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))

                        TextField("Enter your name", text: $editName)
                            .font(.system(size: 16, design: .rounded))
                            .foregroundColor(.white)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.white.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                    }
                    .padding(.horizontal, 30)

                    // Surname field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Surname")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))

                        TextField("Enter your surname", text: $editSurname)
                            .font(.system(size: 16, design: .rounded))
                            .foregroundColor(.white)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.white.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                    }
                    .padding(.horizontal, 30)

                    // Save button
                    Button(action: {
                        userName = editName
                        userSurname = editSurname
                        dismiss()
                    }) {
                        Text("Save")
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

                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.calmLavender)
                }
            }
        }
        .onAppear {
            editName = userName
            editSurname = userSurname
        }
    }
}
