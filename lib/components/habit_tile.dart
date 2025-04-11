import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final bool habitCompleted;
  final ValueChanged<bool?> onChanged; // Changed to ValueChanged<bool?>
  final VoidCallback settingsTapped;
  final VoidCallback deleteTapped;

  const HabitTile({
    super.key,
    required this.habitName,
    required this.habitCompleted,
    required this.onChanged,
    required this.settingsTapped,
    required this.deleteTapped,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      // Removed GestureDetector, added onTap to Slidable
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: Slidable(
        key: Key(habitName),
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => settingsTapped(),
              backgroundColor: colorScheme.secondary,
              foregroundColor: colorScheme.inversePrimary,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => deleteTapped(),
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: GestureDetector(
          // Added GestureDetector inside Slidable
          onTap: () {
            onChanged(!habitCompleted); // Toggle completion on tap
          },
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withAlpha(128),
                  blurRadius: 6,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Checkbox(
                  value: habitCompleted,
                  onChanged: onChanged,
                  activeColor: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    habitName,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      decoration:
                          habitCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                      decorationColor:
                          habitCompleted
                              ? colorScheme.onSurface
                              : null, // Apply color conditionally
                      color:
                          habitCompleted
                              ? colorScheme.onSurface.withAlpha(128)
                              : colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
