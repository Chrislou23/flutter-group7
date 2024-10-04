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
  final int gridSize = 7;
  late List<List<String?>> grid;
  late List<List<TextEditingController?>> controllers;
  late List<List<int?>> numbers;

  TextEditingController wordInputController = TextEditingController();

  final List<CrosswordWord> crosswordData = [
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
  ];

  int? selectedClueIndex;

  @override
  void initState() {
    super.initState();
    grid = List.generate(gridSize, (_) => List.filled(gridSize, null));
    controllers = List.generate(gridSize, (_) => List.filled(gridSize, null));
    numbers = List.generate(gridSize, (_) => List.filled(gridSize, null));
    _generateCrossword();
  }

  void _generateCrossword() {
    for (var wordData in crosswordData) {
      _placeWord(wordData.word, wordData.row, wordData.col,
          wordData.isHorizontal, wordData.number);
    }
  }

  void _placeWord(
      String word, int row, int col, bool isHorizontal, int number) {
    for (int i = 0; i < word.length; i++) {
      int currentRow = row + (isHorizontal ? 0 : i);
      int currentCol = col + (isHorizontal ? i : 0);

      // Vérifier les limites de la grille
      if (currentRow >= gridSize || currentCol >= gridSize) {
        return;
      }

      // Si une lettre existe déjà et est différente, ne pas placer le mot
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

    var selectedWordData = crosswordData[selectedClueIndex!];
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

  @override
  Widget build(BuildContext context) {
    double cellSize = MediaQuery.of(context).size.width / gridSize;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Custom Crossword"),
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

                  // Ne pas afficher les cases qui ne contiennent pas de lettres
                  if (letter == null) {
                    return Container(); // Retourner un conteneur vide pour les cases vides
                  }

                  bool isHighlighted = false;
                  if (selectedClueIndex != null) {
                    var selectedWord = crosswordData[selectedClueIndex!];
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
              itemCount: crosswordData.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(crosswordData[index].clue),
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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Congratulations!'),
                        content:
                            const Text('You have completed the crossword!'),
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
