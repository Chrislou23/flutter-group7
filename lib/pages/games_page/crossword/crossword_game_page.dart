import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_games/timer_provider.dart';
import 'package:mobile_games/pages/games_page/crossword/crossword_game.dart';
import 'package:mobile_games/pages/games_page/crossword/Instructions/crossword_instructions_en.dart';
import 'package:mobile_games/pages/games_page/crossword/Instructions/crossword_instructions_fi.dart';
import 'package:mobile_games/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrosswordGamePage extends StatefulWidget {
  const CrosswordGamePage({super.key});

  @override
  _CrosswordGamePageState createState() => _CrosswordGamePageState();
}

class _CrosswordGamePageState extends State<CrosswordGamePage> {
  // Flag to track the selected language (English by default)
  bool isEnglish = true;

  // Future to hold user data from Firestore
  late Future<QuerySnapshot> _usersFuture;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Method to fetch user data from Firestore
  Future<void> _fetchUserData() async {
    _usersFuture = FirebaseFirestore.instance.collection('users').get();
    await _usersFuture;
    if (mounted) {
      setState(() {});
    }
  }

  // Toggle between English and Finnish languages
  void toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }

  // Build the ranking list for the crossword game
  Widget _buildCrosswordRankingList() {
    return RefreshIndicator(
      onRefresh: _fetchUserData,
      child: FutureBuilder<QuerySnapshot>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          // List to hold user data
          List<Map<String, dynamic>> userDataList = docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final scoreCrossword = data['scoreCrossword'] ?? 0;

            return {
              'username': data['username'] ?? 'Unknown',
              'photoURL': data['photoURL'] ?? '',
              'scoreCrossword': scoreCrossword,
            };
          }).toList();

          // Sort the list based on crossword scores in descending order
          userDataList.sort((a, b) => b['scoreCrossword'].compareTo(a['scoreCrossword']));

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: userDataList.length,
            itemBuilder: (context, index) {
              final user = userDataList[index];
              final scoreCrossword = user['scoreCrossword'];
              final username = user['username'];
              final photoURL = user['photoURL'];
              final rank = index + 1;

              // Determine styling based on rank
              double fontSize;
              Color rankColor;

              if (rank == 1) {
                fontSize = 24.0;
                rankColor = const Color(0xFFFFD700); // Gold
              } else if (rank == 2) {
                fontSize = 22.0;
                rankColor = const Color(0xFFC0C0C0); // Silver
              } else if (rank == 3) {
                fontSize = 20.0;
                rankColor = const Color(0xFFCD7F32); // Bronze
              } else {
                fontSize = 18.0;
                rankColor = Colors.black;
              }

              // Get the ordinal rank string (e.g., 1st, 2nd)
              String rankString = getOrdinalSuffix(rank);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      // Rank display
                      Container(
                        width: 60,
                        alignment: Alignment.center,
                        child: Text(
                          rankString,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize,
                            color: rankColor,
                          ),
                        ),
                      ),
                      // Vertical divider
                      Container(
                        height: 60,
                        width: 1,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(width: 12.0),
                      // User information
                      Expanded(
                        child: Row(
                          children: [
                            // User avatar
                            CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  photoURL.isNotEmpty ? NetworkImage(photoURL) : null,
                              child: photoURL.isEmpty
                                  ? const Icon(
                                      Icons.person,
                                      size: 30.0,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12.0),
                            // User details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Username
                                  Text(
                                    username,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  // User score
                                  Text(
                                    'Score: $scoreCrossword',
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                ],
                              ),
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
        },
      ),
    );
  }

  // Function to get ordinal suffix for rank numbers (e.g., 1st, 2nd)
  String getOrdinalSuffix(int number) {
    if (number >= 11 && number <= 13) {
      return '${number}th';
    }
    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }

  // Format duration into MM:SS format
  String _formatDuration(Duration duration) {
    String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  // Widget to display when the user is blocked
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

  // Widget to display the game image
  Widget _buildGameImage() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 150,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/game1.png'),
          fit: BoxFit.cover,
        ),
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }

  // Widget to display the header title
  Widget _buildHeaderTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        isEnglish ? 'Crossword Game Rankings' : 'Ristikko Pelin Tulokset',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  // Widget for the play button
  Widget _buildPlayButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CrosswordGame(isFinnish: !isEnglish),
            ),
          ).then((_) => _fetchUserData());
        },
        child: Text(
          isEnglish ? 'Play' : 'Pelaa',
          style: const TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, timerProvider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: timerProvider.isBlocked
                ? Text(
                    "Blocked: ${_formatDuration(timerProvider.remainingBlockTime)}",
                    style: const TextStyle(color: Colors.black),
                  )
                : const Text(
                    'Crossword Game',
                    style: TextStyle(color: Colors.black),
                  ),
            centerTitle: true,
          ),
          body: timerProvider.isBlocked
              ? _buildBlockedScreen()
              : Column(
                  children: [
                    const SizedBox(height: 10),
                    _buildGameImage(),
                    const SizedBox(height: 10),
                    _buildHeaderTitle(),
                    const SizedBox(height: 10),
                    // Ranking list
                    Expanded(child: _buildCrosswordRankingList()),
                    const SizedBox(height: 10),
                    // Buttons for instructions and language toggle
                    TabButtons(
                      isEnglish: isEnglish,
                      toggleLanguage: toggleLanguage,
                    ),
                    const SizedBox(height: 10),
                    _buildPlayButton(),
                    const SizedBox(height: 10),
                  ],
                ),
        );
      },
    );
  }
}

// Widget for Tab Buttons (How to Play, Language Toggle)
class TabButtons extends StatelessWidget {
  final bool isEnglish;
  final VoidCallback toggleLanguage;

  const TabButtons({
    super.key,
    required this.isEnglish,
    required this.toggleLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // How to Play Button
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => isEnglish
                        ? const CrosswordInstructionsEn()
                        : const CrosswordInstructionsFi(),
                  ),
                );
              },
              icon: const Icon(Icons.help_outline),
              label: Text(
                isEnglish ? 'How to Play' : 'Kuinka Pelata',
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          // Language Toggle Button
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: toggleLanguage,
              icon: const Icon(Icons.language),
              label: Text(
                isEnglish ? 'Switch to Finnish' : 'Vaihda Englantiin',
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
