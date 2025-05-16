import 'package:app_notes/models/notes_model.dart';
import 'package:app_notes/screens/home_screen.dart';
import 'package:app_notes/services/database_helper.dart';
import 'package:flutter/material.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note; //* Si se pasa una nota, significa que estamos editando
  // ignore: use_key_in_widget_constructors
  const AddEditNoteScreen({this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  //* Llave del formulario para validar los campos
  final _formKey = GlobalKey<FormState>();
  //* Controladores para los campos de título y contenido
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  //* Instancia para acceder a la base de datos
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  //* Color seleccionado por el usuario
  Color _selectedColor = Colors.amber;
  //* Lista de colores disponibles para las notas
  final List<Color> _colors = [
    Colors.amber,
    Color(0xFF50C878),
    Colors.redAccent,
    Colors.blueAccent,
    Colors.indigo,
    Colors.purpleAccent,
    Colors.pinkAccent,
  ];

  @override
  void initState() {
    //* implement initState
    super.initState();
    //* Si se recibió una nota (modo edición), llenamos los campos con sus valores
    if (widget.note != null) {
      _titleController.text =
          widget.note!.title; //*asigna el título de la nota existente
      //*al campo de texto para que el usuario pueda editarlo
      _contentController.text =
          widget.note!.content; //* asigna el contenido de la nota existente
      //* al campo de texto para que el usuario pueda editarlo
      _selectedColor = Color(
        int.parse(widget.note!.color),
      ); //* asigna el color de la nota existente
      //* al color seleccionado para que el usuario pueda editarlo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //* Barra superior con título que cambia si es agregar o editar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
      ),
      //* Formulario que contiene los campos de entrada
      body: Form(
        key: _formKey, //* Asignamos la llave del formulario
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                //* Campo de texto para el título de la nota
                children: [
                  TextFormField(
                    controller:
                        _titleController, //* conecta el campo de texto con el controlador
                    //* para modificar el titulo ingresado por el usuario
                    decoration: InputDecoration(
                      hintText:
                          'Title', //* muestra un texto gris de ejemplo dentro del campo
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    //* Validación: no permitir título vacío
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  //* Campo de texto para el contenido de la nota
                  TextFormField(
                    controller:
                        _contentController, //* conecta el campo de texto con el controlador
                    //* para modificar el contenido ingresado por el usuario
                    decoration: InputDecoration(
                      hintText:
                          'Content', //* muestra un texto gris de ejemplo dentro del campo
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 10, //* Permite varias líneas
                    //* Validación: no permitir contenido vacío
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a content';
                      }
                      return null;
                    },
                  ),
                  //* Selector horizontal de colores
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            _colors.map((color) {
                              //* Mapeamos la lista de colores a una lista de widgets
                              //* Al tocar un color, se actualiza el color seleccionado
                              return GestureDetector(
                                onTap:
                                    () =>
                                        setState(() => _selectedColor = color),
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  margin: EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: color,
                                    //* Si es el color seleccionado, se muestra un borde negro
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          //* Si el color actual es el mismo que el seleccionado por el usuario,
                                          //*se muestra un borde negro
                                          _selectedColor == color
                                              ? Colors.black45
                                              : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(), //* Convertimos la lista de colores a una lista de widgets
                      ),
                    ),
                  ),
                  //* Botón para guardar la nota
                  InkWell(
                    onTap: () {
                      _saveNote(); //* Guarda o actualiza la nota
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFF50C878),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Save Note',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //* Función que guarda o actualiza una nota en la base de datos
  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      //* Si el formulario es válido, se procede a guardar la nota
      //* Creamos una instancia de la clase Note con los datos del formulario
      final note = Note(
        //* Creamos una instancia de Note con los datos del formulario
        id: widget.note?.id, //* Si estamos editando, usamos el mismo id
        title:
            _titleController
                .text, //*  toma el texto que el usuario escribió en el campo de título y
        //*lo asigna al campo 'title' del objeto Note
        content: _contentController.text,
        // ignore: deprecated_member_use
        color:
            _selectedColor.value.toString(), //* Guardamos el color como String
        dateTime: DateTime.now().toString(), //* Fecha y hora actual
      );

      if (widget.note == null) {
        //* Si no hay nota previa, insertamos una nueva
        await _databaseHelper.insertNote(note);
      } else {
        //* Si ya existe, actualizamos la nota
        await _databaseHelper.updateNote(note);
      }
    }
  }
}
