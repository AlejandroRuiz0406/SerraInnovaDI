class Vivienda {
  final String id;

  // Ubicación
  final String titulo;
  final String provincia;
  final String municipio;

  // Precio
  final double precio;
  final String operacion; 
  final String unidadPrecio; 

  // Características físicas
  final double superficie; 
  final int habitaciones;
  final int? banos;

  // Sostenibilidad
  final double emisionesCo2;

  // Accesibilidad / extras
  final bool mascotas;
  final bool viviendaAdaptada;
  final bool zonasVerdes;
  final bool terraza;
  final bool garaje;
  final bool trastero;

  // Listas
  final List<String> colectivos;
  final List<String> servicios;

  final String imageUrl;

  const Vivienda({
    this.banos,
    required this.imageUrl,
    required this.id,
    required this.titulo,
    required this.provincia,
    required this.municipio,
    required this.precio,
    required this.operacion,
    required this.unidadPrecio,
    required this.superficie,
    required this.habitaciones,
    required this.emisionesCo2,
    required this.mascotas,
    required this.viviendaAdaptada,
    required this.zonasVerdes,
    required this.terraza,
    required this.garaje,
    required this.trastero,
    required this.colectivos,
    required this.servicios,
  });

  factory Vivienda.fromMap(String id, Map<String, dynamic> data) {
    return Vivienda(
      id: id,
      titulo: data['titulo'] ?? 'Sin título',
      provincia: data['provincia'] ?? 'Sin provincia',
      municipio: data['municipio'] ?? 'Sin municipio',
      precio: (data['precio'] ?? 0).toDouble(),
      operacion: data['operacion'] ?? 'Comprar',
      unidadPrecio: data['unidadPrecio'] ?? '€',
      superficie: (data['superficie'] ?? 0).toDouble(),
      habitaciones: data['habitaciones'],
      banos: data['banos'],
      emisionesCo2: (data['emisionesCo2'] ?? 0).toDouble(),
      mascotas: data['mascotas'] ?? false,
      viviendaAdaptada: data['viviendaAdaptada'] ?? false,
      zonasVerdes: data['zonasVerdes'] ?? false,
      terraza: data['terraza'] ?? false,
      garaje: data['garaje'] ?? false,
      trastero: data['trastero'] ?? false,
      colectivos: List<String>.from(data['colectivos'] ?? []),
      servicios: List<String>.from(data['servicios'] ?? []),
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'provincia': provincia,
      'municipio': municipio,
      'precio': precio,
      'operacion': operacion,
      'unidadPrecio': unidadPrecio,
      'superficie': superficie,
      'habitaciones': habitaciones,
      'banos': banos,
      'emisionesCo2': emisionesCo2,
      'mascotas': mascotas,
      'viviendaAdaptada': viviendaAdaptada,
      'zonasVerdes': zonasVerdes,
      'terraza': terraza,
      'garaje': garaje,
      'trastero': trastero,
      'colectivos': colectivos,
      'servicios': servicios,
      'imageUrl': imageUrl,
    };
  }
}
