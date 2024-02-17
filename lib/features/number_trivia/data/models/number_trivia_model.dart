import '../../domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  final String textModel;
  final int numberModel;

  const NumberTriviaModel({required this.textModel, required this.numberModel})
      : super(number: numberModel, text: textModel);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
        textModel: json['text'], numberModel: json['number']);
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }
}
