import 'package:flutter/material.dart';

import 'data.dart';

void main() {
  runApp(const DocumentApp());
}

class DocumentApp extends StatelessWidget {
  const DocumentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: DocumentScreen(
        document: Document(),
      ),
    );
  }
}

class DocumentScreen extends StatelessWidget {
  final Document document;

  const DocumentScreen({
    required this.document,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final (title, :modified) = document.getMetadata();
    final formattedModifiedDate = formatDate(modified);
    final blocks = document.getBlocks();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          Text('Last modified $formattedModifiedDate'),
          Expanded(
            child: ListView.builder(
              itemCount: blocks.length,
              itemBuilder: (context, index) => BlockWidget(
                block: blocks[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BlockWidget extends StatelessWidget {
  final Block block;

  const BlockWidget({
    required this.block,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (block is HeaderBlock) {
      final headerBlock = block as HeaderBlock;
      return Container(
        margin: const EdgeInsets.all(8.0),
        child: Text(
          headerBlock.text,
          style: Theme.of(context).textTheme.displayMedium,
        ),
      );
    } else if (block is ParagraphBlock) {
      final paragraphBlock = block as ParagraphBlock;
      return Container(
        margin: const EdgeInsets.all(8.0),
        child: Text(paragraphBlock.text),
      );
    } else if (block is CheckboxBlock) {
      final checkboxBlock = block as CheckboxBlock;
      return Container(
        margin: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Checkbox(value: checkboxBlock.isChecked, onChanged: (_) {}),
            Text(checkboxBlock.text),
          ],
        ),
      );
    } else {
      throw Exception('Unexpected block');
    }

    // switch (block.type) {
    //   case 'h1':
    //     textStyle = Theme.of(context).textTheme.displayMedium;
    //     break;
    //   case 'p':
    //   case 'checkbox':
    //     textStyle = Theme.of(context).textTheme.bodyMedium;
    //     break;
    //   default:
    //     textStyle = Theme.of(context).textTheme.bodySmall;
    // }
  }
}

String formatDate(DateTime dateTime) {
  var today = DateTime.now();
  var difference = dateTime.difference(today);

  if (difference.inDays == 0) {
    return 'today';
  } else if (difference.inDays == 1) {
    return 'tomorrow';
  } else if (difference.inDays == -1) {
    return 'yesterday';
  } else if (difference.isNegative) {
    return '${difference.inDays.abs()} days ago';
  } else {
    return '${difference.inDays} days from now';
  }
}
