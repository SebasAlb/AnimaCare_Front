import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:animacare_front/presentation/screens/contacts/Agendar_Cita/agendar_cita_controller.dart';

class AgendarCitaScreen extends StatefulWidget {
  const AgendarCitaScreen({super.key});

  @override
  State<AgendarCitaScreen> createState() => _AgendarCitaScreenState();
}

class _AgendarCitaScreenState extends State<AgendarCitaScreen> {
  final AgendarCitaController controller = AgendarCitaController();

  InputDecoration _inputDecoration(String label) => InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      filled: true,
      fillColor: const Color(0xFF4B1B3F),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    );

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: const Color(0xFF7B4A91),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            const Center(
              child: Text(
                'Agendar Cita',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFE066),
                ),
              ),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: controller.mascotaSeleccionada,
              decoration: _inputDecoration('Mascota'),
              dropdownColor: const Color(0xFF4B1B3F),
              iconEnabledColor: Colors.white,
              style: const TextStyle(color: Colors.white),
              items: controller.mascotas
                  .map((String m) => DropdownMenuItem(
                      value: m,
                      child:
                          Text(m, style: const TextStyle(color: Colors.white)),),)
                  .toList(),
              onChanged: (String? value) =>
                  setState(() => controller.mascotaSeleccionada = value),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: controller.razonSeleccionada,
              decoration: _inputDecoration('Razón de la cita'),
              dropdownColor: const Color(0xFF4B1B3F),
              iconEnabledColor: Colors.white,
              style: const TextStyle(color: Colors.white),
              items: controller.razones
                  .map((String r) => DropdownMenuItem(
                      value: r,
                      child:
                          Text(r, style: const TextStyle(color: Colors.white)),),)
                  .toList(),
              onChanged: (String? value) =>
                  setState(() => controller.razonSeleccionada = value),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: controller.veterinarioSeleccionado,
              decoration: _inputDecoration('Veterinario'),
              dropdownColor: const Color(0xFF4B1B3F),
              iconEnabledColor: Colors.white,
              style: const TextStyle(color: Colors.white),
              items: controller.veterinarios
                  .map((String v) => DropdownMenuItem(
                      value: v,
                      child:
                          Text(v, style: const TextStyle(color: Colors.white)),),)
                  .toList(),
              onChanged: (String? value) =>
                  setState(() => controller.veterinarioSeleccionado = value),
            ),
            const SizedBox(height: 14),
            ListTile(
              onTap: () async {
                await controller.seleccionarFecha(context);
                setState(() {});
              },
              tileColor: const Color(0xFF4B1B3F),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              title: const Text('Fecha', style: TextStyle(color: Colors.white)),
              subtitle: Text(
                controller.fechaSeleccionada != null
                    ? DateFormat('dd/MM/yyyy')
                        .format(controller.fechaSeleccionada!)
                    : 'No seleccionada',
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: const Icon(Icons.calendar_today, color: Colors.white),
            ),
            const SizedBox(height: 14),
            ListTile(
              onTap: () async {
                await controller.mostrarSelectorHora(
                    context, () => setState(() {}),);
              },
              tileColor: const Color(0xFF4B1B3F),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              title: const Text('Hora', style: TextStyle(color: Colors.white)),
              subtitle: Text(
                controller.horaSeleccionada ?? 'No seleccionada',
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: const Icon(Icons.access_time, color: Colors.white),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller.notasController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('Notas adicionales (opcional)'),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => controller.confirmarCita(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFE066),
                foregroundColor: const Color(0xFF4B1B3F),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),),
              ),
              icon: const Icon(Icons.check),
              label: const Text('Confirmar cita'),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton(
            backgroundColor: const Color(0xFFFFE066).withOpacity(0.9),
            onPressed: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Color(0xFF4B1B3F)),
          ),
        ),
      ),
    );
}
