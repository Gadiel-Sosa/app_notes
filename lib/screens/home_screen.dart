import 'package:app_notes/models/notes_model.dart';
import 'package:app_notes/screens/add_edit_screen.dart';
import 'package:app_notes/screens/view_note_screen.dart';
import 'package:app_notes/services/database_helper.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //* Creamos una instancia del helper para manejar la base de datos
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  //* Lista donde se almacenarán las notas recuperadas de la base de datos
  List<Note> _notes = [];
  //* Lista de colores posibles para las notas
  // ignore: unused_field
  final List<Color> _noteColors = [
    Colors.amber,
    Color(0xFF50C878), // Verde esmeralda
    Colors.redAccent,
    Colors.blueAccent,
    Colors.indigo,
    Colors.purpleAccent,
    Colors.pinkAccent,
  ];

  @override
  void initState() {
    //* Método que se ejecuta cuando el widget se crea por primera vez
    //*: implement initState
    super.initState();
    _loadNotes(); //* Cargamos las notas desde la base de datos
  }
  //* Método asíncrono que obtiene las notas desde la base de datos

  //* Future es un tipo de dato que representa un valor que estará disponible en el futuro,
  //*normalmente como resultado de una operación asíncrona (como leer de una base de datos o hacer
  //*una petición a internet)

  Future<void> _loadNotes() async {
    //*! async se usa para declarar una función asíncrona, lo que permite que se
    //*! realicen tareas que toman tiempo (como acceder a una base de datos) sin bloquear la aplicación
    //*! await se usa dentro de funciones async para esperar a que una tarea termine
    //*! antes de continuar con la siguiente línea de código

    //* Esperamos (await) a que la función getNotes()
    //*obtenga todas las notas desde la base de datos y las guardamos en la variable 'notes'
    final notes = await _databaseHelper.getNotes();
    //* Actualizamos el estado para reflejar las notas en la interfaz
    setState(() {
      _notes = notes; //* Actualizamos el estado con las notas obtenidas
    });
  }
  //* Método para dar formato legible a la fecha y hora de cada nota

  String _formatDateTime(String dateTime) {
    final DateTime dt = DateTime.parse(
      dateTime,
    ); //* Convertimos la cadena de fecha y hora a un objeto DateTime
    final now = DateTime.now();
    //* Si la nota fue creada hoy, mostramos "Today" con la hora

    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      //* padLeft agrega ceros (u otro carácter) a la izquierda de un número convertido en texto
      //* Por ejemplo: '5'.padLeft(2, '0') devuelve '05'
      return 'Today ${dt.hour.toString().padLeft(2, '0')}: ${dt.minute.toString().padLeft(0, '0')}';
    }
    //* Si fue en otro día, mostramos fecha completa y hora
    return '${dt.day}/${dt.month}/${dt.year}, ${dt.hour.toString().padLeft(2, '0')}: ${dt.minute.toString().padLeft(0, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //* AppBar (barra superior de la app)
      appBar: AppBar(
        elevation: 0, //* Sin sombra debajo de la AppBar
        backgroundColor: Colors.white,
        title: Text('My Notes'),
      ),
      //* Cuerpo de la app que muestra las notas en un grid
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //* Dos columnas
          crossAxisSpacing: 16, //* Espacio horizontal entre tarjetas
          mainAxisSpacing: 16, //* Espacio vertical entre tarjetas
        ),
        itemCount: _notes.length, //* Cantidad de notas a mostrar
        itemBuilder: (context, index) {
          final note = _notes[index];
          final color = Color(int.parse(note.color));

          return GestureDetector(
            //** Detecta gestos del usuario, como toques tap
            onTap: () async {
              //* Navegamos a la pantalla para ver la nota
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ViewNoteScreen(
                        note: note,
                      ), //* muestra la nota seleccionan el contenido
                ),
              );
              //* Al volver, recargamos las notas por si hubo cambios

              _loadNotes();
            },
            child: Container(
              decoration: BoxDecoration(
                color: color, //* Color de fondo de la nota
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  //* Sombras
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.1), //* Sombra suave
                    blurRadius: 4,
                    offset: Offset(0, 2), //* Desplazamiento de la sombra
                    spreadRadius: 0, //* Difuminado de la sombra
                  ),
                ],
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //* Título de la nota
                  Text(
                    note.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1, //* Máximo una línea
                    overflow:
                        TextOverflow.ellipsis, //* Si es muy largo, pone "..."
                  ),
                  SizedBox(height: 8),

                  //* Contenido de la nota
                  Text(
                    note.content,
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(), //* Empuja el resto hacia abajo
                  //* Fecha y hora de creación/formato
                  Text(
                    _formatDateTime(note.dateTime),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      //* Botón flotante para agregar una nueva nota
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //* Navegamos a la pantalla de agregar o editar nota
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditNoteScreen()),
          );
          _loadNotes(); //* Al volver, recargamos las notas
        },
        // ignore: sort_child_properties_last
        child: Icon(Icons.add), //* Icono de suma
        backgroundColor: Color(0xFF50C878), //* Color verde personalizado
        foregroundColor: Colors.white, //* Color del ícono
      ),
    );
  }
}
