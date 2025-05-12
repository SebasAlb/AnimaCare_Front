import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/presentation/screens/home/Agregar_Mascota/agregar_mascota_controller.dart';

class AgregarMascotaScreen extends StatefulWidget {
  const AgregarMascotaScreen({super.key});

  @override
  State<AgregarMascotaScreen> createState() => _AgregarMascotaScreenState();
}

class _AgregarMascotaScreenState extends State<AgregarMascotaScreen> {
  final AgregarMascotaController controller = AgregarMascotaController();

  @override
  void initState() {
    super.initState();
    controller.initControllers();
  }

  @override
  void dispose() {
    controller.disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: controller.fondo,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                const CustomHeader(
                  petName: 'Gato 1',
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: <Widget>[
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          'Agregar Mascota',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: controller.primario,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildInput('Nombre', controller.nombreController),
                      _buildInput('Raza', controller.razaController),
                      _buildInput('Peso (kg)', controller.pesoController,
                          keyboardType: TextInputType.number,),
                      _buildInput('Altura (cm)', controller.alturaController,
                          keyboardType: TextInputType.number,),
                      GestureDetector(
                        onTap: () =>
                            controller.seleccionarFecha(context, (String fecha) {
                          setState(() {
                            controller.fechaNacimientoController.text = fecha;
                          });
                        }),
                        child: AbsorbPointer(
                          child: _buildInput('Cumpleaños',
                              controller.fechaNacimientoController,),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('Sexo',
                          style: TextStyle(color: controller.primario),),
                      Row(
                        children: <String>['Macho', 'Hembra'].map((String option) => Expanded(
                            child: RadioListTile(
                              title: Text(option,
                                  style: TextStyle(color: controller.primario),),
                              value: option,
                              groupValue: controller.sexo,
                              activeColor: controller.acento,
                              onChanged: (value) {
                                setState(
                                    () => controller.sexo = value.toString(),);
                              },
                            ),
                          ),).toList(),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.acento,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          controller.guardarMascota(context);
                        },
                        child: const Text(
                          'Guardar Mascota',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Opacity(
                opacity: 0.85,
                child: FloatingActionButton(
                  heroTag: 'btnRegresarAgregar',
                  backgroundColor: controller.acento,
                  onPressed: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back, color: controller.fondo),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  Widget _buildInput(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,}) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(color: this.controller.primario)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(
              color: this.controller.primario, fontWeight: FontWeight.w500,),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
}
