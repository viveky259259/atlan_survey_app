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
  String userAnswersTableName = "user_answer";

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
      initiateQuestionTable(db);
      initiateAnswerTable(db);
      initiateUserAnswerTable(db);
    });
  }

  initiateQuestionTable(Database db) async {
    await db.execute("CREATE TABLE $surveyQuestionTableName ("
        "id integer primary key AUTOINCREMENT,"
        "survey_id TEXT,"
        "question TEXT,"
        "selection_type TEXT"
        ")");
  }

  initiateAnswerTable(Database db) async {
    await db.execute("CREATE TABLE $surveyAnswersTableName ("
        "id integer primary key AUTOINCREMENT,"
        "survey_id TEXT,"
        "question_id int,"
        "answer TEXT"
        ")");
  }

  initiateUserAnswerTable(Database db) async {
    await db.execute("CREATE TABLE $userAnswersTableName ("
        "id integer primary key AUTOINCREMENT,"
        "survey_id int,"
        "question_id int,"
        "answer_id int"
        ")");
  }

  addSurveyToDatabase(SurveyQuestionModel questions) async {
    int insertId = await insertQuestion(questions);
    questions.questionId = insertId;
    await insertAnswer(questions);
  }

  Future<int> insertQuestion(questions) async {
    final db = await database;
    var raw = await db.insert(
      surveyQuestionTableName,
      questions.toMapForQuestionTable(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    print("inserted que: $raw");
    return raw;
  }

  Future<int> insertAnswer(questions) async {
    final db = await database;
    List<Map<String, dynamic>> list = questions.toMapForAnswerTable();
    for (Map<String, dynamic> each in list) {
      var raw = await db.insert(
        surveyAnswersTableName,
        each,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print("inserted ans : $raw");
    }

    return 0;
  }

  Future<List<SurveyQuestionModel>> getQuestionBySurveyId(String id) async {
    List<SurveyQuestionModel> list = List();

    final db = await database;
    var response = await db.query(surveyQuestionTableName,
        where: "survey_id = ?", whereArgs: [id]);

    for (Map<String, dynamic> each in response) {
      SurveyQuestionModel model = SurveyQuestionModel.fromMap(each, false);
      List<Map<String, dynamic>> answerResponse =
          await getAnswerBySurveyIdAndQuestionId(
              model.surveyId, model.questionId);
      print(answerResponse);
      List<String> answers = List();
      answerResponse.forEach((each) {
        answers.add(each["answer"]);
      });
      model.answers = answers;
      list.add(model);
    }
    print(list.length);
    return list;
  }

  Future<List<Map<String, dynamic>>> getAnswerBySurveyIdAndQuestionId(
      String id, int questionId) async {
    final db = await database;
    var response = await db.query(surveyAnswersTableName,
        where: "survey_id = ? and question_id=?", whereArgs: [id, questionId]);
    return response;
  }

  Future<List<SurveyQuestionModel>> getAllQuestions() async {
//    Completer<List<SurveyQuestionModel>> completer = Completer();
    final db = await database;
    var response = await db.query(surveyQuestionTableName);
    List<SurveyQuestionModel> list = List();
    for (Map<String, dynamic> each in response) {
      SurveyQuestionModel model = SurveyQuestionModel.fromMap(each, false);
      List<Map<String, dynamic>> answers =
          await getAnswerBySurveyIdAndQuestionId(
              model.surveyId, model.questionId);
      answers.forEach((each) {
        model.answers.add(each["answer"]);
      });
      list.add(model);
    }
    return list;
  }
}
