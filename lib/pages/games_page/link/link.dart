import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // Import for sharing functionality
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// A StatefulWidget representing the Emotion Linking Game.
class LinkGame extends StatefulWidget {
  final bool isEnglish; // Language preference flag

  const LinkGame({super.key, required this.isEnglish});

  @override
  _LinkGamePageState createState() => _LinkGamePageState();
}

/// State class for the LinkGame widget.
class _LinkGamePageState extends State<LinkGame> {
  // Lists to hold items and their matching counterparts.
  List<ItemModel> items = [];
  List<ItemModel> itemsToMatch = [];

  // Score variables
  int score = 0;
  int totalScore = 0; // Total score across all levels
  int level = 1;      // Current game level
  bool isGameOver = false;

  @override
  void initState() {
    super.initState();
    initGame(); // Initialize the game when the widget is first created
  }

  @override
  void dispose() {
    _saveScore(); // Save the score when the widget is disposed
    super.dispose();
  }

  /// Initializes the game based on the current level.
  void initGame() {
    switch (level) {
      case 1:
        initLevel1();
        break;
      case 2:
        initLevel2();
        break;
      case 3:
        initLevel3();
        break;
      case 4:
        initLevel4();
        break;
      case 5:
        initLevel5();
        break;
    }
    // Shuffle the items to randomize their order
    items.shuffle();
    itemsToMatch.shuffle();
    score = 0;       // Reset the score for the current level
    isGameOver = false;
  }

  /// Initializes the first level of the game.
  void initLevel1() {
    items = [
      ItemModel(
        name: 'Happy',
        finnishName: 'Iloinen',
        value: 'happy',
        imageUrl:
            'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Smiling-Face-Flat-icon.png',
      ),
      ItemModel(
        name: 'Sad',
        finnishName: 'Surullinen',
        value: 'sad',
        imageUrl:
            'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Crying-Face-Flat-icon.png',
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
    ];
    itemsToMatch = List<ItemModel>.from(items);
  }

  /// Initializes the second level of the game.
  void initLevel2() {
    items = [
      ItemModel(
        name: 'Excited',
        finnishName: 'Innoissaan',
        value: 'excited',
        imageUrl:
            'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Grinning-Face-With-Big-Eyes-Flat-icon.png',
      ),
      ItemModel(
        name: 'Calm',
        finnishName: 'Rauhallinen',
        value: 'calm',
        imageUrl:
            'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Relieved-Face-Flat-icon.png',
      ),
      ItemModel(
        name: 'Bored',
        finnishName: 'Tylsistynyt',
        value: 'bored',
        imageUrl:
            'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Unamused-Face-Flat-icon.png',
      ),
      ItemModel(
        name: 'Shy',
        finnishName: 'Ujo',
        value: 'shy',
        imageUrl:
            'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Flushed-Face-Flat-icon.png',
      ),
      ItemModel(
        name: 'Curious',
        finnishName: 'Utelias',
        value: 'curious',
        imageUrl:
            'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Thinking-Face-Flat-icon.png',
      ),
    ];
    itemsToMatch = List<ItemModel>.from(items);
  }

  /// Initializes the third level of the game.
  void initLevel3() {
    items = [
      ItemModel(
        name: 'Happy',
        finnishName: 'Iloinen',
        value: 'happy',
        imageUrl:
            'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Smiling-Face-Flat-icon.png',
      ),
      ItemModel(
        name: 'Excited',
        finnishName: 'Innoissaan',
        value: 'excited',
        imageUrl:
            'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Grinning-Face-With-Big-Eyes-Flat-icon.png',
      ),
      ItemModel(
        name: 'Sad',
        finnishName: 'Surullinen',
        value: 'sad',
        imageUrl:
            'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Crying-Face-Flat-icon.png',
      ),
      ItemModel(
        name: 'Calm',
        finnishName: 'Rauhallinen',
        value: 'calm',
        imageUrl:
            'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Relieved-Face-Flat-icon.png',
      ),
      ItemModel(
        name: 'Angry',
        finnishName: 'Vihainen',
        value: 'angry',
        imageUrl:
            'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Angry-Face-Flat-icon.png',
      ),
    ];
    itemsToMatch = List<ItemModel>.from(items);
  }

  /// Initializes the fourth level of the game.
  void initLevel4() {
    items = [
      ItemModel(
        name: 'Scared',
        finnishName: 'Peloissaan',
        value: 'scared',
        imageUrl:
            'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Fearful-Face-Flat-icon.png',
      ),
      ItemModel(
        name: 'Shy',
        finnishName: 'Ujo',
        value: 'shy',
        imageUrl:
            'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Flushed-Face-Flat-icon.png',
      ),
      ItemModel(
        name: 'Surprised',
        finnishName: 'Yllättynyt',
        value: 'surprised',
        imageUrl:
            'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Astonished-Face-Flat-icon.png',
      ),
      ItemModel(
        name: 'Curious',
        finnishName: 'Utelias',
        value: 'curious',
        imageUrl:
            'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Thinking-Face-Flat-icon.png',
      ),
      ItemModel(
        name: 'Bored',
        finnishName: 'Tylsistynyt',
        value: 'bored',
        imageUrl:
            'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Unamused-Face-Flat-icon.png',
      ),
    ];
    itemsToMatch = List<ItemModel>.from(items);
  }

  /// Initializes the fifth level of the game.
  void initLevel5() {
    items = [
      ItemModel(
        name: 'Angry',
        finnishName: 'Vihainen',
        value: 'angry',
        imageUrl:
            'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Angry-Face-Flat-icon.png',
      ),
      ItemModel(
        name: 'Sad',
        finnishName: 'Surullinen',
        value: 'sad',
        imageUrl:
            'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Crying-Face-Flat-icon.png',
      ),
      ItemModel(
        name: 'Excited',
        finnishName: 'Innoissaan',
        value: 'excited',
        imageUrl:
            'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Grinning-Face-With-Big-Eyes-Flat-icon.png',
      ),
      ItemModel(
        name: 'Scared',
        finnishName: 'Peloissaan',
        value: 'scared',
        imageUrl:
            'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Fearful-Face-Flat-icon.png',
      ),
      ItemModel(
        name: 'Calm',
        finnishName: 'Rauhallinen',
        value: 'calm',
        imageUrl:
            'https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-flat/128/Relieved-Face-Flat-icon.png',
      ),
    ];
    itemsToMatch = List<ItemModel>.from(items);
  }

  /// Checks if the game is over and progresses to the next level or ends the game.
  void checkGameOver() {
    if (items.isEmpty && itemsToMatch.isEmpty) {
      totalScore += score; // Add current level score to total score
      _saveScore();        // Save the score to Firestore

      if (level < 5) {
        level++;
        initGame();        // Initialize the next level
        setState(() {});
      } else {
        isGameOver = true;
        _onGameCompleted(totalScore); // Update points and level in Firestore
        showFinalScoreDialog();       // Show final score dialog
      }
    }
  }

  /// Saves the total score to Firestore.
  void _saveScore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Save the current score to Firestore
      await userDoc.set({
        'scoreLink': totalScore,
      }, SetOptions(merge: true));
    }
  }

  /// Updates the user's points and level in Firestore after game completion.
  void _onGameCompleted(int pointsEarned) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Fetch current points and level from Firestore
      DocumentSnapshot userSnapshot = await userDoc.get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        int currentPoints = userData['currentPoints'] ?? 0;
        int currentLevel = userData['level'] ?? 1;
        int pointsForNextLevel = 1000;

        // Update points and level
        currentPoints += pointsEarned;
        if (currentPoints >= pointsForNextLevel) {
          currentLevel++;
          currentPoints -= pointsForNextLevel;
        }

        // Update Firestore with new points and level
        await userDoc.update({
          'currentPoints': currentPoints,
          'level': currentLevel,
        });
      } else {
        // Create a new document if it doesn't exist
        await userDoc.set({
          'currentPoints': pointsEarned,
          'level': 1,
        });
      }
    }
  }

  /// Displays the final score dialog with options to share or start a new game.
  void showFinalScoreDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(widget.isEnglish ? 'Congratulations!' : 'Onnittelut!'),
          content: Text(
            widget.isEnglish
                ? 'You have completed all levels!\nYour final score: $totalScore'
                : 'Olet suorittanut kaikki tasot!\nLopulliset pisteesi: $totalScore',
          ),
          actions: [
            // Share Score Button
            TextButton(
              onPressed: () {
                Share.share(
                  widget.isEnglish
                      ? 'I completed all levels in the Emotion Linking Game! My final score: $totalScore'
                      : 'Suoritin kaikki tasot Tunteiden Yhdistämispelissä! Lopulliset pisteeni: $totalScore',
                );
              },
              child:
                  Text(widget.isEnglish ? 'Share Score' : 'Jaa Pisteet'),
            ),
            // New Game Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: Text(widget.isEnglish ? 'New Game' : 'Uusi peli'),
            ),
          ],
        );
      },
    );
  }

  /// Resets the game to the initial state.
  void resetGame() {
    level = 1;
    score = 0;
    totalScore = 0; // Reset total score
    initGame();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEnglish
              ? 'Emotion Linking Game'
              : 'Tunteiden Yhdistämispeli',
        ), // Switch title based on language
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display current score and level
            Text(
              widget.isEnglish ? 'Score: $score' : 'Pisteet: $score',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.isEnglish
                  ? 'Total Score: $totalScore'
                  : 'Kokonaispisteet: $totalScore',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              widget.isEnglish ? 'Level: $level' : 'Taso: $level',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            if (!isGameOver)
              Row(
                children: [
                  // Words Column (Draggable items)
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
                            feedback: Material(
                              color: Colors.transparent,
                              child: Text(
                                widget.isEnglish
                                    ? item.name
                                    : item.finnishName,
                                style: const TextStyle(
                                  fontSize: 26,
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      offset: Offset(1, 2),
                                      blurRadius: 3,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            childWhenDragging: Opacity(
                              opacity: 0.5,
                              child: Text(
                                widget.isEnglish
                                    ? item.name
                                    : item.finnishName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            child: Text(
                              widget.isEnglish
                                  ? item.name
                                  : item.finnishName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    offset: Offset(1, 2),
                                    blurRadius: 3,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 40),
                  // Images Column (Drag targets)
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
                                score += 10; // Increase score for correct match
                              });
                              checkGameOver();
                            } else {
                              setState(() {
                                score = (score - 5).clamp(0, double.infinity).toInt();
                                // Decrease score but not below zero
                              });
                            }
                          },
                          onWillAccept: (receivedItem) => true,
                          builder: (context, acceptedItems, rejectedItems) {
                            return Container(
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
                            );
                          },
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
                    Text(
                      widget.isEnglish ? 'Well Played!' : 'Hyvin Pelattu!',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: resetGame,
                      child: Text(widget.isEnglish ? 'New Game' : 'Uusi peli'),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

/// Model class representing each item in the game.
class ItemModel {
  final String name;        // Name in English
  final String finnishName; // Name in Finnish
  final String value;       // Unique value for matching
  final String imageUrl;    // URL of the image

  ItemModel({
    required this.name,
    required this.finnishName,
    required this.value,
    required this.imageUrl,
  });
}
