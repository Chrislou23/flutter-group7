import 'package:flutter/material.dart';

class CrosswordGame extends StatefulWidget {
  final bool isFinnish;

  const CrosswordGame({super.key, required this.isFinnish});

  @override
  // ignore: library_private_types_in_public_api
  _CrosswordGameState createState() => _CrosswordGameState();
}

class CrosswordWord {
  String word;
  String clue;
  int row;
  int col;
  bool isHorizontal;
  int number;
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
  late int gridSize;
  late List<List<String?>> grid;
  late List<List<TextEditingController?>> controllers;
  late List<List<int?>> numbers;

  int currentLevel = 1;
  int maxLevel = 5;

  TextEditingController wordInputController = TextEditingController();

  final Map<int, List<CrosswordWord>> finnishLevels = {
    1: [
      CrosswordWord(
          word: 'ILO',
          clue: '1. Ilo - Joy',
          row: 4,
          col: 0,
          isHorizontal: true,
          number: 1),
      CrosswordWord(
          word: 'SURU',
          clue: '2. Suru - Sadness',
          row: 3,
          col: 0,
          isHorizontal: false,
          number: 2),
      CrosswordWord(
          word: 'PELKO',
          clue: '3. Pelko - Fear',
          row: 0,
          col: 4,
          isHorizontal: false,
          number: 3),
      CrosswordWord(
          word: 'RIEMU',
          clue: '4. Riemu - Delight',
          row: 0,
          col: 5,
          isHorizontal: false,
          number: 4),
      CrosswordWord(
          word: 'VIHA',
          clue: '5. Viha - Anger',
          row: 1,
          col: 3,
          isHorizontal: false,
          number: 5),
    ],
    // Additional levels are truncated for brevity
  };

  final Map<int, List<CrosswordWord>> englishLevels = {
    1: [
      CrosswordWord(
          word: 'JOY',
          clue: '1. Joy',
          row: 4,
          col: 0,
          isHorizontal: true,
          number: 1),
      CrosswordWord(
          word: 'SADNESS',
          clue: '2. Sadness',
          row: 3,
          col: 0,
          isHorizontal: false,
          number: 2),
      CrosswordWord(
          word: 'FEAR',
          clue: '3. Fear',
          row: 0,
          col: 4,
          isHorizontal: false,
          number: 3),
      CrosswordWord(
          word: 'DELIGHT',
          clue: '4. Delight',
          row: 0,
          col: 5,
          isHorizontal: false,
          number: 4),
      CrosswordWord(
          word: 'ANGER',
          clue: '5. Anger',
          row: 1,
          col: 3,
          isHorizontal: false,
          number: 5),
    ],
    // Additional levels are truncated for brevity
  };

  int? selectedClueIndex;

  @override
  void initState() {
    super.initState();
    _generateCrossword();
  }

  void initializeGrid() {
    grid = List.generate(gridSize, (_) => List.filled(gridSize, null));
    controllers = List.generate(gridSize, (_) => List.filled(gridSize, null));
    numbers = List.generate(gridSize, (_) => List.filled(gridSize, null));
  }

  void _generateCrossword() {
    // Choose levels based on language
    final levels = widget.isFinnish ? finnishLevels : englishLevels;

    // Determine the grid size based on the longest word in the current level
    int longestWordLength = levels[currentLevel]!
        .map((word) => word.word.length)
        .reduce((a, b) => a > b ? a : b);
    gridSize = longestWordLength > 7 ? longestWordLength + 2 : 7;

    initializeGrid();
    List<CrosswordWord> crosswordData = levels[currentLevel] ?? [];
    for (var wordData in crosswordData) {
      _placeWord(wordData.word, wordData.row, wordData.col,
          wordData.isHorizontal, wordData.number);
    }
    setState(() {});
  }

  void _placeWord(
      String word, int row, int col, bool isHorizontal, int number) {
    // First check if the word can be placed without conflicts
    for (int i = 0; i < word.length; i++) {
      int currentRow = row + (isHorizontal ? 0 : i);
      int currentCol = col + (isHorizontal ? i : 0);

      // Check grid limits
      if (currentRow >= gridSize || currentCol >= gridSize) {
        return; // Word doesn't fit within the grid bounds
      }

      // If a letter exists but is different, don’t place the word
      if (grid[currentRow][currentCol] != null &&
          grid[currentRow][currentCol] != word[i]) {
        return; // Word conflicts with another already placed word
      }
    }

    // Place the word in the grid if all checks pass
    for (int i = 0; i < word.length; i++) {
      int currentRow = row + (isHorizontal ? 0 : i);
      int currentCol = col + (isHorizontal ? i : 0);

      grid[currentRow][currentCol] = word[i];
      controllers[currentRow][currentCol] ??= TextEditingController();
      if (i == 0) {
        numbers[currentRow][currentCol] = number;
      }
    }
  }

  bool _isCrosswordCompleted() {
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (grid[row][col] != null &&
            controllers[row][col]?.text.toUpperCase() != grid[row][col]) {
          return false;
        }
      }
    }
    return true;
  }

  void _selectClue(int index) {
    setState(() {
      selectedClueIndex = index;
      wordInputController.clear();
    });
  }

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

      if (currentRow >= gridSize || currentCol >= gridSize) {
        continue;
      }

      controllers[currentRow][currentCol]?.text = input[i].toUpperCase();
    }
  }

  void _moveToNextLevel() {
    if (currentLevel < maxLevel) {
      setState(() {
        currentLevel++;
        _generateCrossword();
      });
    }
  }

  void _showAnswers() {
    final levels = widget.isFinnish ? finnishLevels : englishLevels;
    List<CrosswordWord> crosswordData = levels[currentLevel] ?? [];
    for (var wordData in crosswordData) {
      for (int i = 0; i < wordData.word.length; i++) {
        int currentRow = wordData.row + (wordData.isHorizontal ? 0 : i);
        int currentCol = wordData.col + (wordData.isHorizontal ? i : 0);

        if (currentRow < gridSize && currentCol < gridSize) {
          controllers[currentRow][currentCol]?.text =
              wordData.word[i].toUpperCase();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double cellSize = MediaQuery.of(context).size.width / gridSize;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isFinnish
            ? "Finnish Crossword Game - Level $currentLevel"
            : "English Crossword Game - Level $currentLevel"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          SizedBox(
            height: cellSize * gridSize,
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
                    return Container(
                      margin: const EdgeInsets.all(2),
                      width: cellSize,
                      height: cellSize,
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                    );
                  }

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
                      Container(
                        margin: const EdgeInsets.all(2),
                        width: cellSize,
                        height: cellSize,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          color: isHighlighted
                              ? Colors.yellow
                              : Colors.lightGreenAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: controllers[row][col],
                          textAlign: TextAlign.center,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          maxLength: 1,
                          buildCounter: (_,
                                  {int? currentLength,
                                  bool? isFocused,
                                  int? maxLength}) =>
                              null,
                        ),
                      ),
                      if (number != null)
                        Positioned(
                          top: 2,
                          left: 2,
                          child: Text(
                            number.toString(),
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: (widget.isFinnish
                      ? finnishLevels
                      : englishLevels)[currentLevel]!
                  .length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Colors.lightBlue.shade100,
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    title: Text(
                      (widget.isFinnish
                              ? finnishLevels
                              : englishLevels)[currentLevel]![index]
                          .clue,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onTap: () => _selectClue(index),
                    selected: selectedClueIndex == index,
                    selectedTileColor: Colors.yellow.shade100,
                  ),
                );
              },
            ),
          ),
          if (selectedClueIndex != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: wordInputController,
                decoration: const InputDecoration(
                  labelText: 'Enter the word for the selected clue',
                  border: OutlineInputBorder(),
                ),
                onChanged: _updateSelectedWord,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    if (_isCrosswordCompleted()) {
                      if (currentLevel < maxLevel) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Level Complete!'),
                              content:
                                  const Text('You have completed this level.'),
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Congratulations!'),
                              content:
                                  const Text('You have completed all levels!'),
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
                    } else {
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
                  },
                  child: const Text('Check Answers'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _showAnswers,
                  child: const Text('Show Answers'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
