import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: BlocProvider(
        create: (context) => sl<NumberTriviaBloc>(),
        child: const SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  MessageBox(),
                  SizedBox(
                    height: 20,
                  ),
                  TriviaController(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
