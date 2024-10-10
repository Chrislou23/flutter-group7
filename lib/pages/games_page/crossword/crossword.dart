import 'package:flutter/material.dart';

class CrosswordGame extends StatefulWidget {
  const CrosswordGame({super.key});

  @override
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
  int gridSize = 7;
  late List<List<String?>> grid;
  late List<List<TextEditingController?>> controllers;
  late List<List<int?>> numbers;

  int currentLevel = 1;
  int maxLevel = 5;

  TextEditingController wordInputController = TextEditingController();

  final Map<int, List<CrosswordWord>> levels = {
    1: [
      CrosswordWord(
          word: 'APPLE',
          clue: '1. A red or green fruit',
          row: 1,
          col: 0,
          isHorizontal: true,
          number: 1),
      CrosswordWord(
          word: 'WATER',
          clue: '2. Something you drink',
          row: 0,
          col: 0,
          isHorizontal: false,
          number: 2),
      CrosswordWord(
          word: 'LEAF',
          clue: '3. Part of a tree that turns green in spring',
          row: 4,
          col: 3,
          isHorizontal: true,
          number: 3),
      CrosswordWord(
          word: 'BOOK',
          clue: '4. Something you read',
          row: 3,
          col: 5,
          isHorizontal: false,
          number: 4),
      CrosswordWord(
          word: 'FISH',
          clue: '5. Lives in water',
          row: 1,
          col: 4,
          isHorizontal: true,
          number: 5),
      CrosswordWord(
          word: 'FIRE',
          clue: '6. Hot and burns',
          row: 5,
          col: 2,
          isHorizontal: true,
          number: 6),
    ],
    2: [
      CrosswordWord(
          word: 'HELLO',
          clue: '1. A greeting',
          row: 1,
          col: 2,
          isHorizontal: true,
          number: 1),
      CrosswordWord(
          word: 'HOUSE',
          clue: '2. A place where people live',
          row: 1,
          col: 2,
          isHorizontal: false,
          number: 2),
      CrosswordWord(
          word: 'TREE',
          clue: '3. A tall plant',
          row: 5,
          col: 0,
          isHorizontal: true,
          number: 3),
      CrosswordWord(
          word: 'DOG',
          clue: '4. A loyal pet',
          row: 0,
          col: 6,
          isHorizontal: false,
          number: 4),
      CrosswordWord(
          word: 'PLANT',
          clue: '5. A living thing that grows on earth',
          row: 1,
          col: 0,
          isHorizontal: false,
          number: 5),
    ],
    3: [
      CrosswordWord(
          word: 'ELEPHANT',
          clue: '1. A large animal with a trunk',
          row: 0,
          col: 0,
          isHorizontal: true,
          number: 1),
      CrosswordWord(
          word: 'ORANGE',
          clue: '2. A citrus fruit',
          row: 1,
          col: 2,
          isHorizontal: false,
          number: 2),
      CrosswordWord(
          word: 'GRASS',
          clue: '3. Green plant covering the ground',
          row: 6,
          col: 4,
          isHorizontal: true,
          number: 3),
      CrosswordWord(
          word: 'LION',
          clue: '4. King of the jungle',
          row: 3,
          col: 1,
          isHorizontal: true,
          number: 4),
      CrosswordWord(
          word: 'RAIN',
          clue: '5. Falls from the sky',
          row: 0,
          col: 5,
          isHorizontal: false,
          number: 5),
      CrosswordWord(
          word: 'SHIP',
          clue: '6. Sails on the sea',
          row: 2,
          col: 6,
          isHorizontal: false,
          number: 6),
      CrosswordWord(
          word: 'CLOCK',
          clue: '7. Tells time',
          row: 5,
          col: 0,
          isHorizontal: true,
          number: 7),
    ],
    4: [
      CrosswordWord(
          word: 'DINOSAUR',
          clue: '1. A large extinct reptile',
          row: 1,
          col: 0,
          isHorizontal: true,
          number: 1),
      CrosswordWord(
          word: 'PYTHON',
          clue: '2. A large snake or programming language',
          row: 3,
          col: 1,
          isHorizontal: false,
          number: 2),
      CrosswordWord(
          word: 'OCEAN',
          clue: '3. A large body of water',
          row: 5,
          col: 3,
          isHorizontal: true,
          number: 3),
      CrosswordWord(
          word: 'BRIDGE',
          clue: '4. Structure that spans a river',
          row: 0,
          col: 4,
          isHorizontal: false,
          number: 4),
      CrosswordWord(
          word: 'PLANET',
          clue: '5. Earth is one',
          row: 2,
          col: 3,
          isHorizontal: true,
          number: 5),
      CrosswordWord(
          word: 'MUSIC',
          clue: '6. Sound created by instruments',
          row: 6,
          col: 0,
          isHorizontal: true,
          number: 6),
      CrosswordWord(
          word: 'STORM',
          clue: '7. Violent weather with wind and rain',
          row: 4,
          col: 2,
          isHorizontal: false,
          number: 7),
      CrosswordWord(
          word: 'TRAIN',
          clue: '8. Runs on tracks',
          row: 0,
          col: 0,
          isHorizontal: false,
          number: 8),
    ],
    5: [
      CrosswordWord(
          word: 'CHAMELEON',
          clue: '1. A lizard known for changing colors',
          row: 0,
          col: 0,
          isHorizontal: true,
          number: 1),
      CrosswordWord(
          word: 'HIPPOPOTAMUS',
          clue: '2. A large river-dwelling mammal',
          row: 2,
          col: 3,
          isHorizontal: false,
          number: 2),
      CrosswordWord(
          word: 'MOUNTAIN',
          clue: '3. A large natural elevation of the earth’s surface',
          row: 5,
          col: 5,
          isHorizontal: true,
          number: 3),
      CrosswordWord(
          word: 'BICYCLE',
          clue: '4. A vehicle with two wheels',
          row: 1,
          col: 1,
          isHorizontal: true,
          number: 4),
      CrosswordWord(
          word: 'ASTRONAUT',
          clue: '5. A person who travels in space',
          row: 4,
          col: 0,
          isHorizontal: false,
          number: 5),
      CrosswordWord(
          word: 'VOLCANO',
          clue: '6. A mountain that erupts with lava',
          row: 6,
          col: 2,
          isHorizontal: true,
          number: 6),
      CrosswordWord(
          word: 'FOREST',
          clue: '7. A large area covered chiefly with trees',
          row: 0,
          col: 6,
          isHorizontal: false,
          number: 7),
      CrosswordWord(
          word: 'AIRPLANE',
          clue: '8. Flies in the sky',
          row: 2,
          col: 0,
          isHorizontal: false,
          number: 8),
      CrosswordWord(
          word: 'CAMEL',
          clue: '9. Animal with humps',
          row: 3,
          col: 5,
          isHorizontal: true,
          number: 9),
      CrosswordWord(
          word: 'COMPUTER',
          clue: '10. A machine for calculations or browsing the internet',
          row: 5,
          col: 0,
          isHorizontal: true,
          number: 10),
    ],
  };

  int? selectedClueIndex;

  @override
  void initState() {
    super.initState();
    initializeGrid();
    _generateCrossword();
  }

  void initializeGrid() {
    grid = List.generate(gridSize, (_) => List.filled(gridSize, null));
    controllers = List.generate(gridSize, (_) => List.filled(gridSize, null));
    numbers = List.generate(gridSize, (_) => List.filled(gridSize, null));
  }

  void _generateCrossword() {
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
    for (int i = 0; i < word.length; i++) {
      int currentRow = row + (isHorizontal ? 0 : i);
      int currentCol = col + (isHorizontal ? i : 0);

      // Check grid limits
      if (currentRow >= gridSize || currentCol >= gridSize) {
        return;
      }

      // If a letter exists but is different, don’t place the word
      if (grid[currentRow][currentCol] != null &&
          grid[currentRow][currentCol] != word[i]) {
        return;
      }

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

  @override
  Widget build(BuildContext context) {
    double cellSize = MediaQuery.of(context).size.width / gridSize;

    return Scaffold(
      appBar: AppBar(
        title: Text("Crossword Game - Level $currentLevel"),
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
                    return Container();
                  }

                  bool isHighlighted = false;
                  if (selectedClueIndex != null) {
                    var selectedWord =
                        levels[currentLevel]![selectedClueIndex!];
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
                          border: Border.all(color: Colors.black),
                          color: isHighlighted ? Colors.yellow : Colors.white,
                        ),
                        child: TextField(
                          controller: controllers[row][col],
                          textAlign: TextAlign.center,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          style: const TextStyle(fontSize: 20),
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
                                fontSize: 12, fontWeight: FontWeight.bold),
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
              itemCount: levels[currentLevel]!.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(levels[currentLevel]![index].clue),
                  onTap: () => _selectClue(index),
                  selected: selectedClueIndex == index,
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
            child: ElevatedButton(
              onPressed: () {
                if (_isCrosswordCompleted()) {
                  if (currentLevel < maxLevel) {
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Congratulations!'),
                          content: const Text('You have completed all levels!'),
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
          ),
        ],
      ),
    );
  }
}
