import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:serra_innova/models/filtros.dart';
import 'package:serra_innova/models/filtros_origen.dart';

class FiltrosAvanzadosPage extends StatefulWidget {
  final FiltrosOrigen origen;
  final Filtros? filtrosIniciales;

  const FiltrosAvanzadosPage({
    super.key,
    required this.origen,
    this.filtrosIniciales,
  });

  @override
  State<FiltrosAvanzadosPage> createState() => _FiltrosAvanzadosPageState();
}

class _FiltrosAvanzadosPageState extends State<FiltrosAvanzadosPage> {
  bool calificacion = false;

  String? tipoEnergia;
  String? certificacion;

  final List<String> tiposEnergia = [
    'Solar',
    'Eólica',
    'Aerotermia',
    'Geotermia',
    'Biomasa',
  ];

  final List<String> certificaciones = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];

  double emisiones = 25;

  bool viviendaAdaptada = false;
  bool mascotas = false;
  bool zonasVerdes = false;

  bool mayores = false;
  bool jovenes = false;
  bool familias = false;
  bool discapacidad = false;

  bool centrosSalud = false;
  bool transporte = false;
  bool centrosEducativos = false;

  String? tipoVivienda;
  final List<String> tiposVivienda = ['Piso', 'Casa', 'Estudio'];

  int? habitaciones;
  int? banos;

  bool terraza = false;
  bool garaje = false;
  bool trastero = false;

  final List<int> opcionesHabitaciones = [0, 1, 2, 3, 4, 5, 6];
  final List<int> opcionesBanos = [1, 2, 3, 4];

  RangeValues precioRango = const RangeValues(300, 900);
  bool gastos = false;
  bool ayudas = false;

  String? regimen;

  final List<String> tiposRegimen = [
    'Régimen libre',
    'Vivienda protegida',
    'Alquiler protegido',
    'Vivienda pública',
    'Vivienda de inserción social',
  ];

  String operacion = 'Alquilar';

  @override
  void initState() {
    super.initState();

    final f = widget.filtrosIniciales;
    if (f == null) {
      _ajustarPrecioPorOperacion();
      return;
    }

    calificacion = f.calificacionEnergetica;
    emisiones = f.maxEmisionesCo2;

    viviendaAdaptada = f.viviendaAdaptada;
    mascotas = f.mascotas;
    zonasVerdes = f.zonasVerdes;

    precioRango = RangeValues(f.precioMin, f.precioMax);

    gastos = f.gastosIncluidos;
    ayudas = f.ayudas;

    operacion = f.operacion ?? operacion;

    mayores = f.colectivos.contains('Mayores');
    jovenes = f.colectivos.contains('Jóvenes');
    familias = f.colectivos.contains('Familias');
    discapacidad = f.colectivos.contains('Discapacidad');

    centrosSalud = f.servicios.contains('Centros de salud');
    transporte = f.servicios.contains('Transporte público');
    centrosEducativos = f.servicios.contains('Centros educativos');

    _ajustarPrecioPorOperacion();
  }

  void _ajustarPrecioPorOperacion() {
    if (operacion == 'Alquilar') {
      if (precioRango.start < 300 || precioRango.end > 3000) {
        precioRango = const RangeValues(300, 1200);
      }
    } else {
      if (precioRango.start < 60000 || precioRango.end > 450000) {
        precioRango = const RangeValues(60000, 250000);
      }
    }
  }

  void _cerrar(BuildContext context) {
    if (widget.origen == FiltrosOrigen.home) {
      context.go('/');
    } else {
      context.go('/resultados', extra: widget.filtrosIniciales);
    }
  }

  static const _divider = Divider(
    thickness: 1,
    height: 24,
    color: Colors.black12,
  );

  CheckboxListTile _cb({
    required String text,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return CheckboxListTile(
      title: Text(text),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF90EE90),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _sectionTitle(String t) => Text(
    t,
    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  );

  Widget _seccionSostenibilidad() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Sostenibilidad"),
        const SizedBox(height: 8),

        _cb(
          text: "Calificación energética (A-G)",
          value: calificacion,
          onChanged: (v) => setState(() => calificacion = v ?? false),
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: tipoEnergia,
                decoration: InputDecoration(
                  labelText: 'Tipo de energía',
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: tiposEnergia
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => tipoEnergia = v),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: certificacion,
                decoration: InputDecoration(
                  labelText: 'Certificación',
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: certificaciones
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => certificacion = v),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            const SizedBox(width: 120, child: Text("Emisiones CO₂:")),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 6,
                  activeTrackColor: const Color(0xFF90EE90),
                  thumbColor: const Color(0xFF90EE90),
                  overlayColor: const Color(0x3390EE90),
                ),
                child: Slider(
                  value: emisiones,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  onChanged: (v) => setState(() => emisiones = v),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 110,
              child: Text(
                "≤ ${emisiones.round()} kg",
                textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _seccionAccesibilidad() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Accesibilidad"),
        const SizedBox(height: 8),

        Row(
          children: [
            const Expanded(child: Text("Vivienda adaptada")),
            Switch(
              value: viviendaAdaptada,
              onChanged: (v) => setState(() => viviendaAdaptada = v),
              activeThumbColor: const Color(0xFF90EE90),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(child: Text("Mascotas permitidas")),
            Switch(
              value: mascotas,
              onChanged: (v) => setState(() => mascotas = v),
              activeThumbColor: const Color(0xFF90EE90),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(child: Text("Zonas verdes cercanas")),
            Switch(
              value: zonasVerdes,
              onChanged: (v) => setState(() => zonasVerdes = v),
              activeThumbColor: const Color(0xFF90EE90),
            ),
          ],
        ),
      ],
    );
  }

  Widget _seccionColectivos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Colectivos prioritarios"),
        const SizedBox(height: 8),

        _cb(
          text: "Mayores",
          value: mayores,
          onChanged: (v) => setState(() => mayores = v ?? false),
        ),
        _cb(
          text: "Jóvenes",
          value: jovenes,
          onChanged: (v) => setState(() => jovenes = v ?? false),
        ),
        _cb(
          text: "Familias",
          value: familias,
          onChanged: (v) => setState(() => familias = v ?? false),
        ),
        _cb(
          text: "Discapacidad",
          value: discapacidad,
          onChanged: (v) => setState(() => discapacidad = v ?? false),
        ),
      ],
    );
  }

  Widget _seccionServicios() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Servicios cercanos"),
        const SizedBox(height: 8),

        _cb(
          text: "Centros de salud",
          value: centrosSalud,
          onChanged: (v) => setState(() => centrosSalud = v ?? false),
        ),
        _cb(
          text: "Transporte público",
          value: transporte,
          onChanged: (v) => setState(() => transporte = v ?? false),
        ),
        _cb(
          text: "Centros educativos",
          value: centrosEducativos,
          onChanged: (v) => setState(() => centrosEducativos = v ?? false),
        ),
      ],
    );
  }

  Widget _seccionCaracteristicas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Características"),
        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          value: tipoVivienda,
          decoration: InputDecoration(
            labelText: 'Tipo vivienda',
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: tiposVivienda
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => tipoVivienda = v),
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            const SizedBox(width: 120, child: Text("Habitaciones:")),
            Expanded(
              child: DropdownButtonFormField<int>(
                value: habitaciones,
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                hint: const Text("---"),
                items: opcionesHabitaciones
                    .map((n) => DropdownMenuItem(value: n, child: Text("$n")))
                    .toList(),
                onChanged: (v) => setState(() => habitaciones = v),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            const SizedBox(width: 120, child: Text("Baños:")),
            Expanded(
              child: DropdownButtonFormField<int>(
                value: banos,
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                hint: const Text("---"),
                items: opcionesBanos
                    .map((n) => DropdownMenuItem(value: n, child: Text("$n")))
                    .toList(),
                onChanged: (v) => setState(() => banos = v),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),
        _cb(
          text: "Terraza",
          value: terraza,
          onChanged: (v) => setState(() => terraza = v ?? false),
        ),
        _cb(
          text: "Garaje",
          value: garaje,
          onChanged: (v) => setState(() => garaje = v ?? false),
        ),
        _cb(
          text: "Trastero",
          value: trastero,
          onChanged: (v) => setState(() => trastero = v ?? false),
        ),
      ],
    );
  }

  Widget _seccionEconomia() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Economía"),
        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          value: operacion,
          decoration: InputDecoration(
            labelText: 'Tipo de operación',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'Alquilar', child: Text('Alquiler')),
            DropdownMenuItem(value: 'Comprar', child: Text('Compra')),
          ],
          onChanged: (v) {
            setState(() {
              operacion = v!;
              _ajustarPrecioPorOperacion();
            });
          },
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            const SizedBox(width: 70, child: Text("Precio:")),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 6,
                  activeTrackColor: const Color(0xFF90EE90),
                  thumbColor: const Color(0xFF90EE90),
                  overlayColor: const Color(0x3390EE90),
                  rangeThumbShape: const RoundRangeSliderThumbShape(
                    enabledThumbRadius: 6,
                  ),
                ),
                child: RangeSlider(
                  values: precioRango,
                  min: operacion == 'Alquilar' ? 300 : 60000,
                  max: operacion == 'Alquilar' ? 3000 : 450000,
                  divisions: operacion == 'Alquilar' ? 270 : 390,
                  onChanged: (values) => setState(() => precioRango = values),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 140,
              child: Text(
                "${precioRango.start.round()}€ - ${precioRango.end.round()}€",
                textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            const Expanded(child: Text("Gastos incluidos")),
            Switch(
              value: gastos,
              onChanged: (v) => setState(() => gastos = v),
              activeThumbColor: const Color(0xFF90EE90),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(child: Text("Ayudas")),
            Switch(
              value: ayudas,
              onChanged: (v) => setState(() => ayudas = v),
              activeThumbColor: const Color(0xFF90EE90),
            ),
          ],
        ),
        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          value: regimen,
          decoration: InputDecoration(
            labelText: 'Régimen',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
          ),
          items: tiposRegimen
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => regimen = v),
        ),
      ],
    );
  }

  Widget _botonAplicar() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          final colectivosSeleccionados = <String>[
            if (mayores) 'Mayores',
            if (jovenes) 'Jóvenes',
            if (familias) 'Familias',
            if (discapacidad) 'Discapacidad',
          ];

          final serviciosSeleccionados = <String>[
            if (centrosSalud) 'Centros de salud',
            if (transporte) 'Transporte público',
            if (centrosEducativos) 'Centros educativos',
          ];

          final filtros = Filtros(
            calificacionEnergetica: calificacion,
            maxEmisionesCo2: emisiones,
            viviendaAdaptada: viviendaAdaptada,
            mascotas: mascotas,
            zonasVerdes: zonasVerdes,
            colectivos: colectivosSeleccionados,
            servicios: serviciosSeleccionados,
            precioMin: precioRango.start,
            precioMax: precioRango.end,
            gastosIncluidos: gastos,
            ayudas: ayudas,
            operacion: operacion,
          );

          context.go('/resultados', extra: filtros);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF90EE90),
          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 18),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        child: const Text(
          "Aplicar filtros",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF90EE90),
        title: const Center(
          child: Text(
            "Filtros Avanzados",
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Cerrar',
            onPressed: () => _cerrar(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 1100;

          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isWide ? 1100 : 720),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: isWide
                      ? Wrap(
                          spacing: 24,
                          runSpacing: 24,
                          children: [
                            SizedBox(
                              width: 520,
                              child: _seccionSostenibilidad(),
                            ),
                            SizedBox(
                              width: 520,
                              child: _seccionAccesibilidad(),
                            ),
                            _divider,
                            SizedBox(width: 520, child: _seccionColectivos()),
                            SizedBox(width: 520, child: _seccionServicios()),
                            _divider,
                            SizedBox(
                              width: 520,
                              child: _seccionCaracteristicas(),
                            ),
                            SizedBox(width: 520, child: _seccionEconomia()),
                            const SizedBox(height: 8),
                            SizedBox(width: 1100, child: _botonAplicar()),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _seccionSostenibilidad(),
                            _divider,
                            _seccionAccesibilidad(),
                            _divider,
                            _seccionColectivos(),
                            _divider,
                            _seccionServicios(),
                            _divider,
                            _seccionCaracteristicas(),
                            _divider,
                            _seccionEconomia(),
                            const SizedBox(height: 24),
                            _botonAplicar(),
                            const SizedBox(height: 16),
                          ],
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
