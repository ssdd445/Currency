import Network
import Foundation

public class Reachability {
    static let shared = Reachability()
    
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    var isConnected: Bool {
        return monitor.currentPath.status == .satisfied
    }
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                print("No connection.")
            }
            
            // Post notification or perform other actions as needed
            // NotificationCenter.default.post(name: .reachabilityChanged, object: nil)
        }
        
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
