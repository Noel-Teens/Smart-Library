import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management_app/app.dart';

void main() {
  testWidgets('SmartLibraryApp renders without crashing', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SmartLibraryApp(),
      ),
    );

    // The app should render and show the login screen.
    await tester.pumpAndSettle();

    // Verify the app title or login screen content is present.
    expect(find.text('Smart Library'), findsOneWidget);
  });
}
