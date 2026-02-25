import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A production-ready base widget to access a Bloc with lifecycle hooks,
/// similar to GetX's GetView + onInit/onReady/onClose.
abstract class BlocStateView<B extends StateStreamableSource<Object?>>
    extends StatefulWidget {
  const BlocStateView({super.key});

  /// Build UI here
  Widget build(BuildContext context, B bloc);

  /// Called once in initState
  @protected
  void onInit(BuildContext context, B bloc) {}

  /// Called after first frame (safe for navigation, dialogs, etc.)
  @protected
  void onReady(BuildContext context, B bloc) {}

  /// Called in dispose for cleanup
  @protected
  void onDispose(BuildContext context, B bloc) {}

  @override
  State<BlocStateView<B>> createState() => _BlocStateViewState<B>();
}

class _BlocStateViewState<B extends StateStreamableSource<Object?>>
    extends State<BlocStateView<B>> {
  late final B _bloc;
  bool _readyCalled = false;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<B>();
    widget.onInit(context, _bloc);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_readyCalled) {
      _readyCalled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onReady(context, _bloc);
        }
      });
    }
  }

  @override
  void dispose() {
    widget.onDispose(context, _bloc);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context, _bloc);
  }
}
