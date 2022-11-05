import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/color/color_cubit.dart';
import 'cubits/counter/counter_cubit.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (ctx) => ColorCubit()),
        BlocProvider(
          create: (ctx) => CounterCubit(colorCubit: ctx.read<ColorCubit>()),
        ),
      ],
      child: MaterialApp(
        title: 'Cubit to Cubit Communication',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<ColorCubit>().state.color,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => context.read<ColorCubit>().changeColor(),
              child: const Text(
                'Change Color',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 20),
            BlocSelector<CounterCubit, CounterState, int>(
              selector: (state) => state.counter,
              builder: (ctx, counter) => Text(
                '$counter',
                style: const TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.read<CounterCubit>().incrementCounter(),
              child: const Text(
                'Increment Counter',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
