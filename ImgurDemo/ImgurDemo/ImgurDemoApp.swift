//
//  ImgurDemoApp.swift
//  ImgurDemo
//
//  Created by Marta on 13/5/24.
//

import SwiftUI

@main
struct ImgurDemoApp: App {
    var body: some Scene {
        WindowGroup {
            InitialViewInjection().resolve()
        }
    }
}
