import Foundation

extension UserDefaults {
    var latestColorPickerID: String? {
        get { self.string(forKey: #function) }
        set { self.set(newValue, forKey: #function) }
    }
    
    private enum Keys {
        static let userData = "userData"
    }
    
//    func saveUserData(_ userData: UserData) {
//        if let encoded = try? JSONEncoder().encode(userData) {
//            set(encoded, forKey: Keys.userData)
//        }
//    }
//    
//    func loadUserData() -> UserData? {
//        if let savedData = data(forKey: Keys.userData),
//           let decoded = try? JSONDecoder().decode(UserData.self, from: savedData) {
//            return decoded
//        }
//        return nil
//    }
    
    func clearUserData() {
        removeObject(forKey: Keys.userData)
    }
}
