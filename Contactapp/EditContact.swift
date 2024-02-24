//
//  EditContact.swift
//  Contactapp
//
//  Created by Gaurav Kumar Dubey on 21/02/24.
//

import SwiftUI
import PhotosUI

// Editing the present contact
struct EditContact: View {
    @Binding var contact: Contact
    @Binding var contacts: [Contact]
    @Binding var avatarImage : UIImage?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var PhotosPickerItem : PhotosPickerItem?

    
    func saveContacts() {
        UserDefaults.standard.set(try? JSONEncoder().encode(contacts), forKey: "savedContacts")
    }
    
    var body: some View {
        
        NavigationView {
            Form {
                Section(header: Text("Personal info")) {
                    //PhotoPicker
                    VStack {
                        Spacer()
                        
                        HStack(){
                            Spacer()
                            PhotosPicker(selection: $PhotosPickerItem, matching: .images) {
                                Image(uiImage: avatarImage ?? UIImage(systemName: "person.circle") ?? UIImage())
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            }
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                    .onChange(of: PhotosPickerItem) { _, _ in
                        Task{
                            if let PhotosPickerItem{
                                let data = try? await PhotosPickerItem.loadTransferable(type: Data.self)
                                if let image = UIImage(data:data!){
                                    avatarImage = image
                                }
                            }
                        }
                    }
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
