import 'package:flutter/material.dart';
import 'package:readthevoice/data/db/rtv_database.dart';
import 'package:readthevoice/data/model/meeting.dart';

class HomeScreen extends StatefulWidget {
  final AppDatabase database;

  const HomeScreen({super.key, required this.database});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

  late final AppDatabase database = widget.database;

  Future<List<Meeting>> retrieveMeetings() async {
    return await database.meetingDao.findAllMeeting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: FutureBuilder(
        future: retrieveMeetings(),
        builder: (BuildContext context, AsyncSnapshot<List<Meeting>> snapshot) {
          if (snapshot.hasData) {
            return (snapshot.data!.isNotEmpty)
                ? ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: const Icon(Icons.delete_forever),
                        ),
                        key: ValueKey<String>(snapshot.data![index].id),
                        onDismissed: (DismissDirection direction) async {
                          await database.meetingDao
                              .deleteMeeting(snapshot.data![index].id);
                          setState(() {
                            snapshot.data!.remove(snapshot.data![index]);
                          });
                        },
                        child: Card(
                            color: Colors.teal,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8.0),
                              title: Text(snapshot.data![index].title),
                              subtitle: Text(snapshot.data![index].transcription
                                  .toString()),
                            )),
                      );
                    },
                  )
                : const Text("No Data");
          } else {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.teal,
            ));
          }
        },
      ),
    ));
  }
}

/*
Future<List<User>> retrieveUsers() async {
    return await this.database.userDAO.retrieveUsers();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: FutureBuilder(
        future: this.retrieveUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(Icons.delete_forever),
                  ),
                  key: ValueKey<int>(snapshot.data![index].id!),
                  onDismissed: (DismissDirection direction) async {
                    await this
                        .database
                        .userDAO
                        .deleteUser(snapshot.data![index].id!);
                    setState(() {
                      snapshot.data!.remove(snapshot.data![index]);
                    });
                  },
                  child: Card(
                      child: ListTile(
                    contentPadding: EdgeInsets.all(8.0),
                    title: Text(snapshot.data![index].name),
                    subtitle: Text(snapshot.data![index].age.toString()),
                  )),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

 */
