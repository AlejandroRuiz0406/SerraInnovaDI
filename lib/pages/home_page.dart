import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:serra_innova/models/filtros.dart';
import 'package:serra_innova/models/filtros_origen.dart';
import 'package:provider/provider.dart';
import 'package:serra_innova/provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedOperacion;
  String? _selectedProvincia;
  String? _selectedMunicipio;

  final List<String> provincias = ['Valencia', 'Alicante', 'Castellón'];
  final List<String> municipiosVal = [
    'Torrent',
    'Paterna',
    'Alzira',
    'Picanya',
  ];
  final List<String> municipiosAl = ['Dénia', 'Benidorm', 'Moraira', 'Altea'];
  final List<String> municipiosCast = [
    'Castellón de la Plana',
    'Peñíscola',
    'Nules',
    'Almenara',
  ];

  List<String> get _municipiosParaProvinciaSeleccionada {
    if (_selectedProvincia == 'Valencia') {
      return municipiosVal;
    }
    if (_selectedProvincia == 'Alicante') {
      return municipiosAl;
    }
    if (_selectedProvincia == 'Castellón') {
      return municipiosCast;
    }
    return [];
  }

  RangeValues _precio = const RangeValues(300, 1200);
  RangeValues _superficie = const RangeValues(40, 120);

  int? _habitaciones; 
  bool _extraTerraza = false;
  bool _extraGaraje = false;
  bool _extraTrastero = false;

  void _ajustarPrecioPorOperacion() {
    final esAlquiler = _selectedOperacion == 'Alquilar';
    setState(() {
      _precio = esAlquiler
          ? const RangeValues(300, 1200)
          : const RangeValues(60000, 250000);
    });
  }

  Future<void> _showPrecioDialog() async {
    if (_selectedOperacion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona Comprar o Alquilar primero')),
      );
      return;
    }

    final esAlquiler = _selectedOperacion == 'Alquilar';
    final min = esAlquiler ? 300.0 : 60000.0;
    final max = esAlquiler ? 3000.0 : 450000.0;

    RangeValues temp = RangeValues(
      _precio.start.clamp(min, max),
      _precio.end.clamp(min, max),
    );

    final res = await showDialog<RangeValues>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Precio'),
        content: StatefulBuilder(
          builder: (context, setStateDialog) {
            return SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${temp.start.round()}€ - ${temp.end.round()}€'),
                  RangeSlider(
                    values: temp,
                    min: min,
                    max: max,
                    divisions: esAlquiler ? 270 : 390,
                    onChanged: (v) => setStateDialog(() => temp = v),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, temp),
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );

    if (res != null) {
      setState(() => _precio = res);
    }
  }

  Future<void> _showSuperficieDialog() async {
    RangeValues temp = _superficie;

    final res = await showDialog<RangeValues>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Superficie (m²)'),
        content: StatefulBuilder(
          builder: (context, setStateDialog) {
            return SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${temp.start.round()} - ${temp.end.round()} m²'),
                  RangeSlider(
                    values: temp,
                    min: 10,
                    max: 400,
                    divisions: 390,
                    onChanged: (v) => setStateDialog(() => temp = v),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, temp),
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );

    if (res != null) {
      setState(() => _superficie = res);
    }
  }

  Future<void> _showHabitacionesDialog() async {
    int? temp = _habitaciones;

    final res = await showDialog<int?>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Habitaciones'),
        content: StatefulBuilder(
          builder: (context, setStateDialog) {
            return SizedBox(
              width: 320,
              child: DropdownButtonFormField<int?>(
                value: temp,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text('Cualquiera')),
                  DropdownMenuItem(value: 0, child: Text('0 (estudio)')),
                  DropdownMenuItem(value: 1, child: Text('1')),
                  DropdownMenuItem(value: 2, child: Text('2')),
                  DropdownMenuItem(value: 3, child: Text('3')),
                  DropdownMenuItem(value: 4, child: Text('4')),
                  DropdownMenuItem(value: 5, child: Text('5+')),
                ],
                onChanged: (v) => setStateDialog(() => temp = v),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, temp),
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );

    setState(() => _habitaciones = res);
  }

  Future<void> _showExtrasDialog() async {
    bool terraza = _extraTerraza;
    bool garaje = _extraGaraje;
    bool trastero = _extraTrastero;

    final res = await showDialog<Map<String, bool>>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Extras'),
        content: StatefulBuilder(
          builder: (context, setStateDialog) {
            return SizedBox(
              width: 320,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    title: const Text('Terraza'),
                    value: terraza,
                    onChanged: (v) =>
                        setStateDialog(() => terraza = v ?? false),
                  ),
                  CheckboxListTile(
                    title: const Text('Garaje'),
                    value: garaje,
                    onChanged: (v) => setStateDialog(() => garaje = v ?? false),
                  ),
                  CheckboxListTile(
                    title: const Text('Trastero'),
                    value: trastero,
                    onChanged: (v) =>
                        setStateDialog(() => trastero = v ?? false),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, {
              'terraza': terraza,
              'garaje': garaje,
              'trastero': trastero,
            }),
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );

    if (res != null) {
      setState(() {
        _extraTerraza = res['terraza'] ?? false;
        _extraGaraje = res['garaje'] ?? false;
        _extraTrastero = res['trastero'] ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viviendaProvider = Provider.of<ViviendaProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF90EE90),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 40,
            child: Image.asset(
              'assets/LogoSerraInnova.jpg',
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Center(
          child: Text("SerraInnova", style: TextStyle(color: Colors.white)),
        ),
        actions: [
          IconButton(
            tooltip: 'Filtros Avanzados',
            onPressed: () {
              context.push(
                '/filtros-avanzados',
                extra: {'origen': FiltrosOrigen.home, 'filtros': null},
              );
            },
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 36),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Tipo de operación:"),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () {
                      setState(() => _selectedOperacion = "Comprar");
                      _ajustarPrecioPorOperacion();
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        _selectedOperacion == "Comprar"
                            ? Colors.lightGreen.shade100
                            : Colors.white,
                      ),
                    ),
                    child: Text(
                      "Comprar",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () {
                      setState(() => _selectedOperacion = "Alquilar");
                      _ajustarPrecioPorOperacion();
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        _selectedOperacion == "Alquilar"
                            ? Colors.lightGreen.shade100
                            : Colors.white,
                      ),
                    ),
                    child: Text(
                      "Alquilar",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Ubicación:"),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedProvincia,
                        hint: const Text(
                          'Provincia',
                          style: TextStyle(fontSize: 14),
                        ),
                        isDense: true,
                        icon: const Icon(Icons.arrow_drop_down, size: 20),
                        items: provincias
                            .map(
                              (p) => DropdownMenuItem<String>(
                                value: p,
                                child: Text(
                                  p,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) => setState(() {
                          _selectedProvincia = value;
                          _selectedMunicipio = null;
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedMunicipio,
                        hint: const Text(
                          'Municipio',
                          style: TextStyle(fontSize: 14),
                        ),
                        isDense: true,
                        icon: const Icon(Icons.arrow_drop_down, size: 20),
                        items: _municipiosParaProvinciaSeleccionada
                            .map(
                              (p) => DropdownMenuItem<String>(
                                value: p,
                                child: Text(
                                  p,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedMunicipio = value),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text("Filtros rápidos:"),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _showPrecioDialog,
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    child: Text(
                      "Precio (€)",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: _showSuperficieDialog,
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    child: Text(
                      "Superficie (m²)",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: _showHabitacionesDialog,
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    child: Text(
                      "Habitaciones",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: _showExtrasDialog,
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    child: Text(
                      "Extras",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedOperacion == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Selecciona Comprar o Alquilar'),
                          ),
                        );
                        return;
                      }

                      final nuevosFiltros = Filtros(
                        operacion: _selectedOperacion,
                        provincia: _selectedProvincia,
                        municipio: _selectedMunicipio,
                        superficieMin: _superficie.start,
                        superficieMax: _superficie.end,
                        habitaciones: _habitaciones,
                        terraza: _extraTerraza,
                        garaje: _extraGaraje,
                        trastero: _extraTrastero,

                        calificacionEnergetica: viviendaProvider.filtros.calificacionEnergetica,
                        maxEmisionesCo2: viviendaProvider.filtros.maxEmisionesCo2,
                        viviendaAdaptada: viviendaProvider.filtros.viviendaAdaptada,
                        mascotas: viviendaProvider.filtros.mascotas,
                        zonasVerdes: viviendaProvider.filtros.zonasVerdes,
                        colectivos: viviendaProvider.filtros.colectivos,
                        servicios: viviendaProvider.filtros.servicios,
                        precioMin: _precio.start,
                        precioMax: _precio.end,
                        gastosIncluidos: viviendaProvider.filtros.gastosIncluidos,
                        ayudas: viviendaProvider.filtros.ayudas,
                        tipoEnergia: viviendaProvider.filtros.tipoEnergia,
                        certificacion: viviendaProvider.filtros.certificacion,
                        regimen: viviendaProvider.filtros.regimen,
                      );

                      viviendaProvider.updateFiltros(nuevosFiltros);

                      context.go('/resultados'); 
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF90EE90),
                      padding: EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 20,
                      ),
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text(
                      "Buscar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Accede a filtros avanzados desde el menú superior",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Wrap(
                spacing: 40,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: const [
                  _InfoItem(
                    icon: Icons.eco,
                    title: "Sostenibilidad",
                    text: "Viviendas con bajo impacto ambiental",
                  ),
                  _InfoItem(
                    icon: Icons.accessible,
                    title: "Accesibilidad",
                    text: "Pensadas para todos los colectivos",
                  ),
                  _InfoItem(
                    icon: Icons.search,
                    title: "Filtros inteligentes",
                    text: "Encuentra lo que necesitas fácilmente",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 65,
        color: const Color(0xFF90EE90),
        alignment: Alignment.center,
        child: const Text(
          "© 2026 SerraInnova · Viviendas sostenibles",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        children: [
          Icon(icon, size: 40, color: Color(0xFF90EE90)),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
