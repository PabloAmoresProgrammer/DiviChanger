import 'package:flutter/material.dart';

/// Widget personalizado de Dropdown que se abre justo debajo del botón.
class CustomDropdown extends StatefulWidget {
  final String selectedValue;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String> onChanged;

  const CustomDropdown({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  /// Muestra o oculta el menú desplegable.
  ///
  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Este contenedor cubre toda la pantalla y cierra el dropdown al tocar fuera.
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                // Si se toca fuera, se cierra el dropdown.
                _toggleDropdown();
              },
              behavior: HitTestBehavior.translucent,
              child: Container(),
            ),
          ),
          // El menú desplegable posicionado justo debajo del botón.
          Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0.0, size.height),
              child: Material(
                elevation: 4,
                child: Container(
                  color: Colors.white, // Fondo blanco
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: widget.items.map((item) {
                      return InkWell(
                        onTap: () {
                          widget.onChanged(item.value!);
                          _toggleDropdown();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: item.child,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  widget.selectedValue,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
