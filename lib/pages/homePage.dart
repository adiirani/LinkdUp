import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  // Neumorphic container widget
  Widget _neumorphicBox(BuildContext context, {required Widget child, double radius = 12}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = Theme.of(context).scaffoldBackgroundColor;

    return Container(
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(4, 4),
                  blurRadius: 10,
                ),
                BoxShadow(
                  color: Colors.grey.shade800,
                  offset: Offset(-4, -4),
                  blurRadius: 10,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.grey.shade300,
                  offset: Offset(4, 4),
                  blurRadius: 10,
                ),
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 10,
                ),
              ],
      ),
      child: child,
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _neumorphicBox(
                  context,
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      hintText: 'Search friends...',
                      border: InputBorder.none,
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              TextButton(
                onPressed: () {
                  // Navigate to all friends screen or modal
                },
                child: Text('See all'),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 140,
          padding: EdgeInsets.only(left: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 18,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                margin: EdgeInsets.only(right: 12),
                child: _neumorphicBox(
                  context,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          'https://i.pravatar.cc/150?img=${index + 5}',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            'User ${index + 1}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }



  Widget _buildNearbyScroll(BuildContext context) {
    return Container(
      height: 120,
      padding: EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 12),
            child: _neumorphicBox(
              context,
              child: Container(
                width: 100,
                alignment: Alignment.center,
                padding: EdgeInsets.all(12),
                child: Text('Nearby ${index + 1}'),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLeaderboard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(5, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: _neumorphicBox(
              context,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage('https://i.pravatar.cc/150?img=${index + 20}'),
                ),
                title: Text('User ${index + 1}'),
                trailing: Text('${(index + 1) * 100} pts'),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Color(0xFF2E2E2E) : Color(0xFFE0E5EC),
      appBar: AppBar(
        backgroundColor: isDark ? Color(0xFF2E2E2E) : Color(0xFFE0E5EC),
        elevation: 0,
        title: Text(
          'Homepage',
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileSection(context),
            _buildNearbyScroll(context),
            _buildLeaderboard(context),
          ],
        ),
      ),
    );
  }
}
