//
//  Constants.swift
//  FinalProjectV3
//
//  Created by Thanawat Sriwanlop on 6/11/2565 BE.
//

import UIKit

struct Constants {
    
    // MARK: - variables
    static var hasTopNotch: Bool {
        // เปลี่ยนเป็น 11 ไหม?
        guard #available(iOS 16, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        return window.safeAreaInsets.top >= 44
    }
}

