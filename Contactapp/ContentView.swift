import SwiftUI

//initailizing the variables
struct Contact: Identifiable, Codable {
    var id = UUID()
    var name: String
    var email: String
    var phoneNumber: String
}

// Main View
struct ContentView: View {
    @State private var searchText = ""
    @State private var isAddingContact = false
    @State private var contacts: [Contact] = [
        Contact(name: "Roy Kent", email: "roykent@gmail.com", phoneNumber: "7656478998"),
        Contact(name: "Richard Montlaur", email: "richardmontlaur@gmail.com", phoneNumber: "8678788698"),
        Contact(name: "Dani Rojas", email: "danirojas@gmail.com", phoneNumber: "8756446878")
        ]
      
    var filteredContacts: [Contact] {
        searchText.isEmpty ? contacts : contacts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredContacts, id: \.id) { contact in
                    NavigationLink(destination: DetailView(contact: contact, contacts: $contacts)) {
                        Text(contact.name)
                    }
                }
                .onDelete(perform: deleteContact)
            }
            .searchable(text: $searchText, placement: .automatic, prompt: "Search Contacts")
            .navigationBarTitle("Contacts", displayMode: .inline)
            .toolbar {
                Button {
                    isAddingContact = true
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
            .sheet(isPresented: $isAddingContact) {
                NewContact(contacts: $contacts)
            }
            .onAppear {
                showContacts()
            }
        }
    }
    func saveContacts() {
        UserDefaults.standard.set(try? JSONEncoder().encode(contacts), forKey: "savedContacts")
    }
    func showContacts() {
        if let storedData = UserDefaults.standard.data(forKey: "savedContacts"),
           let decodedContacts = try? JSONDecoder().decode([Contact].self, from: storedData) {
            contacts = decodedContacts
        }
    }

    func deleteContact(at offsets: IndexSet) {
            contacts.remove(atOffsets: offsets)
            saveContacts()
        }
}


#Preview {
    ContentView()
}
