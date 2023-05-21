import 'dart:convert';

class Block {
  Block();

  factory Block.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('type') && json.containsKey('text')) {
      if (json['type'] == 'h1') {
        return HeaderBlock(text: json['text']);
      } else if (json['type'] == 'p') {
        return ParagraphBlock(text: json['text']);
      } else if (json['type'] == 'checkbox' && json.containsKey('checked')) {
        return CheckboxBlock(text: json['text'], isChecked: json['checked']);
      } else {
        throw const FormatException('Unexpected JSON format');
      }
    } else {
      throw const FormatException('Unexpected JSON format');
    }
  }
}

class HeaderBlock extends Block {
  final String text;

  HeaderBlock({
    required this.text,
  });
}

class ParagraphBlock extends Block {
  final String text;

  ParagraphBlock({required this.text});
}

class CheckboxBlock extends Block {
  final String text;
  final bool isChecked;

  CheckboxBlock({
    required this.text,
    required this.isChecked,
  });
}

class Document {
  final Map<String, Object?> _json;

  Document() : _json = jsonDecode(documentJson);

  (String, {DateTime modified}) getMetadata() {
    if (_json
        case {
          'metadata': {
            'title': String title,
            'modified': String localModified,
          }
        }) {
      return (
        title,
        modified: DateTime.parse(localModified),
      );
    } else {
      throw const FormatException('Unexpected JSON');
    }
  }

  List<Block> getBlocks() {
    if (_json.containsKey('blocks')) {
      final blocksJson = _json['blocks'];
      if (blocksJson is List) {
        return blocksJson.map((block) => Block.fromJson(block)).toList();
      } else {
        throw const FormatException('Unexpected JSON format');
      }
    } else {
      throw const FormatException('Unexpected JSON format');
    }
  }
}

const documentJson = '''
{
  "metadata": {
    "title": "My Document",
    "modified": "2023-05-10"
  },
  "blocks": [
    {
      "type": "h1",
      "text": "Chapter 1"
    },
    {
      "type": "p",
      "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    },
    {
      "type": "checkbox",
      "checked": false,
      "text": "Learn Dart 3"
    }
  ]
}
''';
