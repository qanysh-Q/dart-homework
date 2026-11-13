import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themeKey = 'app_theme_dark_mode';
const _nameKey = 'user_display_name';
const _notesKey = 'notes_json';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final isDarkMode = preferences.getBool(_themeKey) ?? false;
  final username = preferences.getString(_nameKey) ?? 'Guest User';
  final notes = _readNotes(preferences);

  runApp(NotesVaultApp(
    preferences: preferences,
    initialDarkMode: isDarkMode,
    initialUsername: username,
    initialNotes: notes,
  ));
}

List<NoteItem> _readNotes(SharedPreferences preferences) {
  final savedJson = preferences.getString(_notesKey);
  if (savedJson == null || savedJson.isEmpty) return [];

  try {
    final decoded = jsonDecode(savedJson);
    if (decoded is! List) return [];
    return decoded
        .whereType<Map>()
        .map((item) => NoteItem.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  } catch (_) {
    // A corrupt or older value should not prevent the app from opening.
    return [];
  }
}

class NoteItem {
  final String id;
  final String title;
  final String dateText;
  final bool isCompleted;

  const NoteItem({
    required this.id,
    required this.title,
    required this.dateText,
    required this.isCompleted,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'dateText': dateText,
        'isCompleted': isCompleted,
      };

  factory NoteItem.fromJson(Map<String, dynamic> json) => NoteItem(
        id: (json['id'] ?? '').toString(),
        title: (json['title'] ?? 'Untitled note').toString(),
        dateText: (json['dateText'] ?? '').toString(),
        isCompleted: json['isCompleted'] == true,
      );
}

class NotesVaultApp extends StatefulWidget {
  final SharedPreferences preferences;
  final bool initialDarkMode;
  final String initialUsername;
  final List<NoteItem> initialNotes;

  const NotesVaultApp({
    super.key,
    required this.preferences,
    required this.initialDarkMode,
    required this.initialUsername,
    required this.initialNotes,
  });

  @override
  State<NotesVaultApp> createState() => _NotesVaultAppState();
}

class _NotesVaultAppState extends State<NotesVaultApp> {
  late bool _isDarkMode = widget.initialDarkMode;
  late String _username =
      widget.initialUsername.isEmpty ? 'Guest User' : widget.initialUsername;
  late List<NoteItem> _notes = List.of(widget.initialNotes);
  final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = _username == 'Guest User' ? '' : _username;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _setDarkMode(bool value) async {
    setState(() => _isDarkMode = value);
    await widget.preferences.setBool(_themeKey, value);
  }

  Future<void> _saveUsername() async {
    final value = _usernameController.text.trim();
    final name = value.isEmpty ? 'Guest User' : value;
    setState(() => _username = name);
    await widget.preferences.setString(_nameKey, name);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Name saved on this device')),
    );
  }

  Future<void> _persistNotes(List<NoteItem> notes) async {
    final jsonString = jsonEncode(notes.map((note) => note.toJson()).toList());
    await widget.preferences.setString(_notesKey, jsonString);
  }

  Future<void> _addNote(String title) async {
    final note = NoteItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      dateText: _formatDate(DateTime.now()),
      isCompleted: false,
    );
    final updated = [note, ..._notes];
    setState(() => _notes = updated);
    await _persistNotes(updated);
  }

  Future<void> _toggleNote(NoteItem note, bool completed) async {
    final updated = _notes
        .map((item) => item.id == note.id
            ? NoteItem(
                id: item.id,
                title: item.title,
                dateText: item.dateText,
                isCompleted: completed,
              )
            : item)
        .toList();
    setState(() => _notes = updated);
    await _persistNotes(updated);
  }

  Future<void> _deleteNote(NoteItem note) async {
    final updated = _notes.where((item) => item.id != note.id).toList();
    setState(() => _notes = updated);
    await _persistNotes(updated);
  }

  Future<void> _showAddNoteDialog() async {
    final controller = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('New note'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 100,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            hintText: 'What do you need to remember?',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) => Navigator.pop(dialogContext, value.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, controller.text.trim()),
            child: const Text('Add note'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (title != null && title.trim().isNotEmpty) await _addNote(title.trim());
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes Vault',
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff5663d8)),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xfff6f7fb),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xffa8b0ff),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: _NotesHomeScreen(
          username: _username,
          usernameController: _usernameController,
          notes: _notes,
          isDarkMode: _isDarkMode,
          onSaveUsername: _saveUsername,
          onDarkModeChanged: _setDarkMode,
          onAddNote: _showAddNoteDialog,
          onToggleNote: _toggleNote,
          onDeleteNote: _deleteNote,
        ),
      );
}

class _NotesHomeScreen extends StatelessWidget {
  final String username;
  final TextEditingController usernameController;
  final List<NoteItem> notes;
  final bool isDarkMode;
  final VoidCallback onSaveUsername;
  final ValueChanged<bool> onDarkModeChanged;
  final VoidCallback onAddNote;
  final void Function(NoteItem, bool) onToggleNote;
  final ValueChanged<NoteItem> onDeleteNote;

  const _NotesHomeScreen({
    required this.username,
    required this.usernameController,
    required this.notes,
    required this.isDarkMode,
    required this.onSaveUsername,
    required this.onDarkModeChanged,
    required this.onAddNote,
    required this.onToggleNote,
    required this.onDeleteNote,
  });

  @override
  Widget build(BuildContext context) {
    final completedCount = notes.where((note) => note.isCompleted).length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes Vault',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'Add note',
            onPressed: onAddNote,
            icon: const Icon(Icons.add_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
              children: [
                _WelcomeCard(username: username, noteCount: notes.length),
                const SizedBox(height: 16),
                _SettingsCard(
                  usernameController: usernameController,
                  isDarkMode: isDarkMode,
                  onSaveUsername: onSaveUsername,
                  onDarkModeChanged: onDarkModeChanged,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(
                      child: Text('Your notes',
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold)),
                    ),
                    if (notes.isNotEmpty)
                      Text('$completedCount/${notes.length} done',
                          style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 10),
                if (notes.isEmpty)
                  const _EmptyNotesCard()
                else
                  ...notes.map((note) => Padding(
                        padding: const EdgeInsets.only(bottom: 9),
                        child: _NoteTile(
                          note: note,
                          onChanged: (value) => onToggleNote(note, value),
                          onDelete: () => onDeleteNote(note),
                        ),
                      )),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onAddNote,
        icon: const Icon(Icons.add),
        label: const Text('Add note'),
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  final String username;
  final int noteCount;
  const _WelcomeCard({required this.username, required this.noteCount});

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.zero,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 27,
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                child: const Icon(Icons.person_outline_rounded, size: 29),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back,',
                          style: Theme.of(context).textTheme.bodyMedium),
                      Text(username,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 3),
                      Text(
                          '$noteCount ${noteCount == 1 ? 'note' : 'notes'} saved offline',
                          style: Theme.of(context).textTheme.bodySmall),
                    ]),
              ),
            ],
          ),
        ),
      );
}

class _SettingsCard extends StatelessWidget {
  final TextEditingController usernameController;
  final bool isDarkMode;
  final VoidCallback onSaveUsername;
  final ValueChanged<bool> onDarkModeChanged;

  const _SettingsCard({
    required this.usernameController,
    required this.isDarkMode,
    required this.onSaveUsername,
    required this.onDarkModeChanged,
  });

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Settings',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: usernameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => onSaveUsername(),
              decoration: InputDecoration(
                labelText: 'Your name',
                hintText: 'Guest User',
                prefixIcon: const Icon(Icons.person_outline),
                border: const OutlineInputBorder(),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(4),
                  child: FilledButton(
                      onPressed: onSaveUsername, child: const Text('Save')),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Dark mode'),
              subtitle: const Text('Saved on this device'),
              secondary: Icon(isDarkMode
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined),
              value: isDarkMode,
              onChanged: onDarkModeChanged,
            ),
          ]),
        ),
      );
}

class _NoteTile extends StatelessWidget {
  final NoteItem note;
  final ValueChanged<bool> onChanged;
  final VoidCallback onDelete;
  const _NoteTile(
      {required this.note, required this.onChanged, required this.onDelete});

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          leading: Checkbox.adaptive(
              value: note.isCompleted,
              onChanged: (value) => onChanged(value ?? false)),
          title: Text(note.title,
              style: TextStyle(
                  decoration:
                      note.isCompleted ? TextDecoration.lineThrough : null)),
          subtitle: Text(note.dateText),
          trailing: IconButton(
            tooltip: 'Delete note',
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
          ),
        ),
      );
}

class _EmptyNotesCard extends StatelessWidget {
  const _EmptyNotesCard();
  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
          child: Column(children: [
            Icon(Icons.sticky_note_2_outlined,
                size: 44, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 10),
            const Text('Nothing here yet',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            const SizedBox(height: 4),
            const Text('Add a note and it will be saved on this device.',
                textAlign: TextAlign.center),
          ]),
        ),
      );
}

String _formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}
