import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:survey_app/survey/model/survey.question.model.dart';

class SurveyDatabaseProvider {
  SurveyDatabaseProvider._();

  static final SurveyDatabaseProvider db = SurveyDatabaseProvider._();
  Database _database;
  String surveyQuestionTableName = "survey_question";
  String surveyAnswersTableName = "survey_answer";
  String dbName = "survey.db";

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE $surveyQuestionTableName ("
          "id integer primary key AUTOINCREMENT,"
          "survey_id TEXT,"
          "question TEXT,"
          "answers TEXT,"
          "selection_type TEXT"
          ")");
      await db.execute("CREATE TABLE $surveyAnswersTableName ("
          "id integer primary key AUTOINCREMENT,"
          "question_id TEXT,"
          "answer_index int"
          ")");
    });
  }

  addSurveyToDatabase(SurveyQuestionModel questions) async {
    final db = await database;

    var raw = await db.insert(
      surveyQuestionTableName,
      questions.toMapForTable(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  Future<List<SurveyQuestionModel>> getQuestionBySurveyId(String id) async {
    final db = await database;
    var response = await db.query(surveyQuestionTableName,
        where: "survey_id = ?", whereArgs: [id]);
    if (response.isNotEmpty) {
      List<SurveyQuestionModel> list =
          response.map((c) => SurveyQuestionModel.fromMap(c,false)).toList();
      return list;
    } else
      return null;
  }

  Future<List<SurveyQuestionModel>> getAllQuestions() async {
    final db = await database;
    var response = await db.query(surveyQuestionTableName);
    List<SurveyQuestionModel> list =
        response.map((c) => SurveyQuestionModel.fromMap(c, false)).toList();
    return list;
  }
}
