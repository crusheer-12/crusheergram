import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyACJJxZ4LSCw5SZdXRrqOboqmGs7vKEcaE",
      authDomain: "crusheergram.firebaseapp.com",
      projectId: "crusheergram",
      storageBucket: "crusheergram.firebasestorage.app",
      messagingSenderId: "192096010806",
      appId: "1:192096010806:web:61eeb25747f527727a4e97",
      measurementId: "G-WX4M9N0ZS7",
    ),
  );

  runApp(const CrusheergramApp());
}

class CrusheergramApp extends StatelessWidget {
  const CrusheergramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crusheergram',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF000000),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF000000),
          elevation: 0,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeScreenFeed(), 
      const ExploreScreen(), 
      const ProfileScreen(), 
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crusheergram',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontFamily: 'sans-serif-condensed',
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.favorite_border, size: 28), onPressed: () {}),
          IconButton(icon: const Icon(Icons.chat_bubble_outline, size: 26), onPressed: () {}),
        ],
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: const Color(0xFF000000),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled, size: 30), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search, size: 30), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle, size: 30), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeScreenFeed extends StatelessWidget {
  const HomeScreenFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [Colors.purple, Colors.orange, Colors.red]),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage('https://picsum.photos/id/${index + 20}/150'),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('User_${index + 1}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(color: Color(0xFF1E1E1E), height: 1),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(color: Colors.white),
                ));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Text('لا توجد منشورات حالياً في السيرفر السحابي', style: TextStyle(color: Colors.grey)),
                ));
              }

              final postDocs = snapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: postDocs.length,
                itemBuilder: (context, index) {
                  var postData = postDocs[index].data() as Map<String, dynamic>;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(backgroundImage: NetworkImage(postData["userImage"] ?? "https://picsum.photos/id/1012/150")),
                        title: Text(postData["username"] ?? "anonymous", style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.more_vert),
                      ),
                      Image.network(postData["postImage"] ?? "https://picsum.photos/id/100/600/400", fit: BoxFit.cover, width: double.infinity),
                      Row(
                        children: [
                          IconButton(icon: const Icon(Icons.favorite_border, size: 28), onPressed: () {}),
                          IconButton(icon: const Icon(Icons.mode_comment_outlined, size: 26), onPressed: () {}),
                          IconButton(icon: const Icon(Icons.send_outlined, size: 26), onPressed: () {}),
                          const Spacer(),
                          IconButton(icon: const Icon(Icons.bookmark_border, size: 28), onPressed: () {}),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 2.0),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            children: [
                              TextSpan(text: "${postData["username"]} ", style: const TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: postData["caption"] ?? ""),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search creators, tags, concepts...',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              fillColor: const Color(0xFF121212),
              filled: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            itemCount: 20,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemBuilder: (context, index) {
              return Container(
                color: const Color(0xFF1A1A1A),
                child: Image.network('https://picsum.photos/id/${index + 120}/300/300', fit: BoxFit.cover),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(radius: 45, backgroundImage: NetworkImage('https://picsum.photos/id/1012/150')),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatColumn("12", "Posts"),
                      _buildStatColumn("15.7K", "Followers"),
                      _buildStatColumn("384", "Following"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Crusheer Creator', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 4),
                Text('🛡️ Cyber Security & Python Dev\n🎬 Cinematic Aesthetics Lover\n🚀 Building Crusheergram step
