import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:survey_app/survey/model/survey.answer.model.dart';
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
    return await openDatabase(path, version: 2,
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
        "survey_id TEXT,"
        "question_id int,"
        "answer_id int,"
        "surveyed_count_id int"
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
      List<SurveyAnswerModel> answerModels = List();
      answerResponse.forEach((each) {
        answerModels
            .add(SurveyAnswerModel(answer: each["answer"], id: each["id"]));
      });
      model.answerModels = answerModels;
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
    List<SurveyQuestionModel> list = List();

    final db = await database;
    var response = await db.query(surveyQuestionTableName);
    for (Map<String, dynamic> each in response) {
      SurveyQuestionModel model = SurveyQuestionModel.fromMap(each, false);
      List<Map<String, dynamic>> answerResponse =
          await getAnswerBySurveyIdAndQuestionId(
              model.surveyId, model.questionId);
      print(answerResponse);
      List<SurveyAnswerModel> answerModels = List();
      answerResponse.forEach((each) {
        answerModels
            .add(SurveyAnswerModel(answer: each["answer"], id: each["id"]));
      });
      model.answerModels = answerModels;
      list.add(model);
    }
    print(list.length);
    return list;
  }

  Future<int> getSurveyedCount() async {
    final db = await database;
    List<Map<String, dynamic>> responses = await db
        .rawQuery("select count(distinct(surveyed_count_id)) count from "
            "$userAnswersTableName");
    if (responses.length > 0)
      return responses[0]['count'];
    else
      return 0;
  }

  Future<bool> saveAnswers(List<SurveyQuestionModel> questions) async {
    final db = await database;
    int getOldSurveyedCount = await getSurveyedCount();

    int newSurveyValue = getOldSurveyedCount + 1;

    for (SurveyQuestionModel question in questions) {
      List<Map<String, dynamic>> answersByUser =
          question.toMapForUserAnswerTable(newSurveyValue);
      for (Map<String, dynamic> answerByUser in answersByUser) {
        var raw = await db.insert(userAnswersTableName, answerByUser);
        print("output: $raw for ${answerByUser["question_id"]}");
      }
    }
    return true;
  }

  getAllSurvey(Database db) async {
    return await db.query(userAnswersTableName,
        columns: ["surveyed_count_id"], distinct: true);
  }

  Future<List<Map<String, dynamic>>> getUserSurveyAnswerBySurveyedId(
      int surveyedId, Database db) async {
    return await db.query(userAnswersTableName,
        where: "surveyed_count_id=?", whereArgs: [surveyedId]);
  }

  getQuestionAnswers(List<SurveyQuestionModel> questions,
      List<Map<String, dynamic>> allAnswers) {
    List<SurveyQuestionModel> questionList = new List();
    questions.forEach((each) {
      questionList.add(each.copyInstance());
    });
    allAnswers.forEach((answers) {
      questionList.forEach((question) {
        if (answers["question_id"] == question.questionId) {
          if (question.selectionType == AnswerSelectionType.SINGLE_ANSWER) {
            question.selectedAnsIndexSingle = answers["answer_id"];
          } else if (question.selectionType ==
              AnswerSelectionType.MULTIPLE_ANSWER) {
            question.selectedAnsIndexForMultiple.add(answers["answer_id"]);
          }
        }
      });
    });
    return questionList;
  }

  Future<List<List<SurveyQuestionModel>>> getSavedSurvey() async {
    final db = await database;
    List<SurveyQuestionModel> questions = await getAllQuestions();

    List<Map<String, dynamic>> userSurveys = await getAllSurvey(db);
    List<List<SurveyQuestionModel>> userSavedSurvey = List();
    for (Map<String, dynamic> eachSurvey in userSurveys) {
      List<Map<String, dynamic>> eachAnswers =
          await getUserSurveyAnswerBySurveyedId(
              eachSurvey["surveyed_count_id"], db);
      userSavedSurvey.add(getQuestionAnswers(questions, eachAnswers));
      print(1);
    }
    print(1);
    return userSavedSurvey;
  }
}
