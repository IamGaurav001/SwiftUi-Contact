//
//  NewContact.swift
//  Contactapp
//
//  Created by Gaurav Kumar Dubey on 21/02/24.
//

import SwiftUI
import PhotosUI

// Adding new contacts
struct NewContact: View {
    @State private var firstName = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @Binding var contacts: [Contact]
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    func saveContacts() {
        UserDefaults.standard.set(try? JSONEncoder().encode(contacts), forKey: "savedContacts")
    }
    
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
                   saveContacts()
                } label: {
                    Label("Save", systemImage: "square.and.arrow.up")
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
