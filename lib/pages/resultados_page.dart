import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/filtros.dart';
import '../models/vivienda.dart';
import 'package:serra_innova/models/filtros_origen.dart';
import 'package:provider/provider.dart';
import 'package:serra_innova/provider/provider.dart'; 

class ResultadosPage extends StatefulWidget {
  const ResultadosPage({super.key}); 

  @override
  State<ResultadosPage> createState() => _ResultadosPageState();
}

class _ResultadosPageState extends State<ResultadosPage> {
  //Trae las viviendas desde Firestore
  Query<Map<String, dynamic>> _buildQuery() {
    return FirebaseFirestore.instance.collection('viviendas');
  }

  //Aplica todos los filtros en cliente para evitar errores de índices.
  List<Vivienda> _filtrarEnCliente(List<Vivienda> lista, Filtros filtros) {
    final f = filtros;

    return lista.where((v) {
      // Operación (Comprar / Alquilar)
      if (f.operacion != null && f.operacion!.isNotEmpty) {
        if (v.operacion != f.operacion) return false;
      }

      if (f.provincia != null && f.provincia!.isNotEmpty) {
        if (v.provincia != f.provincia) return false;
      }

      if (f.municipio != null && f.municipio!.isNotEmpty) {
        if (v.municipio != f.municipio) return false;
      }

      //Precio
      if (v.precio < f.precioMin || v.precio > f.precioMax) return false;

      //Emisiones
      if (v.emisionesCo2 > f.maxEmisionesCo2) return false;

      //Switches
      if (f.mascotas && !v.mascotas) return false;
      if (f.viviendaAdaptada && !v.viviendaAdaptada) return false;
      if (f.zonasVerdes && !v.zonasVerdes) return false;

      //Colectivos
      if (f.colectivos.isNotEmpty &&
          !f.colectivos.any((c) => v.colectivos.contains(c))) {
        return false;
      }

      //Servicios
      if (f.servicios.isNotEmpty &&
          !f.servicios.any((s) => v.servicios.contains(s))) {
        return false;
      }

      // Superficie
      if (f.superficieMin != null && v.superficie < f.superficieMin!)
        return false;
      if (f.superficieMax != null && v.superficie > f.superficieMax!)
        return false;

      // Habitaciones
      if (f.habitaciones != null) {
        if (f.habitaciones == 5) {
          if (v.habitaciones < 5) return false;
        } else {
          if (v.habitaciones != f.habitaciones) return false;
        }
      }

      // Extras
      if (f.terraza == true && v.terraza != true) return false;
      if (f.garaje == true && v.garaje != true) return false;
      if (f.trastero == true && v.trastero != true) return false;

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final viviendaProvider = Provider.of<ViviendaProvider>(context);
    final filtrosActuales = viviendaProvider.filtros;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF90EE90),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => context.go('/'),
            child: Image.asset(
              '../assets/LogoSerraInnova.jpg',
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Center(
          child: Text("SerraInnova", style: TextStyle(color: Colors.white)),
        ),
        actions: [
          IconButton(
            tooltip: "Filtros",
            onPressed: () {
              context.push(
                '/filtros-avanzados',
                extra: {
                  'origen': FiltrosOrigen.resultados,
                  'filtros': filtrosActuales,
                },
              );
            },
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Resultados de búsqueda",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Expanded(
                        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: _buildQuery().snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text("Error: ${snapshot.error}"),
                              );
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            final docs = snapshot.data?.docs ?? [];

                            final List<Vivienda> resultadosBrutos = docs
                                .map(
                                  (doc) => Vivienda.fromMap(doc.id, doc.data()),
                                )
                                .toList();

                            final List<Vivienda> resultados = _filtrarEnCliente(
                              resultadosBrutos,
                              filtrosActuales,
                            );

                            if (resultados.isEmpty) {
                              return const Center(
                                child: Text(
                                  "No se encontraron viviendas con los filtros aplicados.",
                                ),
                              );
                            }

                            return ListView.separated(
                              itemBuilder: (context, i) {
                                final v = resultados[i];
                                return _ResultadoCard(v: v);
                              },
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 12),
                              itemCount: resultados.length,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                SizedBox(
                  width: 280,
                  child: _FiltrosAplicadosPanel(filtros: filtrosActuales),
                ),
              ],
            ),
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

class _ResultadoCard extends StatelessWidget {
  final Vivienda v;
  const _ResultadoCard({required this.v});

  @override
  Widget build(BuildContext context) {
    final _fmt = NumberFormat.currency(
      locale: 'es_ES',
      symbol: '€',
      decimalDigits: 0,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 90,
              height: 70,
              child: v.imageUrl.isNotEmpty
                  ? Image.network(
                      v.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      },
                      errorBuilder: (_, __, ___) => const Icon(Icons.home),
                    )
                  : const Icon(Icons.home),
            ),
          ),

          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _fmt.format(v.precio),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  "${v.municipio}, ${v.provincia}",
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _chip("Sostenible"),
                    if (v.viviendaAdaptada) _chip("Accesible"),
                    if (v.mascotas) _chip("Mascotas"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF7EF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF90EE90)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}

class _FiltrosAplicadosPanel extends StatelessWidget {
  final Filtros filtros;
  const _FiltrosAplicadosPanel({required this.filtros});

  @override
  Widget build(BuildContext context) {
    final _fmt = NumberFormat.currency(
      locale: 'es_ES',
      symbol: '€',
      decimalDigits: 0,
    );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filtros aplicados",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          _item(
            "Precio",
            "${_fmt.format(filtros.precioMin)} - ${_fmt.format(filtros.precioMax)}",
          ),

          _item(
            "Emisiones",
            "≤ ${filtros.maxEmisionesCo2.round()} kg CO₂ / m²·año",
          ),

          _item("Mascotas", filtros.mascotas ? "Sí" : "No"),
          _item("Accesible", filtros.viviendaAdaptada ? "Sí" : "No"),
          _item("Zonas verdes", filtros.zonasVerdes ? "Sí" : "No"),

          if (filtros.colectivos.isNotEmpty)
            _item("Colectivos", filtros.colectivos.join(", ")),

          if (filtros.servicios.isNotEmpty)
            _item("Servicios", filtros.servicios.join(", ")),

          if (filtros.provincia != null && filtros.provincia!.isNotEmpty)
            _item("Provincia", filtros.provincia!),

          if (filtros.municipio != null && filtros.municipio!.isNotEmpty)
            _item("Municipio", filtros.municipio!),
        ],
      ),
    );
  }

  Widget _item(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(valor),
        ],
      ),
    );
  }
}
