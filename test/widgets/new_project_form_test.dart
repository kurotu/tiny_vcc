import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_vcc/services/vcc_service.dart';

import 'package:tiny_vcc/widgets/new_project_form.dart';

RenderEditable findRenderEditable(WidgetTester tester, int index) {
  final RenderObject root = tester.renderObject(
      find.byType(EditableText).at(index)); // 対象のフィールドのRenderObjectを取得
  expect(root, isNotNull);

  late RenderEditable renderEditable;
  void recursiveFinder(RenderObject child) {
    if (child is RenderEditable) {
      renderEditable = child;
      return;
    }
    child.visitChildren(recursiveFinder); // 再帰的に処理する
  }

  root.visitChildren(recursiveFinder);
  expect(renderEditable, isNotNull);
  return renderEditable;
}

void main() {
  testWidgets('NewProjectForm', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final formKey = GlobalKey<FormState>();
    final templates = [
      VpmTemplate('avatar', '/PATH/TO/AVATAR_TEMPLATE'),
      VpmTemplate('world', '/PATH/TO/WORLD_TEMPLATE'),
    ];
    const defaultLocation = '/PATH/TO/LOCATION';
    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: NewProjectForm(
            formKey: formKey,
            templates: templates,
            defaultLocation: defaultLocation,
            onClickLocationButton: () {
              return '/PATH/TO/NEW_LOCATION';
            },
          ),
        ),
      ),
    ));

    final NewProjectFormState state = tester.state(find.byType(NewProjectForm));
    expect(state.template, null);
    expect(state.name, '');
    expect(state.location, '/PATH/TO/LOCATION');
    expect(state.validate(), false);

    final dropdown = find.byKey(const ValueKey('template_dropdown'));
    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('avatar').last);
    await tester.pump();
    expect(state.template, templates[0]);

    const nameFieldIndex = 0;
    final nameField = find.byType(TextFormField).at(nameFieldIndex);
    expect(findRenderEditable(tester, nameFieldIndex).text?.toPlainText(), '');
    await tester.enterText(nameField, 'NAME');
    await tester.pump();
    expect(
        findRenderEditable(tester, nameFieldIndex).text?.toPlainText(), 'NAME');

    const locationFieldIndex = 1;
    expect(findRenderEditable(tester, locationFieldIndex).text?.toPlainText(),
        '/PATH/TO/LOCATION');
    await tester.tap(find.byIcon(Icons.folder));
    await tester.pump();
    expect(findRenderEditable(tester, locationFieldIndex).text?.toPlainText(),
        '/PATH/TO/NEW_LOCATION');

    expect(state.validate(), true);
  });
}
