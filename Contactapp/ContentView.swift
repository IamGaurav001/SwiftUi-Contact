import SwiftUI

struct Contact: Identifiable, Codable {
    var id = UUID()
    var name: String
    var email: String
    var phoneNumber: String
}

struct ContentView: View {
    @State private var searchText = ""
    @State private var isAddingContact = false
    @State private var contacts: [Contact] = [
        Contact(name: "Roy Kent", email: "roykent@gmail.com", phoneNumber: "7656478998"),
        Contact(name: "Richard Montlaur", email: "richardmontlaur@gmail.com", phoneNumber: "8678788698"),
        Contact(name: "Dani Rojas", email: "danirojas@gmail.com", phoneNumber: "8756446878"),
        Contact(name: "Jamie Tartt", email: "jamietartt@gmail.com", phoneNumber: "8675785767"),
        Contact(name: "Roy Kent", email: "roykent@gmail.com", phoneNumber: "7656478998"),
        Contact(name: "Richard Montlaur", email: "richardmontlaur@gmail.com", phoneNumber: "8678788698"),
        Contact(name: "Dani Rojas", email: "danirojas@gmail.com", phoneNumber: "8756446878"),
        Contact(name: "Jamie Tartt", email: "jamietartt@gmail.com", phoneNumber: "8675785767")
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
    }
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
    @Binding var contact: Contact
    @Binding var contacts: [Contact]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal info")) {
                    TextField("Name", text: $contact.name).padding(3)
                    TextField("Email id", text: $contact.email).padding(3)
                    TextField("Phone Number", text: $contact.phoneNumber).padding(3)
                }
            }
            .navigationBarTitle("Edit Contact", displayMode: .inline)
            .toolbar {
                Button {
                    if let index = contacts.firstIndex(where: { $0.id == contact.id }) {
                        contacts[index] = contact
                    }
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
    @State private var editedContact: Contact
    
    init(contact: Contact, contacts: Binding<[Contact]>) {
        self.contact = contact
        self._contacts = contacts
        self._editedContact = State(initialValue: contact)
    }

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
                .sheet(isPresented: $isEditingContact) {
                    EditContact(contact: $editedContact, contacts: $contacts)
                }
            }
            }
        }
    }



#Preview {
    ContentView()
}
