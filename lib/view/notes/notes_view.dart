import 'package:flutter/material.dart';
import 'package:new1/services/auth/auth_service.dart';
import 'package:new1/services/crud/notes_service.dart';
import 'package:new1/utilities/dialogs/logout_dialog.dart';
import 'package:new1/view/notes/notes_list_view.dart';
import '../../constants/routes.dart';
import '../../enums/menu_action.dart';

class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("You're Notes"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text('Log out')),
              ];
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                    stream: _notesService.allNotes,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          if (snapshot.hasData) {
                            final allNotes =
                                snapshot.data as List<DatabaseNote>;
                            return NotesListView(
                              notes: allNotes,
                              onDeleteNote: (note) async {
                                await _notesService.deleteNote(id: note.id);
                              },
                              onTap: (note) {
                                Navigator.of(context).pushNamed(
                                    createOrUpdateNoteRoute,
                                    arguments: note);
                              },
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        default:
                          return const CircularProgressIndicator();
                      }
                    });
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}
