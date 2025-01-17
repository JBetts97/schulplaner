import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schulplaner8/Data/Planner/File.dart';

class TaskFinished {
  Timestamp timestamp;
  bool finished;

  TaskFinished({this.timestamp, this.finished});

  TaskFinished.fromData(Map<String, dynamic> data) {
    try {
      timestamp = data['timestamp'];
    } catch (e) {
      timestamp = Timestamp.fromDate(data['timestamp']);
    }
    finished = data['finished'];
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'finished': finished,
    };
  }
}

class SchoolTask {
  String taskid, title, due, courseid, classid, creatorid;
  String detail;
  bool archived, private;
  Map<String, CloudFile> files;
  Map<String, TaskFinished> finished;

  SchoolTask(
      {this.taskid,
      this.title,
      this.due,
      this.classid,
      this.courseid,
      this.detail,
      this.archived = false,
      this.private = false,
      this.files,
      this.finished,
      this.creatorid});

  SchoolTask.fromData(Map<String, dynamic> data) {
    taskid = data['taskid'];
    title = data['title'];
    due = data['due'];
    classid = data['classid'];
    courseid = data['courseid'];
    creatorid = data['creatorid'];
    detail = data['detail'];
    archived = data['archived'] ?? false;
    private = data['private'] ?? false;

    //datamaps:
    Map<String, dynamic> premap_files =
        data['files']?.cast<String, dynamic>() ?? {};
    premap_files.removeWhere((key, value) => value == null);
    files = premap_files.map<String, CloudFile>((String key, value) =>
        MapEntry(key, CloudFile.fromData(value?.cast<String, dynamic>())));
    Map<String, dynamic> premap_finished =
        data['finished']?.cast<String, dynamic>() ?? {};
    premap_finished.removeWhere((key, value) => value == null);
    finished = premap_finished.map<String, TaskFinished>((String key, value) =>
        MapEntry(key, TaskFinished.fromData(value?.cast<String, dynamic>())));

    if (data['olddata'] != null) {
      try {
        if (data['olddata']["att"] != null) {
          Map<dynamic, dynamic> rawdata = data['olddata']["att"];
          Map<String, CloudFile> attachments =
              rawdata.map((key, value) => MapEntry<String, CloudFile>(
                  key,
                  CloudFile(
                    fileid: key,
                    name: value['n'] ?? key,
                    fileform: FileForm.OLDTTYPE,
                    savedin: SavedIn(type: SavedInType.PERSONAL, id: null),
                  )));
          files.addAll(attachments);
        }
        if (data['olddata']["attachments"] != null) {
          Map<dynamic, dynamic> rawdata = data['olddata']["attachments"];
          Map<String, CloudFile> attachments =
              rawdata.map((key, value) => MapEntry<String, CloudFile>(
                  key,
                  CloudFile(
                    fileid: key,
                    name: key,
                    fileform: FileForm.OLDTTYPE,
                    savedin: SavedIn(type: SavedInType.PERSONAL, id: null),
                  )));
          files.addAll(attachments);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'taskid': taskid,
      'title': title,
      'due': due,
      'classid': classid,
      'courseid': courseid,
      'creatorid': creatorid,
      'detail': detail,
      'files': files?.map((key, value) => MapEntry(key, value?.toJson())),
      'archived': archived,
      'private': private,
    };
  }

  SchoolTask copy() {
    return SchoolTask(
      taskid: taskid,
      title: title,
      due: due,
      classid: classid,
      courseid: courseid,
      detail: detail,
      archived: archived,
      files: files != null ? Map.of(files) : null,
      finished: finished,
      creatorid: creatorid,
    );
  }

  bool validateCreate() {
    if (private == true) {
      if (title == null || title == "") return false;
      if (due == null) return false;
      return true;
    } else {
      if (title == null || title == "") return false;
      if (due == null) return false;
      if (courseid == null && classid == null) return false;
      return true;
    }
  }

  bool validate() {
    if (taskid == null) return false;
    if (due == null) return false;
    if (title == null || title == "") return false;
    return true;
  }

  bool isFinished(String memberid) {
    return finished == null ? false : (finished[memberid]?.finished ?? false);
  }
}
