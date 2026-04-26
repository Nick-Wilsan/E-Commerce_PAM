import 'package:flutter/material.dart';

void main() {
  runApp(const MahasiswaApp());
}

class MahasiswaApp extends StatelessWidget {
  const MahasiswaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portal Mahasiswa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
        ),
      ),
      home: const StudentListScreen(),
    );
  }
}

// ==========================================
// DATA MODEL & MOCK DATA
// ==========================================
class Student {
  final String name;
  final String nim;
  final String university;
  final String faculty;
  final String major;
  final List<String> schedule;
  final Map<String, String> grades;

  Student({
    required this.name,
    required this.nim,
    required this.university,
    required this.faculty,
    required this.major,
    required this.schedule,
    required this.grades,
  });
}

final List<Student> dummyStudents = [
  Student(
    name: 'Nick Wilsan',
    nim: '245150400111044',
    university: 'Universitas Brawijaya',
    faculty: 'Fakultas Ilmu Komputer',
    major: 'Sistem Informasi',
    schedule: [
      'Senin, 08:00 - Desain UI/UX',
      'Selasa, 10:00 - Pemrograman Java',
      'Rabu, 13:00 - Basis Data Lanjut',
      'Kamis, 09:00 - Rekayasa Perangkat Lunak',
    ],
    grades: {
      'Algoritma & Struktur Data': 'A',
      'Pemrograman Dasar': 'A',
      'Matematika Diskrit': 'B+',
      'Pengantar Sistem Informasi': 'A',
    },
  ),
  Student(
    name: 'Andien Oktriarahmah Syarifah',
    nim: '245150400111045',
    university: 'Universitas Brawijaya',
    faculty: 'Fakultas Ilmu Komputer',
    major: 'Sistem Informasi',
    schedule: [
      'Senin, 08:00 - Desain UI/UX',
      'Rabu, 09:00 - Manajemen Proyek IT',
      'Jumat, 13:00 - Etika Profesi',
    ],
    grades: {
      'Algoritma & Struktur Data': 'A',
      'Pemrograman Dasar': 'B+',
      'Kalkulus': 'A',
    },
  ),
];

// ==========================================
// 1. HALAMAN DAFTAR MAHASISWA (LISTVIEW)
// ==========================================
class StudentListScreen extends StatelessWidget {
  const StudentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Mahasiswa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      // Menggunakan ListView.builder untuk efisiensi memori & kelancaran scrolling
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: dummyStudents.length,
        itemBuilder: (context, index) {
          final student = dummyStudents[index];
          // Tantangan Bonus: Custom List Item
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              // Interaksi tap dari list ke detail
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentDetailScreen(student: student),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue[100],
                      child: Text(
                        student.name.substring(0, 1),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            student.nim,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            student.major,
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// 2. HALAMAN DETAIL MAHASISWA (PAGEVIEW)
// ==========================================
class StudentDetailScreen extends StatefulWidget {
  final Student student;

  const StudentDetailScreen({super.key, required this.student});

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Detail Mahasiswa'), elevation: 0),
      body: Column(
        children: [
          // Tantangan Bonus: Custom Page Indicator
          _buildPageIndicator(),

          Expanded(
            // Kelancaran swipe dijamin oleh widget PageView bawaan Flutter
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                // 3 Halaman Detail
                _ProfileView(student: widget.student),
                _ScheduleView(schedule: widget.student.schedule),
                _GradesView(grades: widget.student.grades),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk membuat indikator halaman titik-titik (Dots Indicator)
  Widget _buildPageIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      color: Colors.grey[50],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            height: 10.0,
            width: _currentPage == index ? 24.0 : 10.0,
            decoration: BoxDecoration(
              color: _currentPage == index
                  ? Colors.blueAccent
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(5.0),
            ),
          );
        }),
      ),
    );
  }
}

// ==========================================
// 3. WIDGET HALAMAN DETAIL (PROFIL, JADWAL, NILAI)
// ==========================================

class _ProfileView extends StatelessWidget {
  final Student student;
  const _ProfileView({required this.student});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue[100],
            child: const Icon(Icons.person, size: 50, color: Colors.blueAccent),
          ),
          const SizedBox(height: 20),
          Text(
            student.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            student.nim,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const Divider(height: 40, thickness: 1),
          _buildInfoRow(
            Icons.account_balance,
            'Universitas',
            student.university,
          ),
          _buildInfoRow(Icons.domain, 'Fakultas', student.faculty),
          _buildInfoRow(Icons.school, 'Program Studi', student.major),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleView extends StatelessWidget {
  final List<String> schedule;
  const _ScheduleView({required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jadwal Kelas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: schedule.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(
                    Icons.access_time_filled,
                    color: Colors.orangeAccent,
                  ),
                  title: Text(
                    schedule[index],
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GradesView extends StatelessWidget {
  final Map<String, String> grades;
  const _GradesView({required this.grades});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transkrip Nilai',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: grades.length,
              itemBuilder: (context, index) {
                String subject = grades.keys.elementAt(index);
                String grade = grades.values.elementAt(index);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      subject,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: CircleAvatar(
                      backgroundColor: _getGradeColor(grade),
                      child: Text(
                        grade,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(String grade) {
    if (grade.startsWith('A')) return Colors.green;
    if (grade.startsWith('B')) return Colors.blue;
    if (grade.startsWith('C')) return Colors.orange;
    return Colors.red;
  }
}
