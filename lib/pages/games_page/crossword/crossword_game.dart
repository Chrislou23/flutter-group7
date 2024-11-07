import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

/// A StatefulWidget representing the Crossword Game.
class CrosswordGame extends StatefulWidget {
  final bool isFinnish; // Flag to determine the language (Finnish or English)

  const CrosswordGame({super.key, required this.isFinnish});

  @override
  _CrosswordGameState createState() => _CrosswordGameState();
}

/// Class to represent each word in the crossword.
class CrosswordWord {
  String word;       // The actual word
  String clue;       // Clue for the word
  int row;           // Starting row in the grid
  int col;           // Starting column in the grid
  bool isHorizontal; // Direction of the word
  int number;        // Clue number

  CrosswordWord({
    required this.word,
    required this.clue,
    required this.row,
    required this.col,
    required this.isHorizontal,
    required this.number,
  });
}

class _CrosswordGameState extends State<CrosswordGame> {
  // Grid variables
  late int gridSize;
  late List<List<String?>> grid;
  late List<List<TextEditingController?>> controllers;
  late List<List<int?>> numbers;

  // Game state variables
  int currentLevel = 1;
  int maxLevel = 5;
  int failedAttempts = 0;
  int checkAnswerClicks = 0;
  bool showLightbulb = false;
  int score = 0;
  int currentScore = 0;
  int level = 1;
  int? selectedClueIndex; // Index of the currently selected clue

  // Controller for word input
  TextEditingController wordInputController = TextEditingController();

  // Levels data for Finnish
final Map<int, List<CrosswordWord>> finnishLevels = {
    1: [
      CrosswordWord(
          word: 'PELKO',
          clue: '1. Kun jokin asia pelottaa sinua',
          row: 1,
          col: 6,
          isHorizontal: false,
          number: 1),
      CrosswordWord(
          word: 'SURU',
          clue: '2. Kun kyyneleet tulevat silmiin',
          row: 2,
          col: 0,
          isHorizontal: false,
          number: 2),
      CrosswordWord(
          word: 'INHO',
          clue: '3. Kun joku asia tuntuu epämiellyttävältät',
          row: 2,
          col: 3,
          isHorizontal: false,
          number: 3),
      CrosswordWord(
          word: 'MIELE',
          clue: '4. Miten tunnet itsesi juuri nyt',
          row: 2,
          col: 2,
          isHorizontal: true,
          number: 4),
      CrosswordWord(
          word: 'RAUHA',
          clue: '5. Kun kaikki on hiljaista ja levollista',
          row: 4,
          col: 0,
          isHorizontal: true,
          number: 5),
    ],
    2: [
      CrosswordWord(
          word: 'ILO',
          clue: '1. Kun hymyilet ja naurat',
          row: 1,
          col: 0,
          isHorizontal: false,
          number: 1),
      CrosswordWord(
          word: 'TUSKA',
          clue: '2. Kun sattuu ja tuntuu pahalta',
          row: 6,
          col: 2,
          isHorizontal: true,
          number: 2),
      CrosswordWord(
          word: 'RIEMU',
          clue: '3. Kun ilo on todella suurta',
          row: 2,
          col: 3,
          isHorizontal: false,
          number: 3),
      CrosswordWord(
          word: 'VIHA',
          clue: '4. Kun jokin harmittaa sinua kovasti ',
          row: 3,
          col: 6,
          isHorizontal: false,
          number: 4),
      CrosswordWord(
          word: 'ONNI',
          clue: '5. Kun kaikki on hyvin ja olet iloinen',
          row: 3,
          col: 0,
          isHorizontal: true,
          number: 5),
    ],
    3: [
      CrosswordWord(
          word: 'IKÄVÄ',
          clue: '1. Kun kaipaat jotain tai jotakuta',
          row: 2,
          col: 2,
          isHorizontal: false,
          number: 1),
      CrosswordWord(
          word: 'TOIVO',
          clue: '2. Kun uskot, että jotain hyvää tapahtuu',
          row: 2,
          col: 0,
          isHorizontal: true,
          number: 2),
      CrosswordWord(
          word: 'HÄPEÄ',
          clue: '3. Kun punastut ja tunnet olosi noloksi',
          row: 6,
          col: 1,
          isHorizontal: true,
          number: 3),
      CrosswordWord(
          word: 'HUOLI',
          clue: '4. Kun ajattelet paljon jotain ikävää',
          row: 0,
          col: 4,
          isHorizontal: false,
          number: 4),
      CrosswordWord(
          word: 'YIPEÄ',
          clue: '5. Kun olet tehnyt jotain hienoa',
          row: 4,
          col: 3,
          isHorizontal: true,
          number: 5),
    ],
    4: [
      CrosswordWord(
          word: 'LEVOTON',
          clue: '1. Kun et pysty olemaan paikallasi',
          row: 0,
          col: 3,
          isHorizontal: false,
          number: 1),
      CrosswordWord(
          word: 'REIPAS',
          clue: '2. Kun sinulla on paljon energiaa ja olet iloinen',
          row: 1,
          col: 2,
          isHorizontal: true,
          number: 2),
      CrosswordWord(
          word: 'INTO',
          clue: '3. Kun odotat innoissasi jotain kivaa',
          row: 3,
          col: 0,
          isHorizontal: true,
          number: 3),
      CrosswordWord(
          word: 'KIUKKU',
          clue: '4. Kun jokin saa sinut ärsyyntymään',
          row: 2,
          col: 0,
          isHorizontal: false,
          number: 4),
      CrosswordWord(
          word: 'HAIKEA',
          clue: '5. Kun tunnet iloa ja surua yhtä aikaa',
          row: 0,
          col: 6,
          isHorizontal: false,
          number: 5),
    ],
    5: [
      CrosswordWord(
          word: 'AATOS',
          clue: '1. Kun mietit jotain asiaa',
          row: 3,
          col: 1,
          isHorizontal: true,
          number: 1),
      CrosswordWord(
          word: 'APU',
          clue: '2. Kun joku auttaa sinua, tunnet olosi paremmaksi',
          row: 2,
          col: 5,
          isHorizontal: true,
          number: 2),
      CrosswordWord(
          word: 'HUPI',
          clue: '3. Kun jokin asia saa sinut nauramaan',
          row: 0,
          col: 2,
          isHorizontal: true,
          number: 3),
      CrosswordWord(
          word: 'IHAILU',
          clue: '4. Kun pidät todella paljon jostain',
          row: 5,
          col: 0,
          isHorizontal: true,
          number: 4),
      CrosswordWord(
          word: 'IHASTUS',
          clue: '5. Kun pidät jostain erityisesti ',
          row: 0,
          col: 5,
          isHorizontal: false,
          number: 5),
    ],
    // Additional levels are truncated for brevity
  };

  // Levels data for English
  final Map<int, List<CrosswordWord>> englishLevels = {
    1: [
      CrosswordWord(
          word: 'GLAD',
          clue: '1. Another word for feeling happy or pleased',
          row: 7,
          col: 0,
          isHorizontal: true,
          number: 1),
      CrosswordWord(
          word: 'SCARED',
          clue: '2. When something makes you feel afraid or nervous',
          row: 2,
          col: 3,
          isHorizontal: false,
          number: 2),
      CrosswordWord(
          word: 'HAPPY',
          clue: '3. When you feel like smiling and everything is good',
          row: 4,
          col: 2,
          isHorizontal: true,
          number: 3),
      CrosswordWord(
          word: 'ANGRY',
          clue: '4. When you feel really mad about something',
          row: 0,
          col: 6,
          isHorizontal: false,
          number: 4),
      CrosswordWord(
          word: 'SAD',
          clue: '5. When you feel like crying or something makes you upset',
          row: 0,
          col: 5,
          isHorizontal: true,
          number: 5),
    ],
    2: [
      CrosswordWord(
        word: 'SILLY',
        clue: '1. When you feel playful and like to joke around',
        row: 3,
        col: 2,
        isHorizontal: true,
        number: 1,
      ),
      CrosswordWord(
        word: 'TIRED',
        clue: '2. When you feel like you need to sleep or rest',
        row: 0,
        col: 0,
        isHorizontal: true,
        number: 2,
      ),
      CrosswordWord(
        word: 'EXCITED',
        clue: '3. When you can’t wait for something fun to happen',
        row: 0,
        col: 3,
        isHorizontal: false,
        number: 3,
      ),
      CrosswordWord(
        word: 'LONELY',
        clue: '4. When you feel like you have no one to play with',
        row: 5,
        col: 0,
        isHorizontal: true,
        number: 4,
      ),
      CrosswordWord(
        word: 'CALM',
        clue: '5. When everything is quiet and peaceful inside',
        row: 3,
        col: 0,
        isHorizontal: false,
        number: 5,
      ),
    ],
    3: [
      CrosswordWord(
        word: 'SHY',
        clue: '1. When you feel nervous around new people',
        row: 6,
        col: 1,
        isHorizontal: true,
        number: 1,
      ),
      CrosswordWord(
        word: 'PROUD',
        clue: '2. When you feel good about something you’ve done',
        row: 2,
        col: 0,
        isHorizontal: true,
        number: 2,
      ),
      CrosswordWord(
        word: 'NERVOUS',
        clue: '3.  When you feel a little scared or worried',
        row: 0,
        col: 1,
        isHorizontal: false,
        number: 3,
      ),
      CrosswordWord(
        word: 'CONFUSED',
        clue: '4. When you don’t understand something and feel mixed up',
        row: 4,
        col: 0,
        isHorizontal: true,
        number: 4,
      ),
      CrosswordWord(
        word: 'MAD',
        clue: '5.  Another word for feeling angry',
        row: 0,
        col: 4,
        isHorizontal: false,
        number: 5,
      ),
    ],
    4: [
      CrosswordWord(
        word: 'BRAVE',
        clue: '1. When you are not scared to do something hard or new',
        row: 1,
        col: 0,
        isHorizontal: true,
        number: 1,
      ),
      CrosswordWord(
        word: 'AFRAID',
        clue: '2. When you feel like something bad might happen',
        row: 1,
        col: 2,
        isHorizontal: false,
        number: 2,
      ),
      CrosswordWord(
        word: 'GRUMPY',
        clue: '3. When you feel a bit mad or cranky',
        row: 3,
        col: 1,
        isHorizontal: true,
        number: 3,
      ),
      CrosswordWord(
        word: 'JOYFUL',
        clue: '4. A word for feeling very, very happy',
        row: 1,
        col: 6,
        isHorizontal: false,
        number: 4,
      ),
      CrosswordWord(
        word: 'KIND',
        clue: '5. When you are nice and caring to others',
        row: 5,
        col: 1,
        isHorizontal: true,
        number: 5,
      ),
    ],
    5: [
      CrosswordWord(
        word: 'HOPEFUL',
        clue: '1. When you believe something good will happen',
        row: 2,
        col: 1,
        isHorizontal: true,
        number: 1,
      ),
      CrosswordWord(
        word: 'SORRY',
        clue: '2. When you feel bad about something you did wrong',
        row: 1,
        col: 2,
        isHorizontal: false,
        number: 2,
      ),
      CrosswordWord(
        word: 'BORED',
        clue: '3. When there’s nothing fun to do',
        row: 4,
        col: 0,
        isHorizontal: true,
        number: 3,
      ),
      CrosswordWord(
        word: 'UPSET',
        clue: '4. When something makes you feel sad or worried',
        row: 2,
        col: 6,
        isHorizontal: false,
        number: 4,
      ),
      CrosswordWord(
        word: 'HURT',
        clue: '5. When you feel pain',
        row: 6,
        col: 3,
        isHorizontal: true,
        number: 5,
      ),
    ],
    // Additional levels are truncated for brevity
  };

  @override
  void initState() {
    super.initState();
    _generateCrossword(); // Generate the crossword grid
  }

  /// Initializes the grid, controllers, and numbers matrices.
  void initializeGrid() {
    grid = List.generate(gridSize, (_) => List.filled(gridSize, null));
    controllers = List.generate(gridSize, (_) => List.filled(gridSize, null));
    numbers = List.generate(gridSize, (_) => List.filled(gridSize, null));
  }

  /// Generates the crossword based on the current level and language.
  void _generateCrossword() {
    // Choose levels based on language
    final levels = widget.isFinnish ? finnishLevels : englishLevels;

    // Determine the grid size based on the longest word
    int longestWordLength = levels[currentLevel]!
        .map((word) => word.word.length)
        .reduce((a, b) => a > b ? a : b);

    gridSize = longestWordLength > 9 ? longestWordLength + 2 : 8;
    initializeGrid();

    // Get the crossword data for the current level
    List<CrosswordWord> crosswordData = levels[currentLevel] ?? [];

    // Place each word in the grid
    for (var wordData in crosswordData) {
      _placeWord(
        wordData.word,
        wordData.row,
        wordData.col,
        wordData.isHorizontal,
        wordData.number,
      );
    }
    setState(() {});
  }

  /// Places a word in the grid if possible.
  void _placeWord(
      String word, int row, int col, bool isHorizontal, int number) {
    // Check if the word can be placed without conflicts
    for (int i = 0; i < word.length; i++) {
      int currentRow = row + (isHorizontal ? 0 : i);
      int currentCol = col + (isHorizontal ? i : 0);

      // Check grid bounds
      if (currentRow >= gridSize || currentCol >= gridSize) {
        return; // Word doesn't fit
      }

      // Check for conflicting letters
      if (grid[currentRow][currentCol] != null &&
          grid[currentRow][currentCol] != word[i]) {
        return; // Conflict with existing word
      }
    }

    // Place the word in the grid
    for (int i = 0; i < word.length; i++) {
      int currentRow = row + (isHorizontal ? 0 : i);
      int currentCol = col + (isHorizontal ? i : 0);

      grid[currentRow][currentCol] = word[i];
      controllers[currentRow][currentCol] ??= TextEditingController();

      // Assign clue number to the first letter
      if (i == 0) {
        numbers[currentRow][currentCol] = number;
      }
    }
  }

  /// Checks if the crossword is completely and correctly filled.
  bool _isCrosswordCompleted() {
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (grid[row][col] != null &&
            controllers[row][col]?.text.toUpperCase() != grid[row][col]) {
          return false; // Incomplete or incorrect letter
        }
      }
    }
    return true; // All letters are correct
  }

  /// Selects a clue and clears the word input controller.
  void _selectClue(int index) {
    setState(() {
      selectedClueIndex = index;
      wordInputController.clear();
    });
  }

  /// Updates the selected word based on user input.
  void _updateSelectedWord(String input) {
    if (selectedClueIndex == null) return;

    final levels = widget.isFinnish ? finnishLevels : englishLevels;
    var selectedWordData = levels[currentLevel]![selectedClueIndex!];

    String word = selectedWordData.word;
    int row = selectedWordData.row;
    int col = selectedWordData.col;
    bool isHorizontal = selectedWordData.isHorizontal;

    for (int i = 0; i < word.length && i < input.length; i++) {
      int currentRow = row + (isHorizontal ? 0 : i);
      int currentCol = col + (isHorizontal ? i : 0);

      if (currentRow >= gridSize || currentCol >= gridSize) continue;

      controllers[currentRow][currentCol]?.text = input[i].toUpperCase();
    }
  }

  /// Moves the game to the next level.
  void _moveToNextLevel() {
    if (currentLevel < maxLevel) {
      setState(() {
        currentLevel++;
        failedAttempts = 0;
        checkAnswerClicks = 0;
        showLightbulb = false;
        _generateCrossword();
      });
    }
  }

  /// Reveals up to 3 random letters in the crossword.
  void _showRandomLetters() {
    final levels = widget.isFinnish ? finnishLevels : englishLevels;
    List<CrosswordWord> crosswordData = levels[currentLevel] ?? [];
    Random random = Random();
    int lettersRevealed = 0;

    Set<String> revealedPositions = {};

    // Collect all empty positions
    List<String> emptyPositions = [];
    for (var wordData in crosswordData) {
      for (int i = 0; i < wordData.word.length; i++) {
        int currentRow = wordData.row + (wordData.isHorizontal ? 0 : i);
        int currentCol = wordData.col + (wordData.isHorizontal ? i : 0);
        String positionKey = '$currentRow-$currentCol';

        if (currentRow < gridSize &&
            currentCol < gridSize &&
            (controllers[currentRow][currentCol]?.text.isEmpty ?? true)) {
          emptyPositions.add(positionKey);
        }
      }
    }

    // Shuffle and reveal letters
    emptyPositions.shuffle(random);
    for (var positionKey in emptyPositions) {
      if (lettersRevealed >= 3) break;

      var parts = positionKey.split('-');
      int currentRow = int.parse(parts[0]);
      int currentCol = int.parse(parts[1]);

      for (var wordData in crosswordData) {
        for (int i = 0; i < wordData.word.length; i++) {
          int wordRow = wordData.row + (wordData.isHorizontal ? 0 : i);
          int wordCol = wordData.col + (wordData.isHorizontal ? i : 0);

          if (wordRow == currentRow && wordCol == currentCol) {
            controllers[currentRow][currentCol]?.text =
                wordData.word[i].toUpperCase();
            revealedPositions.add(positionKey);
            lettersRevealed++;
            break;
          }
        }
      }
    }

    // Deduct points for using the lightbulb
    setState(() {
      score = max(score - 20, 0);
    });
  }

  /// Increments the number of failed attempts and deducts points.
  void _incrementFailedAttempts() {
    setState(() {
      failedAttempts++;
      score = max(score - 5, 0); // Ensure score is not negative
    });
  }

  /// Updates the user's score in Firebase when the game is completed.
  void _onGameCompleted(int pointsEarned) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

      DocumentSnapshot userSnapshot = await userDoc.get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

        int currentCrosswordScore = userData['scoreCrossword'] ?? 0;
        int currentTotalScore = userData['scoreTotal'] ?? 0;

        currentCrosswordScore += pointsEarned;
        currentTotalScore += pointsEarned;

        // Update scores in Firestore
        await userDoc.update({
          'scoreCrossword': currentCrosswordScore,
          'scoreTotal': currentTotalScore,
        });
      } else {
        // Set initial scores if user data doesn't exist
        await userDoc.set({
          'scoreCrossword': pointsEarned,
          'scoreTotal': pointsEarned,
        });
      }
    }
  }

  /// Checks the user's answers and provides feedback.
  void _checkAnswers() {
    FocusScope.of(context).unfocus(); // Dismiss the keyboard

    if (_isCrosswordCompleted()) {
      score += 50; // Add points for completion

      if (currentLevel < maxLevel) {
        // Show level completion dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Level Complete!'),
              content: const Text('You have completed this level.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Next Level'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _moveToNextLevel();
                  },
                ),
              ],
            );
          },
        );
      } else {
        _onGameCompleted(score); // Update Firebase with the final score
        showFinalScoreDialog();  // Show the final score dialog
      }
    } else {
      _incrementFailedAttempts();
      checkAnswerClicks++;
      if (checkAnswerClicks >= 3) {
        setState(() {
          showLightbulb = true; // Show hint option after multiple attempts
        });
      }
      // Show try again dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Try Again'),
            content: const Text('Some answers are incorrect.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  /// Displays the final score dialog with sharing options.
  void showFinalScoreDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.isFinnish ? 'Onnittelut!' : 'Congratulations!'),
          content: Text(
            widget.isFinnish
                ? 'Olet suorittanut kaikki tasot!\nLopulliset pisteesi: $score'
                : 'You have completed all levels!\nYour final score: $score',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Share.share(
                  widget.isFinnish
                      ? 'Suoritin kaikki tasot ristikossa! Lopulliset pisteeni: $score'
                      : 'I completed all levels in the crossword puzzle! My final score: $score',
                );
              },
              child: Text(widget.isFinnish ? 'Jaa Pisteet' : 'Share Score'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(widget.isFinnish ? 'Uusi peli' : 'New Game'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double cellSize = MediaQuery.of(context).size.width / gridSize;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isFinnish ? "Taso $currentLevel" : "Level $currentLevel"),
        backgroundColor: Colors.blue,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Score: $score',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade200, Colors.blue.shade800],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            children: [
              // Crossword grid
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: gridSize * gridSize,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridSize,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      int row = index ~/ gridSize;
                      int col = index % gridSize;
                      String? letter = grid[row][col];
                      int? number = numbers[row][col];

                      if (letter == null) {
                        return Container(); // Empty cell
                      }

                      // Highlight selected word cells
                      bool isHighlighted = false;
                      if (selectedClueIndex != null) {
                        var selectedWord = (widget.isFinnish
                                ? finnishLevels
                                : englishLevels)[currentLevel]![selectedClueIndex!];
                        int startRow = selectedWord.row;
                        int startCol = selectedWord.col;
                        String word = selectedWord.word;
                        bool isHorizontal = selectedWord.isHorizontal;

                        if (isHorizontal) {
                          isHighlighted = row == startRow &&
                              col >= startCol &&
                              col < startCol + word.length;
                        } else {
                          isHighlighted = col == startCol &&
                              row >= startRow &&
                              row < startRow + word.length;
                        }
                      }

                      return Stack(
                        children: [
                          // Cell background
                          Container(
                            margin: const EdgeInsets.all(2),
                            width: cellSize,
                            height: cellSize,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              color: isHighlighted
                                  ? Colors.yellow.shade200
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: controllers[row][col],
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(border: InputBorder.none),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              maxLength: 1,
                              buildCounter: (_, {int? currentLength, bool? isFocused, int? maxLength}) => null,
                            ),
                          ),
                          // Clue number
                          if (number != null)
                            Positioned(
                              top: 2,
                              left: 2,
                              child: Text(
                                number.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              // Clues list
              Expanded(
                child: ListView.builder(
                  itemCount: (widget.isFinnish ? finnishLevels : englishLevels)[currentLevel]!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: ListTile(
                        title: Text(
                          (widget.isFinnish ? finnishLevels : englishLevels)[currentLevel]![index].clue,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        onTap: () => _selectClue(index),
                        selected: selectedClueIndex == index,
                        selectedTileColor: Colors.lightBlue.shade100,
                      ),
                    );
                  },
                ),
              ),
              // Word input field
              if (selectedClueIndex != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: wordInputController,
                    decoration: InputDecoration(
                      labelText: 'Enter the word for the selected clue',
                      filled: true,
                      fillColor: const Color.fromARGB(255, 152, 222, 255),
                    ),
                    onChanged: _updateSelectedWord,
                  ),
                ),
              // Action buttons
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Check Answers button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      onPressed: _checkAnswers,
                      child: const Text('Check Answers'),
                    ),
                    // Hint button
                    if (showLightbulb)
                      IconButton(
                        icon: const Icon(Icons.lightbulb),
                        color: Colors.yellow,
                        iconSize: 40,
                        onPressed: _showRandomLetters,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
