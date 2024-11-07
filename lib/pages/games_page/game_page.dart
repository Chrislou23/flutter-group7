import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:mobile_games/timer_provider.dart';
import 'package:mobile_games/pages/games_page/crossword/crossword_game_page.dart';
import 'package:mobile_games/pages/games_page/link/link_game_page.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  // Future to hold the user data from Firestore
  late Future<QuerySnapshot> _usersFuture;

  // Define colors for the top three ranks
  final Color goldColor = const Color(0xFFFFD700);
  final Color silverColor = const Color(0xFFC0C0C0);
  final Color bronzeColor = const Color(0xFFCD7F32);

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Method to fetch user data from Firestore
  Future<void> _fetchUserData() async {
    _usersFuture = FirebaseFirestore.instance.collection('users').get();
    // Wait for the future to complete before updating the state
    await _usersFuture;
    if (mounted) {
      setState(() {});
    }
  }

  // Function to get ordinal suffix for rank numbers (e.g., 1st, 2nd, 3rd)
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

  // Widget to build the overall ranking list
  Widget _buildOverallRankingList() {
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

          // Create a list to hold user data with computed total scores
          List<Map<String, dynamic>> userDataList = docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final scoreCrossword = data['scoreCrossword'] ?? 0;
            final scoreLink = data['scoreLink'] ?? 0;
            final scoreTotal = scoreCrossword + scoreLink;

            // Return a new map containing the user data and total score
            return {
              'username': data['username'] ?? 'Unknown',
              'photoURL': data['photoURL'] ?? '',
              'scoreCrossword': scoreCrossword,
              'scoreLink': scoreLink,
              'scoreTotal': scoreTotal,
            };
          }).toList();

          // Sort the userDataList based on 'scoreTotal' in descending order
          userDataList.sort((a, b) => b['scoreTotal'].compareTo(a['scoreTotal']));

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: userDataList.length,
            itemBuilder: (context, index) {
              final user = userDataList[index];
              final scoreCrossword = user['scoreCrossword'];
              final scoreLink = user['scoreLink'];
              final scoreTotal = user['scoreTotal'];
              final username = user['username'];
              final photoURL = user['photoURL'];
              final rank = index + 1;

              // Get the ordinal rank string (e.g., 1st, 2nd)
              String rankString = getOrdinalSuffix(rank);

              // Determine font size and color based on rank
              double fontSize;
              Color rankColor;

              if (rank == 1) {
                fontSize = 24.0;
                rankColor = goldColor;
              } else if (rank == 2) {
                fontSize = 22.0;
                rankColor = silverColor;
              } else if (rank == 3) {
                fontSize = 20.0;
                rankColor = bronzeColor;
              } else {
                fontSize = 18.0;
                rankColor = Colors.black;
              }

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
                              backgroundImage: photoURL.isNotEmpty
                                  ? NetworkImage(photoURL)
                                  : null,
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
                                  // Individual game scores
                                  Text('Crossword: $scoreCrossword'),
                                  Text('Link: $scoreLink'),
                                  // Total score
                                  Text(
                                    'Total: $scoreTotal',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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

  // Helper method to format duration into MM:SS format
  String _formatDuration(Duration duration) {
    String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
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

  // Widget to build the game buttons
  Widget _buildGameButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          // Crossword Game Button
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Navigate to CrosswordGamePage and refresh data upon return
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CrosswordGamePage(),
                  ),
                ).then((_) => _fetchUserData());
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4,
                child: Column(
                  children: [
                    // Game image
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/game1.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12.0),
                        ),
                      ),
                    ),
                    // Game title
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Game 1: Crossword',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Link Game Button
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Navigate to LinkGamePage and refresh data upon return
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LinkGamePage(),
                  ),
                ).then((_) => _fetchUserData());
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4,
                child: Column(
                  children: [
                    // Game image
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/game2.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12.0),
                        ),
                      ),
                    ),
                    // Game title
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Game 2: Link Game',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, timerProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: timerProvider.isBlocked
                ? Text(
                    "Blocked: ${_formatDuration(timerProvider.remainingBlockTime)}",
                  )
                : const Text('Games'),
            centerTitle: true,
          ),
          body: timerProvider.isBlocked
              ? _buildBlockedScreen()
              : Column(
                  children: [
                    const SizedBox(height: 10),
                    // Display game buttons
                    _buildGameButtons(),
                    const SizedBox(height: 10),
                    // Leaderboard title
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Leaderboard',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Display the overall ranking list
                    Expanded(child: _buildOverallRankingList()),
                  ],
                ),
        );
      },
    );
  }
}
