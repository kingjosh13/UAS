class QuestionOption {
  final String question;
  final List<String> options;
  final int answerIndex;

  QuestionOption({
    required this.question,
    required this.options,
    required this.answerIndex,
  });

  // Mengubah sebuah Question menjadi objek Map untuk SQFLite
  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options.join(','), // Menyimpan opsi sebagai string yang dipisahkan koma
      'answerIndex': answerIndex,
    };
  }

  // Mengubah objek Map kembali menjadi sebuah Question
  factory QuestionOption.fromMap(Map<String, dynamic> map) {
    return QuestionOption(
      question: map['question'],
      options: List<String>.from(map['options'].split(',')),
      answerIndex: map['answerIndex'],
    );
  }
}

class QuestionEssay {
  final String question; // Pertanyaan
  final String answerKey; // Kunci jawaban (untuk soal essay)

  QuestionEssay({
    required this.question,
    required this.answerKey,
  });

  // Mengubah objek QuestionEssay menjadi Map untuk disimpan di SQLite
  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answerKey': answerKey, // Menyimpan kunci jawaban essay
    };
  }

  // Mengonversi Map kembali ke dalam objek QuestionEssay
  factory QuestionEssay.fromMap(Map<String, dynamic> map) {
    return QuestionEssay(
      question: map['question'],
      answerKey: map['answerKey'],
    );
  }
}
