import 'package:affordant_view_model/affordant_view_model.dart';
import 'package:example/view_model.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: FlexThemeData.light(
        scheme: FlexScheme.indigoM3,
        useMaterial3: true,
      ),
      home: Bind(
        create: (_) => SearchViewModel(),
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Affordant query view"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            onChanged: (value) {
              context.read<SearchViewModel>().setQueryParams(value);
            },
          ),
          const Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: _Results(),
                  ),
                ),
                VerticalDivider(color: Colors.black),
                Expanded(
                  child: SingleChildScrollView(
                    child: _Timeline(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.select((SearchViewModel vm) => vm.state);
    if (state.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(64),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Column(
      children: state.data.results.map(Text.new).toList(),
    );
  }
}

class _Timeline extends StatefulWidget {
  const _Timeline({
    super.key,
  });

  @override
  State<_Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<_Timeline>
    with SingleTickerProviderStateMixin {
  final start = DateTime.now();
  late DateTime end = start;
  late final Ticker _t;

  @override
  void initState() {
    super.initState();

    _t = createTicker((elapsed) {
      setState(() {
        end = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _t.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.select((SearchViewModel vm) => vm.state).data;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: state.events
                .whereType<DebounceQuery>()
                .map((e) => Text(e.label))
                .toList(),
          ),
        ),
        const VerticalDivider(color: Colors.black),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: state.events
                .whereType<PerformQuery>()
                .map((e) => Text(e.label))
                .toList(),
          ),
        )
      ],
    );
  }
}
