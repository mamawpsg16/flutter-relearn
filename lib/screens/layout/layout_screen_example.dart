import 'package:flutter/material.dart';

class RunLayoutApp extends StatelessWidget {
  const RunLayoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Flutter layout demo';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(title: const Text(appTitle)),
        body: SingleChildScrollView(
          child: Column(
            children: const [
              ImageSection(image: 'images/lake.jpg'),
              TitleSection(
                name: 'Oeschinen Lake Campground',
                location: 'Kandersteg, Switzerland',
              ),
              SizedBox(height: 8),
              ButtonsSection(),
              TextSection(
                text:
                    'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese Alps. Situated 1,578 meters above sea level, it is one of the larger Alpine Lakes. A gondola ride from Kandersteg, followed by a half-hour walk through pastures and pine forest, leads you to the lake, which warms to 20 degrees Celsius in the summer. Activities enjoyed here include rowing, and riding the summer toboggan run.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TitleSection extends StatefulWidget {
  final String name;
  final String location;

  const TitleSection({super.key, required this.name, required this.location});

  @override
  State<TitleSection> createState() => _TitleSectionState();
}

class _TitleSectionState extends State<TitleSection> {
  bool _isFavorited = false;
  int _favoriteCount = 0;

  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _favoriteCount--;
        _isFavorited = false;
      } else {
        _favoriteCount++;
        _isFavorited = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TitleSectionStateless(
      name: widget.name,
      location: widget.location,
      isFavorited: _isFavorited,
      count: _favoriteCount,
      toggleFavorite: _toggleFavorite,
    );
  }
}

class TitleSectionStateless extends StatelessWidget {
  final String name;
  final String location;
  final bool isFavorited;
  final int count;
  final VoidCallback toggleFavorite;

  const TitleSectionStateless({
    super.key,
    required this.name,
    required this.location,
    required this.isFavorited,
    required this.toggleFavorite,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(location, style: TextStyle(color: Colors.grey[500])),
              ],
            ),
          ),
          Container(
            child: IconButton(
              icon: Icon(
                isFavorited ? Icons.star : Icons.star_border,
                color: isFavorited ? Colors.red : null,
              ),
              onPressed: toggleFavorite,
            ),
          ),
          const SizedBox(width: 4),
          Text('$count'),
        ],
      ),
    );
  }
}

class ButtonsSection extends StatelessWidget {
  const ButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButton(context, Icons.call, 'CALL'),
        _buildButton(context, Icons.near_me, 'ROUTE'),
        _buildButton(context, Icons.share, 'SHARE'),
      ],
    );
  }

  Widget _buildButton(BuildContext context, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 30),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class TextSection extends StatelessWidget {
  final String text;

  const TextSection({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(text, softWrap: true, style: const TextStyle(fontSize: 16)),
    );
  }
}

class ImageSection extends StatelessWidget {
  const ImageSection({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Image.asset(image, width: 600, height: 240, fit: BoxFit.cover);
  }
}
