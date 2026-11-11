import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final registrationRef =
        FirebaseFirestore.instance.collection('registrations');
    final surveyRef = FirebaseFirestore.instance.collection('surveys');
    final visitsRef =
        FirebaseFirestore.instance.collection('analytics').doc('visits');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        bottom: const TabBar(
          tabs: [
            Tab(text: 'Registrations'),
            Tab(text: 'Surveys'),
          ],
        ),
      ),
      body: Column(
        children: [
          // 📊 TOP STATS
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: registrationRef.snapshots(),
                    builder: (context, snapshot) {
                      final count = snapshot.data?.docs.length ?? 0;
                      return _StatCard(
                        label: 'Total Registrations',
                        value: '$count',
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: surveyRef.snapshots(),
                    builder: (context, snapshot) {
                      final count = snapshot.data?.docs.length ?? 0;
                      return _StatCard(
                        label: 'Survey responses',
                        value: '$count',
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: visitsRef.snapshots(),
                    builder: (context, snapshot) {
                      final data =
                          snapshot.data?.data() as Map<String, dynamic>?;
                      final count = data?['count'] ?? 0;
                      return _StatCard(
                        label: 'Total Visits',
                        value: '$count',
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // 🔍 SEARCH BAR (UI ONLY for now)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search by name or email...",
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 👥 USER LIST
          Expanded(
            child: TabBarView(
              children: [
                _registrationList(registrationRef),
                _surveyList(surveyRef),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _registrationList(CollectionReference registrationRef) {
    return StreamBuilder<QuerySnapshot>(
              stream: registrationRef
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index];

                    final name = data['name'] ?? '';
                    final email = data['email'] ?? '';
                    final phone = data['phone'] ?? '';
                    final skills = List<String>.from(data['skills'] ?? []);

                    return Card(
                      color: Colors.white10,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          "$email\n$phone\nSkills: ${skills.join(', ')}",
                          style: const TextStyle(color: Colors.white70),
                        ),
                        isThreeLine: true,
                        trailing: const Icon(
                          Icons.person,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    );
                  },
                );
              },
    );
  }

  Widget _surveyList(CollectionReference surveyRef) {
    return StreamBuilder<QuerySnapshot>(
      stream: surveyRef.orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return const Center(
            child: Text(
              'No survey responses yet.',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final name = data['name'] ?? '';
            final phone = data['phone'] ?? '';
            final rating = data['satisfaction'] ?? '';
            final platforms = List<String>.from(data['platforms'] ?? []);
            return Card(
              color: Colors.white10,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  '$name',
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  '$phone\n$rating\nPlatforms: ${platforms.join(', ')}',
                  style: const TextStyle(color: Colors.white70),
                ),
                isThreeLine: true,
              ),
            );
          },
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
