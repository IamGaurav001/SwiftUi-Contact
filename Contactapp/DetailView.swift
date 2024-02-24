//
//  DetailView.swift
//  Contactapp
//
//  Created by Gaurav Kumar Dubey on 21/02/24.
//

import SwiftUI
import PhotosUI

// Detail view of the contact
struct DetailView: View {
    var contact: Contact
    @Binding var contacts: [Contact]
    @State private var isEditingContact = false
    @State private var editedContact: Contact
    @State private var PhotosPickerItem : PhotosPickerItem?
    @State private var avatarImage : UIImage?
    
    init(contact: Contact, contacts: Binding<[Contact]>) {
        self.contact = contact
        self._contacts = contacts
        self._editedContact = State(initialValue: contact)
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Personal info")) {
                    //PhotoPicker
                    VStack {
                        Spacer()
                        HStack(){
                            Spacer()
                                Image(uiImage: avatarImage ?? UIImage(systemName: "person.circle") ?? UIImage())
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            Spacer()
                            }
                            Spacer()
                        }
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
                    EditContact(contact: $editedContact, contacts: $contacts, avatarImage: $avatarImage)
                }
            }
        }
    }
}


    
#Preview {
    ContentView()
}
