import 'package:flutter/material.dart';
import 'dart:math';

class CrosswordGame extends StatefulWidget {
  const CrosswordGame({Key? key}) : super(key: key);

  @override
  _CrosswordGameState createState() => _CrosswordGameState();
}

class _CrosswordGameState extends State<CrosswordGame> {
  final int gridSize = 7; // Define grid size based on the image (7x7)
  late List<List<String?>> grid; // To store letters of the crossword
  late List<List<TextEditingController?>> controllers; // For user input
  late List<List<int?>> numbers; // To store numbers indicating word positions
  late List<List<bool>>
      blockedCells; // To indicate which cells are blocked (black)

  // List of words and clues
  final List<Map<String, String>> crosswordData = [
    {'word': 'HELLO', 'clue': '1. A greeting'},
    {'word': 'TREE', 'clue': '2. A tall plant'},
    {'word': 'HOUSE', 'clue': '3. A place where people live'},
    {'word': 'DOG', 'clue': '4. A loyal pet'}
  ];

  @override
  void initState() {
    super.initState();
    grid = List.generate(gridSize, (_) => List.filled(gridSize, null));
    controllers = List.generate(gridSize, (_) => List.filled(gridSize, null));
    numbers = List.generate(gridSize, (_) => List.filled(gridSize, null));
    blockedCells = List.generate(gridSize, (_) => List.filled(gridSize, false));
    _initializeBlockedCells(); // Set up the blocked cells
    _generateCrossword(); // Generate the crossword puzzle
  }

  // Function to block cells according to the grid in the image
  void _initializeBlockedCells() {
    blockedCells[0][5] = true;
    blockedCells[0][6] = true;
    blockedCells[1][4] = true;
    blockedCells[1][6] = true;
    blockedCells[2][1] = true;
    blockedCells[2][4] = true;
    blockedCells[3][1] = true;
    blockedCells[4][1] = true;
    blockedCells[4][4] = true;
    blockedCells[5][4] = true;
    blockedCells[5][5] = true;
    blockedCells[5][6] = true;
  }

  // Function to place words into the grid
  void _generateCrossword() {
    _placeWord('HELLO', 0, 0, true, 1); // HELLO placed horizontally
    _placeWord('TREE', 2, 2, false, 2); // TREE placed vertically
    _placeWord('HOUSE', 2, 3, true, 3); // HOUSE placed horizontally
    _placeWord('DOG', 4, 3, true, 4); // DOG placed horizontally
  }

  // Function to place a word on the grid
  void _placeWord(
      String word, int row, int col, bool isHorizontal, int number) {
    for (int i = 0; i < word.length; i++) {
      if (isHorizontal) {
        if (col + i >= gridSize || blockedCells[row][col + i])
          return; // Ensure we don't go out of bounds or place on a blocked cell
        grid[row][col + i] = word[i];
        controllers[row][col + i] =
            TextEditingController(); // Create controller for input
        if (i == 0) {
          numbers[row][col + i] =
              number; // Place number at the start of the word
        }
      } else {
        if (row + i >= gridSize || blockedCells[row + i][col])
          return; // Ensure we don't go out of bounds or place on a blocked cell
        grid[row + i][col] = word[i];
        controllers[row + i][col] =
            TextEditingController(); // Create controller for input
        if (i == 0) {
          numbers[row + i][col] =
              number; // Place number at the start of the word
        }
      }
    }
  }

  // Function to check if the crossword is completed correctly
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

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Define the size of each cell based on the available screen width
    double cellSize = min(screenWidth, screenHeight) / gridSize;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Custom Crossword"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: gridSize * gridSize,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize, // 7 columns based on gridSize
                  childAspectRatio: 1, // Ensures cells are square
                ),
                itemBuilder: (BuildContext context, int index) {
                  int row = index ~/ gridSize;
                  int col = index % gridSize;
                  String? letter = grid[row][col];
                  int? number = numbers[row][col];
                  bool isBlocked =
                      blockedCells[row][col]; // Check if the cell is blocked

                  return Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(2),
                        width: cellSize, // Set dynamic cell size
                        height: cellSize, // Set dynamic cell size
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: isBlocked
                              ? Colors.black // Blocked cells are black
                              : letter != null
                                  ? Colors.white // White for active cells
                                  : Colors.grey[300], // Grey if no word
                        ),
                        child: letter != null && !isBlocked
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
                            : null, // Empty cells are grey or black
                      ),
                      if (number != null && !isBlocked)
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
                );
              },
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
