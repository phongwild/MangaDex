import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Optimized BlocBuilder that only rebuilds when necessary
class OptimizedBlocBuilder<B extends StateStreamable<S>, S> extends StatelessWidget {
  final B? bloc;
  final BlocBuilderCondition<S>? buildWhen;
  final BlocWidgetBuilder<S> builder;
  
  const OptimizedBlocBuilder({
    super.key,
    this.bloc,
    this.buildWhen,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      bloc: bloc,
      buildWhen: (previous, current) {
        // Add additional optimization checks
        if (buildWhen != null) {
          return buildWhen!(previous, current);
        }
        
        // If states are Equatable, use equality check
        if (previous is Equatable && current is Equatable) {
          return previous != current;
        }
        
        // Default behavior
        return true;
      },
      builder: (context, state) {
        // Wrap in RepaintBoundary for better performance
        return RepaintBoundary(
          child: builder(context, state),
        );
      },
    );
  }
}

// Memoized selector for efficient state selection
class MemoizedBlocSelector<B extends StateStreamable<S>, S, T> extends StatelessWidget {
  final B? bloc;
  final T Function(S state) selector;
  final Widget Function(BuildContext context, T data) builder;
  
  const MemoizedBlocSelector({
    super.key,
    this.bloc,
    required this.selector,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<B, S, T>(
      bloc: bloc,
      selector: selector,
      builder: (context, data) {
        return RepaintBoundary(
          child: builder(context, data),
        );
      },
    );
  }
}

// Extension for easier state optimization
extension StateOptimization<T> on T {
  // Create immutable copy for state updates
  T copyWith(T Function() creator) {
    return creator();
  }
}

// Batch state updates to reduce rebuilds
mixin BatchUpdateMixin<Event, State> on Bloc<Event, State> {
  final List<Event> _pendingEvents = [];
  Timer? _batchTimer;
  
  void batchAdd(Event event) {
    _pendingEvents.add(event);
    _batchTimer?.cancel();
    _batchTimer = Timer(const Duration(milliseconds: 50), () {
      for (final event in _pendingEvents) {
        add(event);
      }
      _pendingEvents.clear();
    });
  }
  
  @override
  Future<void> close() {
    _batchTimer?.cancel();
    return super.close();
  }
}

// Timer class for batch updates
class Timer {
  final Duration duration;
  final VoidCallback callback;
  Timer? _timer;

  Timer(this.duration, this.callback) {
    _timer = Future.delayed(duration).then((_) => callback()) as Timer?;
  }

  void cancel() {
    _timer = null;
  }
}