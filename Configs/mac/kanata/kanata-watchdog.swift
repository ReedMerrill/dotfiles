import Foundation

// Kanata Watchdog
// Listens for screen unlock events and restarts kanata automatically.

let center = DistributedNotificationCenter.default()
let scriptPath = "/Users/reed/kanata/kanata"

center.addObserver(forName: NSNotification.Name("com.apple.screenIsUnlocked"), object: nil, queue: .main) { _ in
    let now = Date()
    let formatter = DateFormatter()
    formatter.timeStyle = .medium
    print("[\(formatter.string(from: now))] Screen unlocked! Triggering kanata restart...")
    
    let task = Process()
    task.executableURL = URL(fileURLWithPath: "/bin/bash")
    task.arguments = [scriptPath, "restart"]
    
    do {
        try task.run()
    } catch {
        print("Failed to run restart command: \(error)")
    }
}

print("Kanata Watchdog is active. Listening for unlock notifications...")
print("Press Ctrl+C to stop.")
RunLoop.main.run()
