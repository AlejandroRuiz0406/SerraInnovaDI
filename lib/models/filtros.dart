class Filtros {
  //Ubicación y operación
  final String? provincia;
  final String? municipio;
  final String? operacion;

  //Sostenibilidad
  final bool calificacionEnergetica;
  final String? tipoEnergia;
  final String? certificacion;
  final double maxEmisionesCo2;

  //Accesibilidad
  final bool viviendaAdaptada;
  final bool mascotas;
  final bool zonasVerdes;

  //Colectivos y servicios
  final List<String> colectivos;
  final List<String> servicios;

  //Economía
  final double precioMin;
  final double precioMax;
  final bool gastosIncluidos;
  final bool ayudas;
  final String? regimen;

  final double? superficieMin;
  final double? superficieMax;
  final int? habitaciones;
  final bool? terraza;
  final bool? garaje;
  final bool? trastero;

  const Filtros({
    this.provincia,
    this.municipio,
    this.operacion,
    this.tipoEnergia,
    this.certificacion,
    this.regimen,
    this.superficieMin,
    this.superficieMax,
    this.habitaciones,
    this.terraza,
    this.garaje,
    this.trastero,
    required this.calificacionEnergetica,
    required this.maxEmisionesCo2,
    required this.viviendaAdaptada,
    required this.mascotas,
    required this.zonasVerdes,
    required this.colectivos,
    required this.servicios,
    required this.precioMin,
    required this.precioMax,
    required this.gastosIncluidos,
    required this.ayudas,
  });

  @override
  String toString() {
    return 'FiltrosBusqueda('
        'provincia=$provincia, municipio=$municipio, operacion=$operacion, '
        'calificacionEnergetica=$calificacionEnergetica, tipoEnergia=$tipoEnergia, certificacion=$certificacion, maxEmisionesCo2=$maxEmisionesCo2, '
        'viviendaAdaptada=$viviendaAdaptada, mascotas=$mascotas, zonasVerdes=$zonasVerdes, '
        'colectivos=$colectivos, servicios=$servicios, '
        'precioMin=$precioMin, precioMax=$precioMax, gastosIncluidos=$gastosIncluidos, ayudas=$ayudas, regimen=$regimen'
        ')';
  }

  Map<String, dynamic> toMap() {
    return {
      'provincia': provincia,
      'municipio': municipio,
      'operacion': operacion,
      'calificacionEnergetica': calificacionEnergetica,
      'tipoEnergia': tipoEnergia,
      'certificacion': certificacion,
      'maxEmisionesCo2': maxEmisionesCo2,
      'viviendaAdaptada': viviendaAdaptada,
      'mascotas': mascotas,
      'zonasVerdes': zonasVerdes,
      'colectivos': colectivos,
      'servicios': servicios,
      'precioMin': precioMin,
      'precioMax': precioMax,
      'gastosIncluidos': gastosIncluidos,
      'ayudas': ayudas,
      'regimen': regimen,
      'superficieMin': superficieMin,
      'superficieMax': superficieMax,
      'habitaciones': habitaciones,
      'terraza': terraza,
      'garaje': garaje,
      'trastero': trastero,
    };
  }

  factory Filtros.vacios() {
    return Filtros(
      operacion: null,
      provincia: null,
      municipio: null,
      precioMin: 0,
      precioMax: 9999999,
      superficieMin: 0,
      superficieMax: 1000,
      habitaciones: null,
      terraza: false,
      garaje: false,
      trastero: false,
      calificacionEnergetica: false,
      maxEmisionesCo2: 100,
      viviendaAdaptada: false,
      mascotas: false,
      zonasVerdes: false,
      colectivos: [],
      servicios: [],
      gastosIncluidos: false,
      ayudas: false,
    );
  }
}
