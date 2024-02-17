import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var isAddingContact = false
    @State private var contacts: [Contact] = []
    @State private var isDetailViewPresented = false // Initialize here
    
    init() {
        let storedContacts = loadContacts()
        self._contacts = State(initialValue: storedContacts)
    }
    
    func loadContacts() -> [Contact] {
        guard let data = UserDefaults.standard.data(forKey: "ContactList") else {
            return []
        }
        do {
            let decoded = try JSONDecoder().decode([Contact].self, from: data)
            return decoded
        } catch {
            print("Error decoding contacts data: \(error)")
            return []
        }
    }
    
    func saveContacts() {
        do {
            let encoded = try JSONEncoder().encode(contacts)
            UserDefaults.standard.set(encoded, forKey: "ContactList")
        } catch {
            print("Error encoding contacts data: \(error)")
        }
    }
    
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
        }
        .onDisappear {
            saveContacts()
        }
    }
    
    func deleteContact(at offsets: IndexSet) {
        contacts.remove(atOffsets: offsets)
    }
}

struct Contact: Identifiable, Codable {
    var id = UUID()
    var name: String
    var email: String
    var phoneNumber: String
}

struct NewContact: View {
    @State private var firstName = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @Binding var contacts: [Contact]
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal info")) {
                    TextField("Name", text: $firstName).padding(3)
                    TextField("Email id", text: $email).padding(3)
                    TextField("Phone Number", text: $phoneNumber).padding(3)
                }
            }
            .navigationBarTitle("New Contact", displayMode: .inline)
            .toolbar {
                Button {
                    guard !firstName.isEmpty, !phoneNumber.isEmpty else {
                        print("Please enter a name and phone number.")
                        return
                    }
                    
                    let newContact = Contact(name: firstName, email: email, phoneNumber: phoneNumber)
                    contacts.append(newContact)
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Label("Save", systemImage: "square.and.arrow.up")
                }
            }
        }
    }
}

struct EditContact: View {
    @State private var editedContact: Contact
    var onSave: () -> Void // Closure to handle save action

    init(contact: Contact, onSave: @escaping () -> Void) {
        self._editedContact = State(initialValue: contact)
        self.onSave = onSave
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal info")) {
                    TextField("Name", text: $editedContact.name).padding(3)
                    TextField("Email id", text: $editedContact.email).padding(3)
                    TextField("Phone Number", text: $editedContact.phoneNumber).padding(3)
                }
            }
            .navigationBarTitle("Edit Contact", displayMode: .inline)
            .toolbar {
                Button {
                    onSave() // Call the onSave closure to handle the save action
                } label: {
                    Label("Save", systemImage: "square.and.arrow.up")
                }
            }
        }

    }
}

struct DetailView: View {
    var contact: Contact
    @Binding var contacts: [Contact]
    @State private var isEditingContact = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal info")) {
                    Text("Name: \(contact.name)")
                    Text("Email: \(contact.email)")
                    Text("Phone Number: \(contact.phoneNumber)")
                }
            }
            .navigationBarTitle("Contact Details", displayMode: .inline)
            .toolbar {
                Button {
                    isEditingContact = true
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
            }
            .sheet(isPresented: $isEditingContact) {
                EditContact(contact: contact) {
                    // Handle save action here
                    // For example, update the contacts array or save the edited contact to UserDefaults
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
