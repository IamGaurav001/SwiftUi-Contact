// NewContact.swift
//  Contactapp
//  Created by Gaurav Kumar Dubey on 21/02/24.

import SwiftUI
import PhotosUI

// Adding new contacts
struct NewContact: View {
    @State private var firstName = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @Binding var contacts: [Contact]
    @State private var PhotosPickerItem : PhotosPickerItem?
    @Binding var avatarImage : UIImage?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showAlert = false
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
                        showAlert = true
                        return
                    }
                    let newContact = Contact(name: firstName, email: email, phoneNumber: phoneNumber)
                    contacts.append(newContact)
                    self.presentationMode.wrappedValue.dismiss()
                    saveContacts()
                    
                } label: {
                    Label("Save", systemImage: "square.and.arrow.up")
                }
            }.alert(isPresented: $showAlert) {
                Alert(title: Text("Add data"), message: Text("Please enter a name and phone number."), dismissButton: .default(Text("OK")))
            }
        }
    }
}
#Preview {
    ContentView()
}
