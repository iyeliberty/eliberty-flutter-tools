import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eliberty_toolbox/features/auth/presentation/pages/initialisation_page.dart';
import 'package:eliberty_toolbox/features/auth/presentation/pages/home_page.dart';
import 'package:eliberty_toolbox/features/auth/presentation/pages/login_page.dart';
import 'package:eliberty_toolbox/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:eliberty_toolbox/features/auth/presentation/cubit/auth_state.dart';
import 'package:eliberty_toolbox/features/auth/domain/entities/user.dart';

class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  late MockAuthCubit mockAuthCubit;

  const testUser = User(
    id: 'abc123',
    name: 'Patrick',
    email: 'test@example.com',
    imageUrl: null,
  );

  setUp(() {
    mockAuthCubit = MockAuthCubit();
  });

  Future<void> pumpInitialisationPage(
    WidgetTester tester,
    AuthState state,
  ) async {
    when(() => mockAuthCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockAuthCubit.state).thenReturn(state);
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthCubit>.value(
          value: mockAuthCubit,
          child: const InitialisationPage(),
        ),
      ),
    );
  }

  testWidgets('shows CircularProgressIndicator when loading', (tester) async {
    await pumpInitialisationPage(tester, AuthLoading());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  testWidgets('shows HomePage when authenticated', (tester) async {
    await pumpInitialisationPage(tester, AuthAuthenticated(testUser));

    await tester.pump();

    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('shows LoginPage when unauthenticated', (tester) async {
    await pumpInitialisationPage(tester, AuthUnauthenticated());

    await tester.pump();

    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('shows LoginPage when error', (tester) async {
    await pumpInitialisationPage(tester, AuthError('Some error'));

    await tester.pump();

    expect(find.byType(LoginPage), findsOneWidget);
  });
}
