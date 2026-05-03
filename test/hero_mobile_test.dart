import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_web_site/features/hero/presentation/pages/mobile/hero_mobile_view.dart';
import 'package:my_web_site/features/hero/presentation/cubit/hero_cubit.dart';
import 'package:my_web_site/features/hero/presentation/cubit/hero_state.dart';
import 'package:my_web_site/features/hero/domain/entities/hero_entity.dart';
import 'package:my_web_site/features/hero/domain/repositories/hero_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Fake Repository
class FakeHeroRepository implements HeroRepository {
  @override
  Future<HeroData> getHeroData() async {
    return const HeroData(
      name: 'Test Name',
      title: 'Test Title',
      subtitle: 'Test Subtitle',
      helloGreeting: 'Hello',
      showAurora: false,
    );
  }
}

// Fake Cubit
class FakeHeroCubit extends Cubit<HeroState> implements HeroCubit {
  FakeHeroCubit()
      : super(const HeroLoaded(
          HeroData(
            name: 'Test Name',
            title: 'Test Title',
            subtitle: 'Test Subtitle',
            helloGreeting: 'Hello',
            showAurora: false,
          ),
        ));

  @override
  final HeroRepository repository = FakeHeroRepository();

  @override
  Future<void> loadHeroData() async {}
}

void main() {
  testWidgets('HeroMobileView renders and scrolls on small screen',
      (WidgetTester tester) async {
    // Arrange
    final fakeHeroCubit = FakeHeroCubit();
    final scrollNotifier = ValueNotifier<double>(0.0);

    // Determine the screen size for the test (Mobile)
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1.0;

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<HeroCubit>.value(
            value: fakeHeroCubit,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                    minHeight: 667), // Mimic app_router logic
                child: HeroMobileView(
                  scrollOffsetListenable: scrollNotifier,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Advance time to allow for any initial animations or async builds
    await tester.pump(const Duration(seconds: 1));

    // Assert
    expect(find.text('TEST TITLE'), findsOneWidget);
    expect(find.text('TEST NAME'), findsOneWidget);

    // Verify content visibility
    expect(find.text('ABOUT'), findsOneWidget);
    expect(find.text('DOWNLOAD CV'), findsOneWidget);

    // Clean up
    addTearDown(tester.view.resetPhysicalSize);
  });
}
