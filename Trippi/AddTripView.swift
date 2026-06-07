//
//  AddTripView.swift
//  Trippi
//
//  Created by Mattia Chiarle on 07/06/2026.
//

import SwiftUI
import SwiftData

struct AddTripView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var startDate: Date = Date.now
    @State private var endDate: Date = Date.now

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                    DatePicker("Start date", selection: $startDate, displayedComponents: [.date])
                    DatePicker("End date", selection: $endDate, displayedComponents: [.date])
                }
            }
            .navigationTitle("Add trip")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        modelContext.insert(Trip(name: name, startDate: startDate, endDate: endDate))
                        dismiss()
                    }.buttonStyle(.borderedProminent).disabled(!Trip.isValid(name: name, startDate: startDate, endDate: endDate))
                }
            }
        }
    }
}

#Preview {
    AddTripView()
        .modelContainer(for: Trip.self, inMemory: true)
}
