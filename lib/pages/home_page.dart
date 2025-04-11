import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_tracker/components/habit_tile.dart';
import 'package:habit_tracker/components/drawer_component.dart';
import 'package:habit_tracker/components/heatmap_component.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:habit_tracker/theme/theme_provider.dart';
import 'package:habit_tracker/utils/habit_util.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  // Changed to StatefulWidget
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Added State class
  final _newHabitNameController =
      TextEditingController(); // Controller for text field
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initialize data when the widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HabitDatabase>(context, listen: false).readHabits().then((_) {
        // After habits are used, scroll to the bottom if there are any
        if (Provider.of<HabitDatabase>(
          context,
          listen: false,
        ).habits.isNotEmpty) {
          _scrollToBottom();
        }
      });
    });
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Confirm dialog to create a new habit
  void createNewHabit() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Create New Habit"),
            content: TextField(
              controller: _newHabitNameController,
              decoration: const InputDecoration(hintText: "Enter habit name"),
            ),
            actions: [
              // Save button
              MaterialButton(
                onPressed: () {
                  String newHabitName = _newHabitNameController.text;
                  if (newHabitName.isNotEmpty) {
                    context.read<HabitDatabase>().createHabit(newHabitName);
                    Navigator.pop(context);
                    _newHabitNameController.clear();
                  }
                },
                child: const Text("Save"),
              ),
              // Cancel button
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  _newHabitNameController.clear();
                },
                child: const Text("Cancel"),
              ),
            ],
          ),
    );
  }

  // Edit habit dialog
  void editHabit(int id, String oldName) {
    _newHabitNameController.text = oldName; // Populate text field with old name

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Edit Habit"),
            content: TextField(
              controller: _newHabitNameController,
              decoration: const InputDecoration(
                hintText: "Enter new habit name",
              ),
            ),
            actions: [
              // Save button
              MaterialButton(
                onPressed: () {
                  String newHabitName = _newHabitNameController.text;
                  if (newHabitName.isNotEmpty) {
                    context.read<HabitDatabase>().editHabit(id, newHabitName);
                    Navigator.pop(context);
                    _newHabitNameController.clear();
                  }
                },
                child: const Text("Save"),
              ),
              // Cancel button
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  _newHabitNameController.clear();
                },
                child: const Text("Cancel"),
              ),
            ],
          ),
    );
  }

  // Delete habit dialog
  void deleteHabit(int id, String habitName) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Confirm Delete"),
            content: Text(
              "Are you sure you want to delete the habit: $habitName?",
            ),
            // Display habit name
            actions: [
              // Delete button
              MaterialButton(
                onPressed: () {
                  context.read<HabitDatabase>().deleteHabit(id);
                  Navigator.pop(context);
                },
                child: const Text("Delete"),
              ),
              // Cancel button
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final habitDb = Provider.of<HabitDatabase>(context);

    Widget content;

    if (habitDb.habits.isEmpty) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          children: [
            Lottie.asset(
              'assets/not-found.json',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20), // Add some spacing
            Text(
              "No habits yet! Tap the '+' button to add one.",
              style:
                  Theme.of(
                    context,
                  ).textTheme.titleMedium, // Use a text style from your theme
              textAlign: TextAlign.center, // Center the text horizontally
            ),
          ],
        ),
      );
    } else {
      content = ListView(
        controller: _scrollController,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "🔥 Weekly Activity Heatmap",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.tertiary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: HeatmapComponent(
              startDate: DateTime.now().subtract(const Duration(days: 6)),
              datasets: heatMapDataset(
                habitDb.habits,
              ), // Use data from the database
            ),
          ),
          const Divider(thickness: 1),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Today's Habits",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.tertiary,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...List.generate(habitDb.habits.length, (index) {
            final habit = habitDb.habits[index];
            final habitCompleted = isHabitCompletedToday(habit.completedDays);
            return HabitTile(
              habitName: habit.habitName,
              habitCompleted: habitCompleted,
              onChanged:
                  (value) => habitDb.toggleHabitCompletion(habit.id, value!),
              // Use habit.id
              settingsTapped: () => editHabit(habit.id, habit.habitName),
              // Pass id and name
              deleteTapped:
                  () => deleteHabit(
                    habit.id,
                    habit.habitName,
                  ), // Pass id and name
            );
          }),
          const SizedBox(height: 20),
        ],
      );
    }

    return Scaffold(
      drawer: const DrawerComponent(),
      appBar: AppBar(
        title: Text(
          "Habit Tracker",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CupertinoSwitch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged:
                  (value) =>
                      Provider.of<ThemeProvider>(
                        context,
                        listen: false,
                      ).toggleTheme(),
              activeTrackColor: colorScheme.primary,
            ),
          ),
        ],
      ),
      backgroundColor: colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit, // Open create habit dialog
        backgroundColor: colorScheme.primary,
        child: const Icon(Icons.add),
      ),
      body: content,
    );
  }

  @override
  void dispose() {
    _newHabitNameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
