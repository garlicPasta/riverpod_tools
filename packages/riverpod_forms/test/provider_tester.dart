import 'dart:async';
import 'dart:developer';

import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/subjects.dart';

typedef TestDependencyies<D, T> = ({D dependencies, T? data});

class ProviderTester<DEPS, DATA, P extends ProviderListenable> {
  final DEPS Function(DATA? data, DateTime now) setup;
  final P Function(DEPS dependencies, DATA? data) provider;
  late final FutureOr Function(
    ProviderContainer c,
    DEPS dependencies,
    DATA? data,
    P provider,
  )
  act;

  final Iterable Function(DEPS d, DATA? t) emits;
  final List<Override> Function(DEPS dependencies, DATA? data) overrides;
  final Function(DEPS dependencies, DATA? data)? postAction;
  final List<DATA> Function()? tableData;
  final Clock? fakeClock;

  ProviderTester({
    this.tableData,
    required this.setup,
    required this.provider,
    required this.overrides,
    required this.act,
    required this.emits,
    this.fakeClock,
    this.postAction,
  });

  ProviderTester.read({
    this.tableData,
    required this.setup,
    required this.provider,
    required this.overrides,
    required this.emits,
    this.fakeClock,
    this.postAction,
  }) {
    act =
        (ProviderContainer c, DEPS dependencies, DATA? data, P provider) async {
          c.read(provider);
        };
  }

  Future run([bool showLogging = false]) async {
    Future<void> runTest() async {
      var t = tableData?.call() ?? [];
      do {
        BehaviorSubject stream = BehaviorSubject();
        var t0 = t.lastOrNull;
        var d = setup(t0, fakeClock?.now() ?? clock.now());

        if (t.isNotEmpty) {
          t.removeLast();
        }

        ProviderContainer c = ProviderContainer(overrides: overrides(d, t0));
        var p = provider(d, t0);
        Future<void> expectation = expectLater(
          stream,
          emitsInOrder(emits(d, t0)),
        );
        c.listen(p, fireImmediately: true, (previousState, nextState) {
          stream.add(nextState);
        });
        try {
          await act(c, d, t0, p);
          await expectation;
          postAction?.call(d, t0);
        } on TestFailure catch (e) {
          fail('Failed for tableData: $t0\n\n${e.message}');
        } catch (e, st) {
          log(
            'Test threw error with data $t0: $e\n$st',
            error: e,
            stackTrace: st,
          );
          rethrow;
        }
      } while (t.isNotEmpty);
    }

    try {
      if (fakeClock == null) {
        await runTest();
      } else {
        await withClock(fakeClock!, runTest);
      }
    } catch (e, st) {
      log('Test threw error: $e\n$st', error: e, stackTrace: st);
      rethrow;
    }
  }
}
