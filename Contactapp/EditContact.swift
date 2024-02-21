//
//  EditContact.swift
//  Contactapp
//
//  Created by Gaurav Kumar Dubey on 21/02/24.
//

import SwiftUI

// Editing the present contact
struct EditContact: View {
    @Binding var contact: Contact
    @Binding var contacts: [Contact]
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    func saveContacts() {
        UserDefaults.standard.set(try? JSONEncoder().encode(contacts), forKey: "savedContacts")
    }
    
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
                    self.presentationMode.wrappedValue.dismiss()
                    saveContacts()
                }
            label: {
                    Label("Save", systemImage: "square.and.arrow.up")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
