import 'dart:ffi';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  //Espera que todo esté inicializado antes de lanzar la aplicación
  WidgetsFlutterBinding.ensureInitialized();
  //inicializa firebase con el Json descargado en la carpeta android
  Firebase.initializeApp().then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
              .copyWith(secondary: Colors.cyan)),
      home: const MyHomePage(title: 'CRUD IN FLUTTER'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String StudentName = '',
      StudentCode = '',
      StudentProgram = '',
      StudentCalifications = '';

  getStudentName(name) {
    StudentName = name;
  }

  getStudentCode(id) {
    setState(() {
      StudentCode = id;
    });
  }

  getStudentProgram(carrera) {
    StudentProgram = carrera;
  }

  getStudentCalifications(promedio) {
    StudentCalifications = promedio;
  }

  createData() {
    print("created");

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Students").doc();

    documentReference
        .set(
          {
            "StudentID": StudentCode,
            "StudentName": StudentName,
            "StudentNotas": StudentCalifications,
            "StudentProgramID": StudentProgram
          },
          SetOptions(merge: false),
        )
        .catchError((error) => print("Failed to merge data: $error"))
        .whenComplete(() {
          print("Estudiante con nombre $StudentName creado");
          print("el ID del documento creado es " +
              documentReference.id.toString());
        });
  }

  ReadData() {
    print("Lectura");

    FirebaseFirestore.instance
        .collection('Students')
        .doc(StudentCode)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        print('Document data: ${data["StudentName"]}');

        AlertDialog alerta = AlertDialog(
          title: const Text('LECTURA DE ESTUDIANTE'),
          content: Column(
            children: [
              Text('Nombre: ${data["StudentName"]}'),
              Text('Carrera: ${data["StudentProgramID"]}'),
              Text('Codigo: ${data["StudentID"]}'),
              Text('Nota promedio: ${data["StudentNotas"]}'),
            ],
          ),
        );
        showDialog(context: context, builder: (BuildContext context) => alerta);
      } else {
        AlertDialog alerta2 = const AlertDialog(
          title: Text('NO EXISTE DATOS'),
          content: Text("F por ti"),
        );
        showDialog(
            context: context, builder: (BuildContext context) => alerta2);
      }
    });
  }

  UpdateData() {
    print("Modificación");

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Students").doc(StudentCode);

    documentReference
        .update({
          "StudentID": StudentCode,
          "StudentName": StudentName,
          "StudentNotas": StudentCalifications,
          "StudentProgramID": StudentProgram
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  DeleteData() {
    print("Eliminar");

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Students").doc(StudentCode);

    documentReference
        .delete()
        .then((value) => print("student deleted"))
        .catchError((error) => print("Failed to delete student: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Nombre",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  onChanged: (String name) {
                    getStudentName(name);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Codigo de Estudiante",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  onChanged: (String id) {
                    getStudentCode(id);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Carrera",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  onChanged: (String carrera) {
                    getStudentProgram(carrera);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "promedio",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  onChanged: (String promedio) {
                    getStudentCalifications(promedio);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      createData();
                    },
                    child: const Text("Create"),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        textStyle: const TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ReadData();
                    },
                    child: const Text(
                      "Read",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.yellow,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      textStyle: const TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      UpdateData();
                    },
                    child: const Text("Update"),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        textStyle: const TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      DeleteData();
                    },
                    child: const Text("Delete"),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        textStyle: const TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  textDirection: TextDirection.ltr,
                  children: const [
                    Expanded(
                        child: Text(
                      "Nombre",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    Expanded(
                        child: Text("Código",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                        child: Text("Promedio",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                        child: Text("Carrera",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Students")
                    .where("StudentID", isEqualTo: StudentCode)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    print("hola que hace");
                    return ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          DocumentSnapshot documentSnapshot =
                              snapshot.data!.docs[index];
                          return Row(
                            textDirection: TextDirection.ltr,
                            children: [
                              Expanded(
                                  child: Text(documentSnapshot["StudentName"])),
                              Expanded(
                                  child: Text(documentSnapshot["StudentID"])),
                              Expanded(
                                  child:
                                      Text(documentSnapshot["StudentNotas"])),
                              Expanded(
                                  child: Text(
                                      documentSnapshot["StudentProgramID"])),
                            ],
                          );
                        },
                        itemCount: snapshot.data!.docs.length);
                  } else {
                    return const Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
