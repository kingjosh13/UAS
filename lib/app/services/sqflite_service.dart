import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/quiz_model.dart';

class SqfliteService {
  static final SqfliteService _instance = SqfliteService._internal();
  factory SqfliteService() => _instance;
  static Database? _database;

  SqfliteService._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'quiz.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE questions_option (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      question TEXT,
      options TEXT,
      answerIndex INTEGER
    )
  ''');

    await db.execute('''
    CREATE TABLE questions_essay (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      question TEXT,
      answerKey TEXT
    )
  ''');
  }

  // Fungsi untuk memeriksa apakah soal sudah ada berdasarkan 'question'
  // Future<bool> checkIfQuestionExists(String questionText) async {
  //   final db = await database;
  //   final result = await db.query(
  //     'questions',
  //     where: 'question = ?',
  //     whereArgs: [questionText],
  //   );
  //   return result.isNotEmpty; // Jika ada, berarti soal sudah ada
  // }

  // Future<int> insertQuestion(QuestionOption question) async {
  //   final db = await database;
  //   return await db.insert('questions', question.toMap());
  // }

  // Future<List<QuestionOption>> getQuestions() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> maps = await db.query('questions');
  //   return List.generate(maps.length, (i) {
  //     return QuestionOption.fromMap(maps[i]);
  //   });
  // }

  // Fungsi untuk memeriksa apakah soal sudah ada berdasarkan 'question'
  Future<bool> checkIfQuestionExists(String questionText, bool isEssay) async {
    final db = await database;
    String table = isEssay ? 'questions_essay' : 'questions_option';

    final result = await db.query(
      table,
      where: 'question = ?',
      whereArgs: [questionText],
    );
    return result.isNotEmpty; // Jika ada, berarti soal sudah ada
  }

  Future<int> insertQuestionOption(QuestionOption question) async {
    final db = await database;
    return await db.insert('questions_option', question.toMap());
  }

  Future<int> insertQuestionEssay(QuestionEssay question) async {
    final db = await database;
    return await db.insert('questions_essay', question.toMap());
  }

  Future<List<QuestionOption>> getQuestionOptions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('questions_option');
    return List.generate(maps.length, (i) {
      return QuestionOption.fromMap(maps[i]);
    });
  }

  Future<List<QuestionEssay>> getQuestionEssays() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('questions_essay');
    return List.generate(maps.length, (i) {
      return QuestionEssay.fromMap(maps[i]);
    });
  }
}
