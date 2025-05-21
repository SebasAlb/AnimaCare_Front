import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.unselectedWidgetColor,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: onTap,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 28),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 28),
            label: 'Contactos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today, size: 28),
            label: 'Calendario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 28),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}
