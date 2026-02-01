import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vivienda.dart';

class SeedViviendas {
  static final _db = FirebaseFirestore.instance;
  static final _random = Random();

  static const List<String> imagenesDemo = [
    'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2',
    'https://images.unsplash.com/photo-1568605114967-8130f3a36994',
    'https://images.unsplash.com/photo-1570129477492-45c003edd2be',
    'https://images.unsplash.com/photo-1598928506311-c55ded91a20c',
    'https://images.unsplash.com/photo-1580587771525-78b9dba3b914',
    'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
  ];

  static const provincias = {
    'Valencia': ['Torrent', 'Paterna', 'Picanya', 'Alzira'],
    'Alicante': ['Dénia', 'Benidorm', 'Moraira', 'Altea'],
    'Castellón': ['Nules', 'Peñíscola', 'Almenara', 'Castellón de la Plana'],
  };

  static const colectivosPosibles = [
    'Jóvenes',
    'Mayores',
    'Familias',
    'Discapacidad',
  ];

  static const serviciosPosibles = [
    'Transporte público',
    'Centros educativos',
    'Centros de salud',
  ];

  static Future<void> generar({int cantidad = 50}) async {
    for (int i = 0; i < cantidad; i++) {
      final provincia = provincias.keys.elementAt(
        _random.nextInt(provincias.length),
      );
      final municipio =
          provincias[provincia]![_random.nextInt(
            provincias[provincia]!.length,
          )];

      final operacion = _random.nextBool() ? 'Alquilar' : 'Comprar';
      final esAlquiler = operacion == 'Alquilar';

      final precio = esAlquiler
          ? _random.nextInt(2700) +
                300 
          : _random.nextInt(390000) + 60000; 

      final superficie = (_random.nextInt(160) + 30).toDouble(); 

      final terraza = _random.nextBool();
      final garaje = _random.nextInt(100) < 45; // 45% prob.
      final trastero = _random.nextInt(100) < 35; // 35% prob.

      final vivienda = Vivienda(
        id: '',
        titulo: _generarTitulo(provincia, operacion),
        provincia: provincia,
        municipio: municipio,
        precio: precio.toDouble(),
        emisionesCo2: (_random.nextInt(80) + 5).toDouble(),
        mascotas: _random.nextBool(),
        viviendaAdaptada: _random.nextBool(),
        zonasVerdes: _random.nextBool(),
        colectivos: _pickRandom(colectivosPosibles),
        servicios: _pickRandom(serviciosPosibles),
        operacion: operacion,
        unidadPrecio: esAlquiler ? '€/mes' : '€',
        habitaciones: _random.nextInt(6), // 0..5
        imageUrl: imagenesDemo[_random.nextInt(imagenesDemo.length)],

        superficie: superficie,
        terraza: terraza,
        garaje: garaje,
        trastero: trastero,
      );

      await _db.collection('viviendas').add(vivienda.toMap());
    }
  }

  static Future<void> borrarTodo() async {
    final snapshot = await _db.collection('viviendas').get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  static String _generarTitulo(String provincia, String operacion) {
    final tipo = ['Piso', 'Casa', 'Estudio'][_random.nextInt(3)];
    return '$tipo ${operacion == "Alquilar" ? "en alquiler" : "en venta"} en $provincia';
  }

  static List<String> _pickRandom(List<String> source) {
    final copy = List<String>.from(source)..shuffle();
    final count = _random.nextInt(source.length + 1); 
    return copy.take(count).toList();
  }
}
