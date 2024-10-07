import 'package:flutter/material.dart';

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
    // Define items for the game for all levels related to emotions
    Map<int, List<ItemModel>> levelItems = {
      // Level 1 - Basic Emotions (5 items)
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
        ItemModel(
          name: 'Scared',
          finnishName: 'Peloissaan',
          value: 'scared',
          imageUrl:
              'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Fearful-Face-Flat-icon.png',
        ),
        ItemModel(
          name: 'Surprised',
          finnishName: 'Yllättynyt',
          value: 'surprised',
          imageUrl:
              'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Astonished-Face-Flat-icon.png',
        ),
      ],
      // Level 2 - Emotions with Actions (5 items)
      2: [
        ItemModel(
          name: 'Laughing',
          finnishName: 'Naurava',
          value: 'laughing',
          imageUrl:
              'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Grinning-Squinting-Face-Flat-icon.png',
        ),
        ItemModel(
          name: 'Crying',
          finnishName: 'Itkee',
          value: 'crying',
          imageUrl:
              'https://icons.iconarchive.com/icons/icons-land/flat-emoticons/128/Cry-icon.png',
        ),
        ItemModel(
          name: 'Smiling',
          finnishName: 'Hymyilee',
          value: 'smiling',
          imageUrl:
              'https://icons.iconarchive.com/icons/google/noto-emoji-smileys/128/10101-smiling-face-icon.png',
        ),
        ItemModel(
          name: 'Yawning',
          finnishName: 'Haukottelee',
          value: 'yawning',
          imageUrl:
              'https://icons.iconarchive.com/icons/google/noto-emoji-smileys/128/10103-yawning-face-icon.png',
        ),
        ItemModel(
          name: 'Thinking',
          finnishName: 'Ajattelee',
          value: 'thinking',
          imageUrl:
              'https://icons.iconarchive.com/icons/google/noto-emoji-smileys/128/10104-thinking-face-icon.png',
        ),
      ],
      // Level 3 - Emotions in Situations (6 items)
      3: [
        ItemModel(
          name: 'Feeling excited',
          finnishName: 'Innostunut',
          value: 'excited',
          imageUrl:
              'https://icons.iconarchive.com/icons/google/noto-emoji-smileys/128/10100-smiling-face-with-open-mouth-icon.png',
        ),
        ItemModel(
          name: 'Feeling bored',
          finnishName: 'Tylsistynyt',
          value: 'bored',
          imageUrl:
              'https://icons.iconarchive.com/icons/google/noto-emoji-smileys/128/10118-zzz-icon.png',
        ),
        ItemModel(
          name: 'Feeling sleepy',
          finnishName: 'Väsynyt',
          value: 'sleepy',
          imageUrl:
              'https://icons.iconarchive.com/icons/google/noto-emoji-smileys/128/10119-sleepy-face-icon.png',
        ),
        ItemModel(
          name: 'Feeling proud',
          finnishName: 'Ylpeä',
          value: 'proud',
          imageUrl:
              'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Star-Struck-Face-Flat-icon.png',
        ),
        ItemModel(
          name: 'Feeling nervous',
          finnishName: 'Hermostunut',
          value: 'nervous',
          imageUrl:
              'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Nervous-Face-Flat-icon.png',
        ),
        ItemModel(
          name: 'Feeling confused',
          finnishName: 'Hämmentynyt',
          value: 'confused',
          imageUrl:
              'https://icons.iconarchive.com/icons/google/noto-emoji-smileys/128/10112-confused-face-icon.png',
        ),
      ],
      // Level 4 - Emotions with Expressions (6 items)
      4: [
        ItemModel(
          name: 'Feeling loved',
          finnishName: 'Rakastettu',
          value: 'loved',
          imageUrl:
              'https://icons.iconarchive.com/icons/google/noto-emoji-smileys/128/10105-smiling-face-with-hearts-icon.png',
        ),
        ItemModel(
          name: 'Feeling thankful',
          finnishName: 'Kiitollinen',
          value: 'thankful',
          imageUrl:
              'https://icons.iconarchive.com/icons/google/noto-emoji-smileys/128/10106-grinning-face-with-halo-icon.png',
        ),
        ItemModel(
          name: 'Feeling surprised',
          finnishName: 'Yllättynyt',
          value: 'surprised',
          imageUrl:
              'https://icons.iconarchive.com/icons/google/noto-emoji-smileys/128/10108-hushed-face-icon.png',
        ),
        ItemModel(
          name: 'Feeling frustrated',
          finnishName: 'Turhautunut',
          value: 'frustrated',
          imageUrl:
              'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Pouting-Face-Flat-icon.png',
        ),
        ItemModel(
          name: 'Feeling hopeful',
          finnishName: 'Toiveikas',
          value: 'hopeful',
          imageUrl:
              'https://icons.iconarchive.com/icons/google/noto-emoji-smileys/128/10107-smiling-face-with-open-mouth-and-smiling-eyes-icon.png',
        ),
        ItemModel(
          name: 'Feeling proud of myself',
          finnishName: 'Ylpeä itsestäni',
          value: 'proudSelf',
          imageUrl:
              'https://icons.iconarchive.com/icons/google/noto-emoji-smileys/128/10117-relieved-face-icon.png',
        ),
      ],
      // Level 5 - Combinations of Emotions (7 items)
      5: [
        ItemModel(
          name: 'Feeling loved and happy',
          finnishName: 'Rakastettu ja iloinen',
          value: 'lovedHappy',
          imageUrl:
              'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Smiling-Face-with-Hearts-Flat-icon.png',
        ),
        ItemModel(
          name: 'Feeling excited and surprised',
          finnishName: 'Innostunut ja yllättynyt',
          value: 'excitedSurprised',
          imageUrl:
              'https://icons.iconarchive.com/icons/google/noto-emoji-smileys/128/10110-flushed-face-icon.png',
        ),
        ItemModel(
          name: 'Feeling scared but hopeful',
          finnishName: 'Pelokas mutta toiveikas',
          value: 'scaredHopeful',
          imageUrl:
              'https://icons.iconarchive.com/icons/google/noto-emoji-smileys/128/10116-face-with-open-mouth-and-cold-sweat-icon.png',
        ),
        ItemModel(
          name: 'Feeling angry and sad',
          finnishName: 'Vihainen ja surullinen',
          value: 'angrySad',
          imageUrl:
              'https://icons.iconarchive.com/icons/google/noto-emoji-smileys/128/10114-frowning-face-with-open-mouth-icon.png',
        ),
        ItemModel(
          name: 'Feeling grateful and relaxed',
          finnishName: 'Kiitollinen ja rentoutunut',
          value: 'gratefulRelaxed',
          imageUrl:
              'https://icons.iconarchive.com/icons/google/noto-emoji-smileys/128/10109-smiling-face-with-halo-icon.png',
        ),
        ItemModel(
          name: 'Feeling proud and happy',
          finnishName: 'Ylpeä ja iloinen',
          value: 'proudHappy',
          imageUrl:
              'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Star-Struck-Face-Flat-icon.png',
        ),
        ItemModel(
          name: 'Feeling relaxed and peaceful',
          finnishName: 'Rentoutunut ja rauhallinen',
          value: 'relaxedPeaceful',
          imageUrl:
              'https://icons.iconarchive.com/icons/google/noto-emoji-smileys/128/10113-sleeping-face-icon.png',
        ),
      ],
    };

    // Get items for the current level
    items = levelItems[level] ?? [];
    itemsToMatch = List<ItemModel>.from(items);

    items.shuffle();
    itemsToMatch.shuffle();

    score = 0;
    isGameOver = false;
  }

  void checkGameOver() {
    // Check if all items are matched
    if (items.isEmpty) {
      if (level < 5) {
        level++;
        initGame(); // Move to the next level
      } else {
        isGameOver = true;
        showFinalScoreDialog(); // Game completed, show final score
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
                Navigator.of(context).pop(); // Close the dialog
                resetGame(); // Reset the game for a new round
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
    if (items.isEmpty && !isGameOver) {
      checkGameOver();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emotion Linking Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Score: $score',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Level: $level',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                              checkGameOver();
                            } else {
                              setState(() {
                                score -= 5;
                              });
                            }
                          },
                          onWillAccept: (receivedItem) => true,
                          builder: (context, acceptedItems, rejectedItems) =>
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
