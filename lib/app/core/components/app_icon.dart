import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class AppIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;

  const AppIcon({
    super.key,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  const AppIcon.flightsmode({
    super.key,
    this.icon = Symbols.flightsmode,
    this.backgroundColor = const Color(0xFFffc5b0),
    this.foregroundColor = const Color(0xFFf6f9f9),
  });

  const AppIcon.savings({
    super.key,
    this.icon = Symbols.savings,
    this.backgroundColor = const Color(0xFFffc367),
    this.foregroundColor = const Color(0xFFf6f9f9),
  });
  const AppIcon.fitnessCenter({
    super.key,
    this.icon = Symbols.fitness_center,
    this.backgroundColor = const Color(0xFF99dcff),
    this.foregroundColor = const Color(0xFFf6f9f9),
  });
  const AppIcon.directionsBike({
    super.key,
    this.icon = Symbols.directions_bike,
    this.backgroundColor = const Color(0xFFffc367),
    this.foregroundColor = const Color(0xFFf6f9f9),
  });
  const AppIcon.favorite({
    super.key,
    this.icon = Symbols.favorite,
    this.backgroundColor = const Color(0xFF99dcff),
    this.foregroundColor = const Color(0xFFf6f9f9),
  });
  const AppIcon.park({
    super.key,
    this.icon = Symbols.park,
    this.backgroundColor = const Color(0xFFffc5b0),
    this.foregroundColor = const Color(0xFFf6f9f9),
  });
  const AppIcon.flag({
    super.key,
    this.icon = Symbols.flag,
    this.backgroundColor = const Color(0xFFffc367),
    this.foregroundColor = const Color(0xFFf6f9f9),
  });
  const AppIcon.childCare({
    super.key,
    this.icon = Symbols.child_care,
    this.backgroundColor = const Color(0xFFffc367),
    this.foregroundColor = const Color(0xFFf6f9f9),
  });

  const AppIcon.addTask({
    super.key,
    this.icon = Symbols.add_task,
    this.backgroundColor = const Color(0xFF99dcff),
    this.foregroundColor = const Color(0xFFf6f9f9),
  });

  const AppIcon.pets({
    super.key,
    this.icon = Symbols.pets,
    this.backgroundColor = const Color(0xFFffc5b0),
    this.foregroundColor = const Color(0xFFf6f9f9),
  });

  const AppIcon.carRental({
    super.key,
    this.icon = Symbols.car_rental,
    this.backgroundColor = const Color(0xFFffc5b0),
    this.foregroundColor = const Color(0xFFf6f9f9),
  });
  const AppIcon.followTheSigns({
    super.key,
    this.icon = Symbols.follow_the_signs,
    this.backgroundColor = const Color(0xFFffc367),
    this.foregroundColor = const Color(0xFFf6f9f9),
  });

  const AppIcon.check({
    super.key,
    this.icon = Symbols.check,
    this.backgroundColor = const Color(0xFF31ac47),
    this.foregroundColor = const Color(0xFFe4fcda),
  });

  const AppIcon.close({
    super.key,
    this.icon = Symbols.close,
    this.backgroundColor = const Color(0xFF8a99a8),
    this.foregroundColor = const Color(0xFFf6f9f9),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: backgroundColor),
      child: Icon(
        icon,
        color: foregroundColor,
      ),
    );
  }
}
