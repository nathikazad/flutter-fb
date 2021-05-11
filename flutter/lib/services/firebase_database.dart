import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/entry.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/job.dart';
import 'package:starter_architecture_flutter_firebase/services/firebase_path.dart';

import '../app/home/models/job.dart';

class Database {
  Database({required this.app, required this.uid});

  final FirebaseDatabase app;
  final String uid;

  String generateId() => app.reference().push().key;

  Future<void> setJob(Job job) {
    final String path = FirebasePath.job(uid, job.id);
    return app.reference().child(path).set(job.toMap());
  }

  Future<void> deleteJob(Job job) async {
    final String path = FirebasePath.job(uid, job.id);
    return app.reference().child(path).remove();
  }

  Stream<Job> jobStream({required String jobId}) {
    final String path = FirebasePath.job(uid, jobId);
    print(path);
    final eventStream = app.reference().child(path).onValue;
    return eventStream.map<Job>((event) {
      return Job.fromJSON(event.snapshot.value, event.snapshot.key.toString());
    });
  }

  Stream<List<Job>> jobsStream() {
    final String path = FirebasePath.jobs(uid);
    final eventStream = app.reference().child(path).onValue;
    return eventStream.map<List<Job>>((event) {
      final List<Job> list = [];
      event.snapshot.value.forEach((dynamic key, dynamic value) {
        try {
          final Job job = Job.fromJSON(value, key);
          list.add(job);
        } catch (e) {
          print(e);
        }
      });
      return list;
    });
  }

  Future<void> setEntry(Entry entry) {
    final String path = FirebasePath.entry(uid, entry.id);
    return app.reference().child(path).set(entry.toMap());
  }

  Future<void> deleteEntry(Entry entry) async {
    final String path = FirebasePath.entry(uid, entry.id);
    return app.reference().child(path).remove();
  }

  Stream<List<Entry>> entriesStream({Job? job}) {
    final String path = FirebasePath.entries(uid);
    print(path);
    final eventStream = app.reference().child(path).onValue;
    return eventStream.map<List<Entry>>((event) {
      print(event.snapshot.value);
      final List<Entry> list = [];
      event.snapshot.value.forEach((dynamic key, dynamic value) {
        if (job == null || value['jobId'] == job.id) {
          list.add(Entry.fromMap(value, key));
        }
      });
      return list;
    });
  }
}
