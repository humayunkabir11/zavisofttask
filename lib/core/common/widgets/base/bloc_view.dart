import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BlocView<B extends StateStreamableSource<Object?>>
    extends StatelessWidget {
  const BlocView({super.key});

  @protected
  B bloc(BuildContext context) => context.read<B>();

  @override
  Widget build(BuildContext context) => buildView(context);

  @protected
  Widget buildView(BuildContext context);
}
