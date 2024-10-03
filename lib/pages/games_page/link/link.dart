import 'package:flutter/material.dart';

class LinkGamePage extends StatefulWidget {
  const LinkGamePage({Key? key}) : super(key: key);

  @override
  _LinkGamePageState createState() => _LinkGamePageState();
}

class _LinkGamePageState extends State<LinkGamePage> {
  List<ItemModel> items = [];
  List<ItemModel> itemsToMatch = [];
  int score = 0;
  bool isGameOver = false;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  void initGame() {
    items = [
      ItemModel(name: 'Apple', value: 'apple', imageUrl: 'https://icons.iconarchive.com/icons/fi3ur/fruitsalad/128/watermelon-icon.png'),
      ItemModel(name: 'Banana', value: 'banana', imageUrl: 'https://icons.iconarchive.com/icons/iconicon/veggies/256/bananas-icon.png'),
      ItemModel(name: 'Cherry', value: 'cherry', imageUrl: 'https://icons.iconarchive.com/icons/fi3ur/fruitsalad/128/apple-icon.png'),
      ItemModel(name: 'Pear', value: 'pear', imageUrl: 'https://icons.iconarchive.com/icons/fi3ur/fruitsalad/128/apple-icon.png'),
      ItemModel(name: 'Grape', value: 'grape', imageUrl: 'https://icons.iconarchive.com/icons/fi3ur/fruitsalad/128/apple-icon.png'),
      ItemModel(name: 'Strawberry', value: 'strawberry', imageUrl: 'https://icons.iconarchive.com/icons/fi3ur/fruitsalad/128/apple-icon.png'),
    ];

    // copy of the items list for the drag targets
    itemsToMatch = List<ItemModel>.from(items);
    items.shuffle();
    itemsToMatch.shuffle();

    score = 0;
    isGameOver = false;
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      isGameOver = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Word to Picture Linking Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Score: $score',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (!isGameOver)
              Row(
                children: [
                  // Words Column (on the left)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: items.map((item) {
                        return Container(
                          margin: const EdgeInsets.all(8.0),
                          child: Draggable<ItemModel>(
                            data: item,
                            childWhenDragging: Opacity(
                              opacity: 0.5,
                              child: Text(
                                item.name,
                                style: const TextStyle(fontSize: 24, color: Colors.grey),
                              ),
                            ),
                            feedback: Material(
                              child: Text(
                                item.name,
                                style: const TextStyle(fontSize: 24, color: Colors.teal),
                              ),
                            ),
                            child: Text(
                              item.name,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  // Spacer between columns
                  const SizedBox(width: 40),
                  // Pictures Column (on the right)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: itemsToMatch.map((item) {
                        return DragTarget<ItemModel>(
                          onAccept: (receivedItem) {
                            if (item.value == receivedItem.value) {
                              setState(() {
                                items.remove(receivedItem);
                                itemsToMatch.remove(item);
                                score += 10;
                              });
                            } else {
                              setState(() {
                                score -= 5;
                              });
                            }
                          },
                          onWillAccept: (receivedItem) => true,
                          builder: (context, acceptedItems, rejectedItems) => Container(
                            margin: const EdgeInsets.all(8.0),
                            color: Colors.teal.withOpacity(0.5),
                            height: 80,
                            width: 80,
                            alignment: Alignment.center,
                            child: Image.network(
                              item.imageUrl,
                              height: 60,
                              width: 60,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            if (isGameOver)
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Game Over!',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        initGame();
                        setState(() {});
                      },
                      child: const Text('New Game'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ItemModel {
  final String name;
  final String value;
  final String imageUrl;

  ItemModel({
    required this.name,
    required this.value,
    required this.imageUrl,
  });
}
