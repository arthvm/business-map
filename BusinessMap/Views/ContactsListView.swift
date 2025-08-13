//
//  ContactsListView.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 13/08/25.
//

import SwiftUI

struct ContactsListView: View {
    @Binding var searchText: String
    
    @Environment(\.isSearching) private var searching
    @Binding var sheetDetent: PresentationDetent
    
    let letters = (65...90).map { String(UnicodeScalar($0)!) }
    let contacts = [
        "Marcos", "Helena", "Vinícius", "Priscila", "Eduardo", "Melissa", "Rogério",
        "Tainá", "Felipe", "Lorena", "Carla", "André", "Beatriz", "Luís", "Jéssica",
        "Sérgio", "Paula", "César", "Camila", "Valentina", "Renato", "Júlio",
        "Clarice", "Otávio", "Bianca", "Gustavo", "Larissa", "Antônio", "Débora",
        "Mateus", "Isabela", "Alexandre", "Natália", "Marcela", "João", "Letícia",
        "Patrick", "Cláudia", "Rafael", "Carolina", "Douglas", "Patrícia", "Roberto",
        "Fernanda", "Leandro", "Sílvia", "Marcelo", "Marta", "Hugo", "Tatiane",
        "Ricardo", "Emanuelle", "Fabrício", "Samantha", "Bruno", "Viviane", "Álvaro",
        "Simone", "Diego", "Gabriela", "Maurício", "Tatiana", "Nicolas", "Juliana",
        "Luiz", "Rafaela", "Fernando", "Catarina", "Márcio", "Michele", "Samuel",
        "Verônica", "Igor", "Érica", "Paulo", "Aline", "Caetano", "Rita", "Leila",
        "Adriano", "Cléo", "Elias", "Silvana", "Renan", "Mirian", "Túlio", "Daniela",
        "Cristiano", "Isis", "Pedro", "Andressa", "Jonas", "Lúcia", "Sebastião",
        "Clarisse", "Enzo", "Tatiana", "Rian", "Eduarda", "Rodolfo", "Vanessa",
        "Tiago", "Regina", "Alessandro", "Lívia", "Carlos", "Isabel", "Luciano",
        "Rosana", "Eder", "Amanda", "Mateo", "Kelly", "Danilo", "Mirella", "Alan",
        "Joana", "Vicente", "Elisa", "Wellington", "Noemi", "Caio", "Aurora",
        "Cristina", "José", "Ramon", "Sheila", "Diogo", "Adriana", "Ivan", "Eliane",
        "Daniel", "Julieta", "Otávia", "Simas", "Claudio", "Nicole", "Artur",
        "Renata", "Mário", "Sabrina", "Estevão", "Bárbara", "Giovanni", "Cíntia",
        "João Pedro", "Rosa", "Lucio", "Ana Paula", "Murilo", "Diana", "Thiago",
        "Camille", "Pietro", "Janaina", "Saulo", "Alice", "Osvaldo", "Eloá",
        "Vicentina", "Leopoldo", "Kellyn", "Elton", "Aparecida", "Cássio", "Heloísa",
        "Eurico", "Graziella", "Armando", "Valéria", "Davi", "Mariana", "Rangel",
        "Tereza", "Otacília", "Severino", "Cristal", "Gilberto", "Fabiana", "Nivaldo",
        "Josiane", "Zeca", "Sandra", "Jonatas", "Marisa", "Hélio", "Dalila", "Breno",
        "Gláucia", "Augusto", "Carmen", "Ágata", "Daniele", "Gaspar", "Francisca",
        "Lauro", "Paloma", "Henrique", "Luciana", "Yago", "Tatiane", "Ruan", "Lilian",
        "Emanuel", "Rayssa"
    ]

    var filteredContacts: [String] {
        if searchText.isEmpty {
            contacts
        } else {
            contacts.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var sections: [String: [String]] {
        Dictionary(
            grouping: filteredContacts,
            by: { String($0.prefix(1).uppercased()) }
        )
    }
    
    var body: some View {
        List(letters, id:\.self) { letter in
            if sheetDetent == .third {
                ForEach( filteredContacts, id:\.self) { contact in
                    Text(contact)
                }
            } else {
                if let contactsForLetter = sections[letter], !contactsForLetter.isEmpty {
                    Section(letter) {
                        ForEach(sections[letter] ?? [], id:\.self) { contact in
                            Text(contact)
                        }
                    }
                    .sectionIndexLabel(letter)
                } else {
                    Section {
                        
                    }
                    .sectionIndexLabel(letter)
                }
            }
        }
        .animation(.easeInOut, value: sheetDetent)
        .scrollContentBackground(.hidden)
        .onChange(of: searching) {
            if $1 {
                sheetDetent = .large
            } else {
                sheetDetent = .third
            }
        }
        .navigationTitle("Contacts")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    @Previewable @State var searchText: String = ""
    
    NavigationStack {
        ContactsListView(searchText: $searchText, sheetDetent: .constant(.large))
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .automatic)
            )
    }
}
