import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';

class TriviaController extends StatefulWidget {
  const TriviaController({
    super.key,
  });

  @override
  State<TriviaController> createState() => _TriviaControllerState();
}

class _TriviaControllerState extends State<TriviaController> {
  late String inputStr;
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          onChanged: (value) {
            inputStr = value;
          },
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
            hintText: 'Input a number',
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
                child: GestureDetector(
              onTap: () {
                controller.clear();
                BlocProvider.of<NumberTriviaBloc>(context).add(
                  GetTriviaForConcreteNumber(numberString: inputStr),
                );
              },
              child: Container(
                height: 40,
                color: Colors.green.shade600,
                child: const Center(
                  child: Text(
                    'Search',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: GestureDetector(
              onTap: () {
                controller.clear();
                context
                    .read<NumberTriviaBloc>()
                    .add(GetTriviaForRandomNumber());
              },
              child: Container(
                height: 40,
                color: Colors.grey.shade300,
                child: const Center(
                  child: Text(
                    'Get Random Number',
                  ),
                ),
              ),
            )),
          ],
        ),
      ],
    );
  }
}
