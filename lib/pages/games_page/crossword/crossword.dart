import 'package:flutter/material.dart';
import 'dart:math';

class CrosswordGame extends StatefulWidget {
  const CrosswordGame({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CrosswordGameState createState() => _CrosswordGameState();
}

class _CrosswordGameState extends State<CrosswordGame> {
  final int gridSize = 7;
  late List<List<String?>> grid;
  late List<List<TextEditingController?>> controllers;
  late List<List<int?>> numbers;

  final List<Map<String, String>> crosswordData = [
    {'word': 'HELLO', 'clue': '1. A greeting'},
    {'word': 'TREE', 'clue': '2. A tall plant'},
    {'word': 'HOUSE', 'clue': '3. A place where people live'},
    {'word': 'DOG', 'clue': '4. A loyal pet'}
  ];

  int? selectedClueIndex; // Store the index of the selected word

  @override
  void initState() {
    super.initState();
    grid = List.generate(gridSize, (_) => List.filled(gridSize, null));
    controllers = List.generate(gridSize, (_) => List.filled(gridSize, null));
    numbers = List.generate(gridSize, (_) => List.filled(gridSize, null));
    _generateCrossword();
  }

  void _generateCrossword() {
    _placeWord('HELLO', 0, 0, true, 1);
    _placeWord('TREE', 2, 2, false, 2);
    _placeWord('HOUSE', 2, 2, true, 3);
    _placeWord('DOG', 4, 2, true, 4);
  }

  void _placeWord(
      String word, int row, int col, bool isHorizontal, int number) {
    for (int i = 0; i < word.length; i++) {
      int currentRow = row + (isHorizontal ? 0 : i);
      int currentCol = col + (isHorizontal ? i : 0);

      // If there's already a letter, check if it matches the one we're placing
      if (grid[currentRow][currentCol] != null &&
          grid[currentRow][currentCol] != word[i]) {
        return; // Conflict found, don't place this word
      }

      grid[currentRow][currentCol] = word[i];
      controllers[currentRow][currentCol] = TextEditingController();
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

  // Handle clue selection
  void _selectClue(int index) {
    setState(() {
      selectedClueIndex = index;
    });
  }

  // Function to update the grid based on user input in the selected word field
  void _updateSelectedWord(String input) {
    if (selectedClueIndex == null) return;

    String word = crosswordData[selectedClueIndex!]['word']!;
    int row, col;
    bool isHorizontal;

    // Positions based on where the words are placed
    if (selectedClueIndex == 0) {
      row = 0;
      col = 0;
      isHorizontal = true;
    } else if (selectedClueIndex == 1) {
      row = 2;
      col = 2;
      isHorizontal = false;
    } else if (selectedClueIndex == 2) {
      row = 2;
      col = 2;
      isHorizontal = true;
    } else if (selectedClueIndex == 3) {
      row = 4;
      col = 2;
      isHorizontal = true;
    } else {
      return;
    }

    for (int i = 0; i < word.length && i < input.length; i++) {
      if (isHorizontal) {
        controllers[row][col + i]?.text = input[i].toUpperCase();
      } else {
        controllers[row + i][col]?.text = input[i].toUpperCase();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double cellSize = min(screenWidth, screenHeight) / gridSize;

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

                  bool isHighlighted = false;
                  if (selectedClueIndex != null) {
                    String word = crosswordData[selectedClueIndex!]['word']!;
                    int startRow, startCol;
                    bool horizontal;

                    // Highlighting based on the selected word's position
                    if (selectedClueIndex == 0) {
                      startRow = 0;
                      startCol = 0;
                      horizontal = true;
                    } else if (selectedClueIndex == 1) {
                      startRow = 2;
                      startCol = 2;
                      horizontal = false;
                    } else if (selectedClueIndex == 2) {
                      startRow = 2;
                      startCol = 2;
                      horizontal = true;
                    } else if (selectedClueIndex == 3) {
                      startRow = 4;
                      startCol = 2;
                      horizontal = true;
                    } else {
                      return Container();
                    }

                    if (horizontal) {
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
                          color: isHighlighted
                              ? Colors.yellow
                              : letter != null
                                  ? Colors.white
                                  : Colors.grey[300],
                        ),
                        child: letter != null
                            ? TextField(
                                controller: controllers[row][col],
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                                style: const TextStyle(fontSize: 20),
                                maxLength: 1,
                                buildCounter: (_,
                                        {int? currentLength,
                                        bool? isFocused,
                                        int? maxLength}) =>
                                    null,
                              )
                            : null,
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
                  title: Text(crosswordData[index]['clue']!),
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
