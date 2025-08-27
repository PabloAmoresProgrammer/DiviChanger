import 'dart:collection';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Monedas seleccionadas para la conversión.
  String monedaOrigen = "USD";
  String monedaDestino = "EUR";

  // Tipo de cambio actual entre la moneda de origen y la de destino.
  double tipoCambio = 0.0;

  // Monto convertido según la cantidad ingresada y el tipo de cambio.
  double montoConvertido = 0.0;

  // Controlador para el campo de texto donde se ingresa la cantidad a convertir.
  final TextEditingController controladorCantidad = TextEditingController();

  // Listas de monedas disponibles y las marcadas como favoritas.
  List<String> monedasDisponibles = [];
  List<String> monedasFavoritas = [];

  // Instancia de Firestore y de los servicios auxiliares para obtener el tipo de cambio y gestionar datos del usuario.
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final ExchangeRateService servicioTipoCambio;
  late final UserDataService servicioDatosUsuario;

  @override
  void initState() {
    super.initState();

    if (FirebaseAuth.instance.currentUser == null) {
      // Redirigir al login si no hay usuario autenticado
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    } else {
      // Inicializar los servicios solo si el usuario está autenticado
      servicioTipoCambio = ExchangeRateService();
      servicioDatosUsuario = UserDataService(firestore: firestore);

      _cargarMonedas();
      _cargarFavoritos();
    }
  }

  /// Carga la lista de monedas favoritas del usuario desde Firestore.
  Future<void> _cargarFavoritos() async {
    List<String> favoritos = await servicioDatosUsuario.loadFavorites();
    setState(() {
      monedasFavoritas = favoritos;
    });
  }

  /// Alterna el estado de favorito para una moneda y actualiza la lista de favoritos.
  Future<void> _alternarFavorito(String moneda) async {
    List<String> nuevaListaFavoritos = List.from(monedasFavoritas);

    if (monedasFavoritas.contains(moneda)) {
      nuevaListaFavoritos.remove(moneda);
    } else {
      nuevaListaFavoritos.add(moneda);
    }

    await servicioDatosUsuario.updateFavorites(nuevaListaFavoritos);

    setState(() {
      monedasFavoritas = nuevaListaFavoritos;
    });
  }

  /// Actualiza el monto convertido según la cantidad ingresada y el tipo de cambio actual.
  /// Además, registra la conversión en el historial de Firestore.
  void _actualizarMontoConvertido() async {
    if (controladorCantidad.text.isNotEmpty) {
      double cantidad = double.tryParse(controladorCantidad.text) ?? 0.0;
      setState(() {
        montoConvertido = cantidad * tipoCambio;
      });
      // Registrar la conversión en el historial.
      await servicioDatosUsuario.logConversion(
        sourceCurrency: monedaOrigen,
        targetCurrency: monedaDestino,
        amount: cantidad,
        convertedAmount: montoConvertido,
        exchangeRate: tipoCambio,
      );
    }
  }

  /// Carga la lista de monedas disponibles y establece la tasa de cambio inicial.
  Future<void> _cargarMonedas() async {
    try {
      var data = await servicioTipoCambio.fetchRates("USD");
      setState(() {
        monedasDisponibles =
            (data['rates'] as Map<String, dynamic>).keys.toList();
        tipoCambio = data['rates'][monedaDestino] ?? 0.0;
      });
    } catch (e) {
      debugPrint('Error al cargar las monedas: $e');
    }
  }

  /// Actualiza la tasa de cambio según la moneda de origen seleccionada.
  Future<void> _actualizarTipoCambio() async {
    // Si la moneda de origen y destino son iguales, la tasa es 1.
    if (monedaOrigen == monedaDestino) {
      setState(() {
        tipoCambio = 1.0;
        _actualizarMontoConvertido();
      });
      return;
    }

    try {
      var data = await servicioTipoCambio.fetchRates(monedaOrigen);
      setState(() {
        tipoCambio = data['rates'][monedaDestino] ?? 0.0;
        _actualizarMontoConvertido();
      });
    } catch (e) {
      debugPrint('Error al actualizar el tipo de cambio: $e');
    }
  }

  /// Intercambia la moneda de origen y la de destino, y actualiza la tasa de cambio.
  void _intercambiarMonedas() {
    setState(() {
      final temp = monedaOrigen;
      monedaOrigen = monedaDestino;
      monedaDestino = temp;
      _actualizarTipoCambio();
    });
  }

  /// Construye los elementos del Dropdown combinando las monedas favoritas y disponibles.
  List<DropdownMenuItem<String>> _construirItemsDropdown() {
    // Usar LinkedHashSet para mantener el orden y eliminar duplicados.
    // ignore: prefer_collection_literals
    final monedasOrdenadas = LinkedHashSet<String>.from(
      [...monedasFavoritas, ...monedasDisponibles],
    ).toList();

    return monedasOrdenadas.map((moneda) {
      return DropdownMenuItem<String>(
        value: moneda,
        // Utilizar StatefulBuilder para permitir actualizar solo este ítem al cambiar el estado de favorito.
        child: StatefulBuilder(
          builder: (context, setStateLocal) {
            bool esFavorita = monedasFavoritas.contains(moneda);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Muestra el nombre de la moneda, truncando el texto si es necesario.
                Expanded(
                  child: Text(
                    moneda,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Botón para alternar el estado de favorito de la moneda.
                IconButton(
                  icon: Icon(
                    esFavorita ? Icons.star : Icons.star_border,
                    color: esFavorita ? Colors.yellow : Colors.grey,
                  ),
                  onPressed: () async {
                    await _alternarFavorito(moneda);
                    // Actualiza el estado de este ítem de la lista.
                    setStateLocal(() {});
                  },
                ),
              ],
            );
          },
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff259AC5),
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text("CONVERSOR"),
      ),
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Logo de la aplicación.
              Padding(
                padding: const EdgeInsets.all(40),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: MediaQuery.of(context).size.width / 2,
                ),
              ),
              // Campo para ingresar la cantidad a convertir.
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: TextField(
                  controller: controladorCantidad,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Cantidad",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Fila de selección de monedas de origen y destino.
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Dropdown para seleccionar la moneda de origen.
                    SizedBox(
                      width: 115,
                      child: CustomDropdown(
                        selectedValue: monedaOrigen,
                        items: _construirItemsDropdown(),
                        onChanged: (nuevoValor) {
                          setState(() {
                            monedaOrigen = nuevoValor;
                            _actualizarTipoCambio();
                          });
                        },
                      ),
                    ),
                    // Botón para intercambiar las monedas.
                    IconButton(
                      onPressed: _intercambiarMonedas,
                      icon: const Icon(Icons.swap_horiz),
                    ),
                    // Dropdown para seleccionar la moneda de destino.
                    SizedBox(
                      width: 115,
                      child: CustomDropdown(
                        selectedValue: monedaDestino,
                        items: _construirItemsDropdown(),
                        onChanged: (nuevoValor) {
                          setState(() {
                            monedaDestino = nuevoValor;
                            _actualizarTipoCambio();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Botón para realizar la conversión.
              ElevatedButton(
                onPressed: _actualizarMontoConvertido,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff246382),
                ),
                child: const Text(
                  "CONVERTIR",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              // Mostrar el tipo de cambio actual y el resultado de la conversión.
              Text(
                "Rate $tipoCambio",
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
              const SizedBox(height: 2),
              Text(
                montoConvertido.toStringAsFixed(3),
                style: const TextStyle(
                  color: Color(0xff259AC5),
                  fontSize: 40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
