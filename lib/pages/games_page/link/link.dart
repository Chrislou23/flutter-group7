import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_games/timer_provider.dart';

class LinkGame extends StatefulWidget {
  const LinkGame({Key? key}) : super(key: key);

  @override
  _LinkGamePageState createState() => _LinkGamePageState();
}

class _LinkGamePageState extends State<LinkGame> {
  List<ItemModel> items = [];
  List<ItemModel> itemsToMatch = [];
  int score = 0;
  int level = 1;
  bool isGameOver = false;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  void initGame() {
    Map<int, List<ItemModel>> levelItems = {
      1: [
        ItemModel(
          name: 'Happy',
          finnishName: 'Iloinen',
          value: 'happy',
          imageUrl:
              'https://icons.iconarchive.com/icons/seanau/flat-smiley/128/Smiley-1-icon.png',
        ),
        ItemModel(
          name: 'Sad',
          finnishName: 'Surullinen',
          value: 'sad',
          imageUrl:
              'https://icons.iconarchive.com/icons/icons-land/flat-emoticons/128/Cry-icon.png',
        ),
        ItemModel(
          name: 'Angry',
          finnishName: 'Vihainen',
          value: 'angry',
          imageUrl:
              'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Angry-Face-Flat-icon.png',
        ),
      ],
      // More levels can be added here.
    };

    items = levelItems[level] ?? [];
    itemsToMatch = List<ItemModel>.from(items);

    items.shuffle();
    itemsToMatch.shuffle();

    score = 0;
    isGameOver = false;
  }

  void checkGameOver() {
    if (items.isEmpty) {
      if (level < 5) {
        level++;
        initGame();
      } else {
        isGameOver = true;
        showFinalScoreDialog();
      }
      setState(() {});
    }
  }

  void showFinalScoreDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content:
              Text('You have completed all levels!\nYour final score: $score'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: const Text('New Game'),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    level = 1;
    score = 0;
    initGame();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, timerProvider, child) {
        if (timerProvider.isBlocked) {
          return _buildBlockedScreen();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Emotion Linking Game'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.black),
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Score: $score',
                  style:
                      const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Level: $level',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                if (!isGameOver)
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: items.map((item) {
                            return Container(
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.tealAccent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.teal, width: 2),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(2, 2),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  )
                                ],
                              ),
                              child: Draggable<ItemModel>(
                                data: item,
                                childWhenDragging: Opacity(
                                  opacity: 0.5,
                                  child: Text(
                                    '${item.name} / ${item.finnishName}',
                                    style: const TextStyle(
                                        fontSize: 24,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                              color: Colors.black26,
                                              offset: Offset(1, 2),
                                              blurRadius: 2)
                                        ]),
                                  ),
                                ),
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    '${item.name} / ${item.finnishName}',
                                    style: const TextStyle(
                                        fontSize: 26,
                                        color: Colors.teal,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                              color: Colors.black26,
                                              offset: Offset(1, 2),
                                              blurRadius: 3)
                                        ]),
                                  ),
                                ),
                                child: Text(
                                  '${item.name} / ${item.finnishName}',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      shadows: [
                                        Shadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 2),
                                            blurRadius: 3)
                                      ]),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(width: 40),
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
                                  checkGameOver();
                                } else {
                                  setState(() {
                                    score -= 5;
                                  });
                                }
                              },
                              onWillAccept: (receivedItem) => true,
                              builder:
                                  (context, acceptedItems, rejectedItems) =>
                                      Container(
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
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            resetGame();
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
      },
    );
  }

  Widget _buildBlockedScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.lock, size: 100, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            'REST YOUR EYES',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class ItemModel {
  final String name;
  final String finnishName;
  final String value;
  final String imageUrl;

  ItemModel({
    required this.name,
    required this.finnishName,
    required this.value,
    required this.imageUrl,
  });
}