import 'package:flutter/material.dart';
import 'package:responsive_toolkit/breakpoints.dart';
import 'package:responsive_toolkit/responsive_grid.dart';
import 'package:responsive_toolkit/responsive_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VanillaResponsive(),
    );
  }
}

// Define these out here for simplicity.
const card1 = MyCard(text: 'Card 1');
const card2 = MyCard(text: 'Card 2\nMultiple lines');
const card3 = MyCard(text: 'Card 3');
const card4 = MyCard(text: 'Card 4');
const gap = SizedBox.square(dimension: 20);

class VanillaResponsive extends StatelessWidget {
  const VanillaResponsive({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    late final List<Widget> cardSection;
    if (screenWidth > 992) {
      cardSection = [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Expanded(child: card1),
            gap,
            Expanded(child: card2),
            gap,
            Expanded(child: card3),
            gap,
            Expanded(child: card4),
          ],
        )
      ];
    } else if (screenWidth > 768) {
      cardSection = [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [Expanded(child: card1), gap, Expanded(child: card2)],
        ),
        gap,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [Expanded(child: card3), gap, Expanded(child: card4)],
        ),
      ];
    } else {
      cardSection = [card1, gap, card2, gap, card3, gap, card4];
    }

    final textTheme = Theme.of(context).textTheme;
    late final TextStyle headlineStyle;
    if (screenWidth >= 1200) {
      headlineStyle = textTheme.displayLarge!;
    } else if (screenWidth >= 992) {
      headlineStyle = textTheme.displayMedium!;
    } else if (screenWidth >= 768) {
      headlineStyle = textTheme.displaySmall!;
    } else {
      headlineStyle = textTheme.titleLarge!;
    }

    late final BoxConstraints containerConstraints;
    if (screenWidth >= 1400) {
      containerConstraints = const BoxConstraints.tightFor(width: 1320);
    } else if (screenWidth >= 1200) {
      containerConstraints = const BoxConstraints.tightFor(width: 1140);
    } else if (screenWidth >= 992) {
      containerConstraints = const BoxConstraints.tightFor(width: 960);
    } else {
      containerConstraints = const BoxConstraints();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vanilla'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: containerConstraints,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Heading',
                  style: headlineStyle,
                ),
                gap,
                ...cardSection,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LibraryResponsive extends StatelessWidget {
  const LibraryResponsive({super.key});

  @override
  Widget build(BuildContext context) {
    final cardBreakpoints = Breakpoints(
      xs: const ResponsiveColumnConfig(span: 12),
      md: const ResponsiveColumnConfig(span: 6),
      lg: const ResponsiveColumnConfig(span: 3),
    );

    final containerMaxWidth = ResponsiveLayout.value(
      context,
      Breakpoints(
        xs: const BoxConstraints(),
        lg: const BoxConstraints.tightFor(width: 960),
        xl: const BoxConstraints.tightFor(width: 1140),
        xxl: const BoxConstraints.tightFor(width: 1320),
      ),
    );

    final textTheme = Theme.of(context).textTheme;
    final headlineStyle = ResponsiveLayout.value(
      context,
      Breakpoints(
        xs: textTheme.titleLarge,
        md: textTheme.displaySmall,
        lg: textTheme.displayMedium,
        xl: textTheme.displayLarge,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: containerMaxWidth,
            child: Column(
              children: [
                Text(
                  'Heading',
                  style: headlineStyle,
                ),
                gap,
                ResponsiveRow(
                  runSpacing: 20.0,
                  spacing: 20.0,
                  columns: [
                    ResponsiveColumn(cardBreakpoints, child: card1),
                    ResponsiveColumn(cardBreakpoints, child: card2),
                    ResponsiveColumn(cardBreakpoints, child: card3),
                    ResponsiveColumn(cardBreakpoints, child: card4),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  final String text;

  const MyCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(text),
      ),
    );
  }
}
