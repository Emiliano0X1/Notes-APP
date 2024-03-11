
import SwiftUI

struct Note: Identifiable {
    var id = UUID()
    var title: String
    var content: String
    var grade:Double?
}

struct LoadingView : View{ // Es ub netodo para la pantalla de carga
    var body:some View{
        VStack{
            Image("Assets")
            Text("is Loading Bitches...")
                .font(.title)
                .foregroundColor(.black)
            ProgressView()
                .scaleEffect(1.7)
                .padding()
                .progressViewStyle(CircularProgressViewStyle(tint: .black))
        }
        
        .padding()
        .cornerRadius(20)
        
    }
}

struct ContentView: View { // eL CONTENIDO EN GENERAL
    @State private var notes = [
        Note(title: "Ciencia de la Felicidad", content: "Contenido General",grade:100),
        Note(title: "Comunicacion Efectiva", content: "Contenido General",grade:100),
        Note(title: "Calculo Integral", content: "Contenido General",grade:98),
        Note(title: "Matematicas Discretas", content: "Contenido General",grade:100),
        Note(title: "Estatica", content: "Contenido General",grade:84),
        Note(title: "POO", content: "Contenido General",grade:72),
    ]
    
    @State private var isLoading = true
    
    var body: some View {
        NavigationView {
            ZStack {
                if isLoading {
                    
                    LoadingView() // Llamar al metodo
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // Es asincrona, es decir trabaja aparte del codigo
                                isLoading = false
                            }
                        }
                } else {
                    // Contenido principal
                    List {
                        ForEach(notes) { note in
                            NavigationLink(destination: NoteDetailView(note: note)) {
                                HStack {
                                    Text(note.title)
                                    Spacer()
                                    if let grade = note.grade {
                                        Text(String(format: "%.1f", grade))
                                            .foregroundColor(changeColor(grade:grade))
                                        Image(systemName: grade >= 7 ? "checkmark.circle" : "xmark.circle")
                                            .foregroundColor(changeColor(grade:grade))
                                    }
                                    
                                }
                            }
                            
                        }
                        
                    }
                    .navigationTitle("Semester 2") //Agrega estilo
                    .navigationBarItems(trailing:
                                            NavigationLink(destination: NoteCreationView(notes: $notes)) {
                        Image(systemName: "plus")
                            .lineSpacing(20)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.blue)
                            .cornerRadius(20)
                    }
                    )
                }
            }
        }
        
        .background(Color.yellow.edgesIgnoringSafeArea(.all))
    }

    
}



func changeColor(grade: Double) -> Color {
    switch grade {
    case ..<70:
        return Color.red
    case 70..<80:
        return Color.orange
    case 80..<90:
        return Color.yellow
    default:
        return Color.green
    }
}

struct NoteDetailView: View {
    var note: Note
    
    var body: some View {
        VStack {
            Text(note.title)
                .font(.title)
            Text(note.content)
                .padding()
            
            if let grade = note.grade {
                Text(String(format: "%.1f", grade))
                    .padding()
                    .background(changeColor(grade: grade))
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .navigationBarTitle(note.title)
    }
}

struct NoteCreationView: View {
    @State private var newNoteTitle = ""
    @State private var newNoteContent = ""
    @State private var newNoteGrade = "0"
    
    @Binding var notes: [Note]
    
    var body: some View {
        Form {
            
            Section(header: Text("Titulo")) {
                TextField("Ingrese el titulo", text: $newNoteTitle)
                      }
                      
            Section(header: Text("Contenido")) {
                TextEditor(text: $newNoteContent)
                      }
            
            Section(header: Text("Calificacion")){
                TextField("Ingresa tu calificacion", text: $newNoteGrade)
                    .keyboardType(.decimalPad)
            }
            
            Section {
                Button("Agregar Nota") {
                    if let grade = Double(newNoteGrade) {
                        notes.append(Note(title: newNoteTitle, content: newNoteContent, grade: grade))
                    }
                }
            }
        }
        .navigationBarTitle("Nueva Nota")
    }
}

    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
    

