import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Firebase initialization skipped for build preview");
  }
  runApp(const CrusheergramApp());
}

class CrusheergramApp extends StatelessWidget {
  const CrusheergramApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crusheergram',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.blue,
      ),
      home: const MainLayout(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// الكلاس المسؤول عن التنقل والشريط السفلي مثل إنستغرام
class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 4; // نبدأ بـ 4 ليكون الحساب الشخصي هو الافتراضي عند الفتح

  // قائمة الشاشات (حالياً نضع نصوص مؤقتة وباقي الشاشات لحين برمجتها)
  final List<Widget> _screens = [
    const Center(child: Text('Home Screen', style: TextStyle(color: Colors.white, fontSize: 24))),
    const Center(child: Text('Search Screen', style: TextStyle(color: Colors.white, fontSize: 24))),
    const Center(child: Text('Add Post Screen', style: TextStyle(color: Colors.white, fontSize: 24))),
    const Center(child: Text('Reels Screen', style: TextStyle(color: Colors.white, fontSize: 24))),
    const ProfileScreen(), // شاشتك السينمائية الفخمة
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens[_selectedIndex]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[900]!, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[600],
          showSelectedLabels: false, // إنستغرام لا يعرض نصوص أسفل الأيقونات
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled, size: 28), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search, size: 28), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined, size: 28), label: 'Add'),
            BottomNavigationBarItem(icon: Icon(Icons.slideshow_rounded, size: 28), label: 'Reels'),
            BottomNavigationBarItem(icon: Icon(Icons.person_pin, size: 28), label: 'Profile'),
          ],
        ),
      ),
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
                const CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 45, color: Colors.white),
                ),
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
                Text(
                  'Crusheer Creator',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  '🛡️ Cyber Security & Python Dev\n🎬 Cinematic Aesthetics Lover\n🚀 Building Crusheergram',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 1,
            color: Colors.grey[900],
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Icon(Icons.grid_on, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
