import 'package:affordant_mvvm/affordant_mvvm.dart';
import 'package:flutter/widgets.dart';

class Consume<VM extends ViewModel> extends StatelessWidget {
  const Consume(
    this.builder, {
    super.key,
  });

  final Widget Function(BuildContext context, VM vm) builder;

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<VM>(context);
    return Watch((context) => builder(context, p));
  }
}
