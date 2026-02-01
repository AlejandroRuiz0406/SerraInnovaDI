import 'package:flutter/material.dart';
import 'package:serra_innova/models/filtros.dart';
import 'package:serra_innova/models/vivienda.dart';

class ViviendaProvider with ChangeNotifier {
  List<Vivienda> _viviendas = [];
  Filtros _filtros = Filtros.vacios();

  List<Vivienda> get viviendas => _viviendas;
  Filtros get filtros => _filtros;

  void setViviendas(List<Vivienda> nuevasViviendas) {
    _viviendas = nuevasViviendas;
    notifyListeners();
  }

  void updateFiltros(Filtros nuevosFiltros) {
    _filtros = nuevosFiltros;
    notifyListeners();
  }
}