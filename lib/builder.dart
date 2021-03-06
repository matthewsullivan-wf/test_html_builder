// Copyright 2019 Workiva Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:build/build.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:test_html_builder/src/builder.dart';
import 'package:test_html_builder/src/config.dart';

/// Builder factory referenced by this builder's build.yaml definition.
TestHtmlBuilder testHtmlBuilder(BuilderOptions options) {
  try {
    final config = TestHtmlBuilderConfig.fromJson(options.config);
    for (final path in config.templates.keys) {
      if (!path.startsWith('./test/') && !path.startsWith('test/')) {
        throw StateError('Invalid template path: $path\n'
            'Every test html template must be located in the `test/` directory.');
      }
    }
    return TestHtmlBuilder(config);
  } on CheckedFromJsonException catch (e) {
    final lines = <String>[
      'Could not parse the options provided for `test_html_builder`.'
    ];

    if (e.key != null) {
      lines.add('There is a problem with "${e.key}".');
    }
    if (e.message != null) {
      lines.add(e.message);
    } else if (e.innerError != null) {
      lines.add(e.innerError.toString());
    }

    throw StateError(lines.join('\n'));
  }
}
