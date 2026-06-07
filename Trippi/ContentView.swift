//
//  ContentView.swift
//  Trippi
//
//  Created by Mattia Chiarle on 06/06/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Trip.startDate) private var trips: [Trip]
    @State private var showingAddTrip = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(trips) { trip in
                    NavigationLink {
                        Text("\(trip.name) \(trip.startDate, format: Date.FormatStyle(date: .numeric, time: .standard))-\(trip.endDate, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        VStack(alignment: .leading) {
                            Text(trip.name)
                            Text(trip.startDate, format: Date.FormatStyle(date: .abbreviated))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteTrips)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button { showingAddTrip = true } label: {
                        Label("Add Trip", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTrip) {
                AddTripView()
            }
        } detail: {
            Text("Select a trip")
        }
    }

    private func deleteTrips(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(trips[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Trip.self, inMemory: true)
}
