import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Firebase preview mode active");
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
      // التطبيق يبدأ أولاً بشاشة تسجيل الدخول الاحترافية
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ==========================================
// 1. شاشة تسجيل الدخول (Login Screen)
// ==========================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleLogin() {
    // انتقال مباشر عند الضغط على زر تسجيل الدخول
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainLayout()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            const Center(
              child: Text(
                'Crusheergram',
                style: TextStyle(
                  fontFamily: 'Billabong', // أو استخدام ستايل فخم شبيه بإنستغرام
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'Phone number, username, or email',
                fillColor: Colors.grey[900],
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                fillColor: Colors.grey[900],
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Log In', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            const Spacer(),
            const Divider(color: Colors.grey),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? ", style: TextStyle(color: Colors.grey)),
                TextButton(
                  onPressed: _handleLogin,
                  child: const Text('Sign up.', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. الهيكل الرئيسي وشريط التنقل السفلي (Main Layout)
// ==========================================
class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 4; // يفتح افتراضياً على البروفايل لتشاهد عملك

  // التحكم التفاعلي بالصور والبروفايل داخل التطبيق محلياً
  String _profileImage = 'https://picsum.photos/id/1012/200/200';
  final List<String> _posts = List.generate(12, (index) => 'https://picsum.photos/id/${index + 120}/300/300');

  void _changeProfileImage() {
    // تغيير صورة البروفايل ديناميكياً بصورة سينمائية عشوائية محاكاة للرفع
    setState(() {
      _profileImage = 'https://picsum.photos/id/${DateTime.now().second + 50}/200/200';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile picture updated!')),
    );
  }

  void _addNewPost() {
    setState(() {
      _posts.insert(0, 'https://picsum.photos/id/${DateTime.now().second + 150}/300/300');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New cinematic post uploaded successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // تحديث الشاشات بالبيانات الديناميكية
    final List<Widget> screens = [
      const HomeScreen(),
      const SearchScreen(),
      AddPostScreen(onAdd: _addNewPost),
      const ReelsScreen(),
      ProfileScreen(profileImage: _profileImage, posts: _posts, onChangeAvatar: _changeProfileImage),
    ];

    return Scaffold(
      body: SafeArea(child: screens[_selectedIndex]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey[900]!, width: 0.5))),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[600],
          showSelectedLabels: false,
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

// ==========================================
// 3. الشاشات الجانبية والأساسية
// ==========================================

// شاشة الصفحة الرئيسية (Home Feed)
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Crusheergram', style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
          IconButton(icon: const Icon(Icons.chat_bubble_outline), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const CircleAvatar(backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white)),
                title: Text('User_${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.more_vert),
              ),
              Image.network('https://picsum.photos/id/${index + 130}/400/400', fit: BoxFit.cover, width: double.infinity, height: 350),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.comment_outlined), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.send_outlined), onPressed: () {}),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// شاشة البحث (Search Screen)
class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: 'Search creators, aesthetics...',
                fillColor: Colors.grey[900],
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
              itemCount: 15,
              itemBuilder: (context, index) => Image.network('https://picsum.photos/id/${index + 40}/200/200', fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}

// شاشة إضافة منشور (Add Post Simulator)
class AddPostScreen extends StatelessWidget {
  final VoidCallback onAdd;
  const AddPostScreen({Key? key, presidential, required this.onAdd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_upload_outlined, size: 100, color: Colors.grey),
            const SizedBox(height: 20),
            const Text('Upload Cinematic Concept', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: onAdd,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Simulate Camera Upload', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// شاشة الريلز (Reels Screen)
class ReelsScreen extends StatelessWidget {
  const ReelsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(color: Colors.grey[950], child: const Center(child: Icon(Icons.play_circle_fill, size: 60, color: Colors.white30))),
              Positioned(
                bottom: 20,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('cinematic_reel_${index + 1}.mp4', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 6),
                    const Text('Original Audio - Crusheer Studios ✨', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// شاشة الملف الشخصي المتكاملة والمحدثة (Profile Screen)
class ProfileScreen extends StatelessWidget {
  final String profileImage;
  final List<String> posts;
  final VoidCallback onChangeAvatar;

  const ProfileScreen({
    Key? key,
    required this.profileImage,
    required this.posts,
    required this.onChangeAvatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('crusheer-12', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.add_box_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onChangeAvatar, // ضغطة واحدة لتغيير صورة البروفايل فوراً!
                    child: Stack(
                      children: [
                        CircleAvatar(radius: 45, backgroundImage: NetworkImage(profileImage)),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(radius: 14, backgroundColor: Colors.blue, child: const Icon(Icons.add, size: 16, color: Colors.white)),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn("${posts.length}", "Posts"),
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
                  Text('🛡️ Cyber Security & Python Dev\n🎬 Cinematic Aesthetics Lover\n🚀 Building Crusheergram'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: OutlinedButton(
                      onPressed: onChangeAvatar,
                      style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.grey[800]!)),
                      child: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Divider(color: Colors.grey[900], thickness: 1),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Center(child: Icon(Icons.grid_on, size: 26)),
            ),
            // شبكة المنشورات أصبحت حركية وممتدة وتسمح بالتمرير (Scroll) والتحرك!
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Image.network(posts[index], fit: BoxFit.cover);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
