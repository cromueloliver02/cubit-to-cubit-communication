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
        BlocProvider(create: (ctx) => CounterCubit()),
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _incrementSize = 1;

  @override
  void dispose() {
    context.read<CounterCubit>().close();
    super.dispose();
  }

  void _colorListener(ctx, state) {
    final color = state.color;

    if (color == Colors.red) _incrementSize = 1;
    if (color == Colors.green) _incrementSize = 10;
    if (color == Colors.blue) _incrementSize = 100;
    if (color == Colors.black) {
      _incrementSize = -100;
      ctx.read<CounterCubit>().incrementCounter(-100);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ColorCubit, ColorState>(
      listener: _colorListener,
      builder: (ctx, state) => Scaffold(
        backgroundColor: ctx.watch<ColorCubit>().state.color,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () => ctx.read<ColorCubit>().changeColor(),
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
                onPressed: () =>
                    ctx.read<CounterCubit>().incrementCounter(_incrementSize),
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
      ),
    );
  }
}
