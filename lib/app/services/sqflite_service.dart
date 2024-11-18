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

  // Fungsi untuk menangani pembuatan tabel saat pertama kali
  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT,
        options TEXT,
        answerIndex INTEGER,
        isEssay INTEGER
      )
    ''');
  }

  // Fungsi untuk memeriksa apakah soal sudah ada berdasarkan 'question'
  Future<bool> checkIfQuestionExists(String questionText) async {
    final db = await database;
    final result = await db.query(
      'questions',
      where: 'question = ?',
      whereArgs: [questionText],
    );
    return result.isNotEmpty; // Jika ada, berarti soal sudah ada
  }

  Future<int> insertQuestion(Question question) async {
    final db = await database;
    return await db.insert('questions', question.toMap());
  }

  Future<List<Question>> getQuestions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('questions');
    return List.generate(maps.length, (i) {
      return Question.fromMap(maps[i]);
    });
  }
}
