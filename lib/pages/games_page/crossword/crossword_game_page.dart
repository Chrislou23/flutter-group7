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
  bool isEnglish = true;

  // Variable to hold the Future
  late Future<QuerySnapshot> _usersFuture;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Method to fetch data
  Future<void> _fetchUserData() async {
    _usersFuture = FirebaseFirestore.instance.collection('users').get();
    await _usersFuture;
    if (mounted) {
      setState(() {});
    }
  }

  void toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }

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

          // Create a list to hold user data
          List<Map<String, dynamic>> userDataList = docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final scoreCrossword = data['scoreCrossword'] ?? 0;

            return {
              'username': data['username'] ?? 'Unknown',
              'scoreCrossword': scoreCrossword,
            };
          }).toList();

          // Sort the userDataList based on 'scoreCrossword' in descending order
          userDataList.sort(
              (a, b) => b['scoreCrossword'].compareTo(a['scoreCrossword']));

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: userDataList.length,
            itemBuilder: (context, index) {
              final user = userDataList[index];
              final scoreCrossword = user['scoreCrossword'];

              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(user['username']),
                trailing: Text('Score: $scoreCrossword'),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

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
                : const Text('Crossword Game',
                    style: TextStyle(color: Colors.black)),
            centerTitle: true,
          ),
          body: timerProvider.isBlocked
              ? _buildBlockedScreen()
              : Column(
                  children: [
                    const SizedBox(height: 20),
                    // Game image
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 150,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/game1.png'),
                          fit: BoxFit.cover,
                        ),
                        color: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Ranking list
                    const Text(
                      'Crossword Game Rankings',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Expanded(child: _buildCrosswordRankingList()),
                    const SizedBox(height: 20),
                    // How to play and language toggle buttons
                    TabButtons(
                        isEnglish: isEnglish, toggleLanguage: toggleLanguage),
                    const SizedBox(height: 20),
                    // Play button placed below the other buttons
                    CustomButton(
                      text: isEnglish ? 'Play' : 'Pikapeli',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CrosswordGame(isFinnish: !isEnglish),
                          ),
                        ).then((_) => _fetchUserData());
                      },
                      textStyle: const TextStyle(fontSize: 40),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

// Widget for Tab Buttons (How to play, Language toggle)
class TabButtons extends StatelessWidget {
  final bool isEnglish;
  final VoidCallback toggleLanguage;

  const TabButtons(
      {super.key, required this.isEnglish, required this.toggleLanguage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => isEnglish
                        ? const CrosswordInstructionsEn()
                        : const CrosswordInstructionsFi(),
                  ),
                );
              },
              child: Text(isEnglish ? 'How to play' : 'Kuinka pelata',
                  style: const TextStyle(fontSize: 18)),
            ),
            const VerticalDivider(thickness: 2, color: Colors.black),
            GestureDetector(
              onTap: toggleLanguage,
              child: Text(
                isEnglish ? 'Switch to Finnish' : 'Vaihda Englantiin',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
