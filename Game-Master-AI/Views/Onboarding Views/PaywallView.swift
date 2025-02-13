//
//  PaywallView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 13/02/2025.
//

import SwiftUI

struct PaywallView: View {
    let hasTrial: Bool

    init(hasTrial: Bool) {
        self.hasTrial = hasTrial
    }

    var body: some View {
        Text("Paywall")
    }
}
