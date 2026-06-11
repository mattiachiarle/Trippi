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
        NavigationStack {
            List {
                ForEach(trips) { trip in
                    NavigationLink(value: trip) {
                        VStack(alignment: .leading) {
                            Text(trip.name)
                            Text("\((trip.startDate..<trip.endDate).formatted(date: .abbreviated, time: .omitted))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteTrips)
            }
            .navigationDestination(for: Trip.self) { trip in TripCalendarView(trip: trip) }
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
