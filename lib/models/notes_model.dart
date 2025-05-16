//* Clase Note que representa el modelo de una nota
class Note {
  //* id de la nota, puede ser null porque se asigna automáticamente en la base de datos
  final int? id;
  final String title;
  final String content;
  final String color;
  final String dateTime;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.dateTime,
  });
  //* Convierte un objeto Note a un mapa (Map<String, dynamic>)
  //*para guardarlo en la base de datos

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color,
      'dateTime': dateTime,
    };
  }
  //* Crea una instancia de Note a partir de
  //*un mapa (por ejemplo, una fila de la base de datos)

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      color: map['color'],
      dateTime: map['dateTime'],
    );
  }
}
