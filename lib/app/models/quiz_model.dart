class Question {
  final String question;
  final List<String> options;
  final int answerIndex;
  final bool isEssay;
  final String? answerKey; // Menambahkan kunci jawaban untuk soal essay

  Question({
    required this.question,
    required this.options,
    required this.answerIndex,
    this.isEssay = false,
    this.answerKey, // Kunci jawaban untuk soal essay
  });

  // Mengubah sebuah Question menjadi objek Map untuk SQFLite
  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': isEssay ? '' : options.join(','), // Menyimpan opsi sebagai string yang dipisahkan koma (kosong jika soal essay)
      'answerIndex': answerIndex,
      'isEssay': isEssay ? 1 : 0, // Menyimpan isEssay sebagai 1 (true) atau 0 (false)
      'answerKey': answerKey ?? '', // Menyimpan kunci jawaban (kosong jika tidak ada)
    };
  }

  // Mengubah objek Map kembali menjadi sebuah Question
  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      question: map['question'],
      options: map['isEssay'] == 1 || map['options'] == ''
          ? [] // Jika soal adalah essay, tidak ada opsi
          : List<String>.from(map['options'].split(',')),
      answerIndex: map['answerIndex'],
      isEssay: map['isEssay'] == 1, // Menetapkan apakah soal ini adalah essay
      answerKey: map['answerKey'], // Menyimpan kunci jawaban
    );
  }
}
