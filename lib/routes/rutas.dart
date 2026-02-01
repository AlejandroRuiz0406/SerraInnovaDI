import 'package:go_router/go_router.dart';
import '../models/vivienda.dart';
import '../pages/filtros_page.dart';
import '../pages/home_page.dart';
import '../pages/resultados_page.dart';
import '../models/filtros.dart';
import 'package:serra_innova/models/filtros_origen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/', 
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/filtros-avanzados',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        final origen =
            (extra?['origen'] as FiltrosOrigen?) ?? FiltrosOrigen.home;
        final filtros = extra?['filtros'] as Filtros?;

        return FiltrosAvanzadosPage(origen: origen, filtrosIniciales: filtros);
      },
    ),
    GoRoute(
      path: '/resultados',
      builder: (context, state) {
        //final filtros = state.extra as Filtros;
        return ResultadosPage();
      },
    ),
  ],
);
