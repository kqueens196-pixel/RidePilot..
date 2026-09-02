import 'package:flutter/material.dart';

void main() {
  runApp(const RidePilotApp());
}

class RidePilotApp extends StatelessWidget {
  const RidePilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RidePilot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D131F),
        primaryColor: const Color(0xFF00C853),
      ),
      home: const MainDashboard(),
    );
  }
}

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  bool autoAccept = true;
  bool parcelMode = false;
  int selectedDistance = 2;
  int currentTab = 0;

  final List<Map<String, dynamic>> orders = [
    {
      "platform": "Zomato",
      "distance": "0.8 km away",
      "fare": "₹42",
      "location": "Sector 18, Noida",
      "color": Colors.redAccent
    },
    {
      "platform": "Swiggy",
      "distance": "1.2 km away",
      "fare": "₹38",
      "location": "Sector 16, Noida",
      "color": Colors.orangeAccent
    },
    {
      "platform": "Rapido",
      "distance": "1.5 km away",
      "fare": "₹55",
      "location": "Sector 19, Noida",
      "color": Colors.amberAccent
    },
    {
      "platform": "Uber",
      "distance": "1.8 km away",
      "fare": "₹102",
      "location": "Sector 62, Noida",
      "color": Colors.white
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF161F30),
        title: const Text(
          "RIDEPILOT",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        actions: [
          Switch(
            value: autoAccept,
            activeColor: const Color(0xFF00C853),
            onChanged: (val) => setState(() => autoAccept = val),
          )
        ],
      ),
      body: currentTab == 0 ? buildDashboard() : buildAdminView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        backgroundColor: const Color(0xFF161F30),
        selectedItemColor: const Color(0xFF00C853),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => currentTab = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.flash_on), label: "Live Driver"),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_customize), label: "Admin Panel"),
        ],
      ),
    );
  }

  Widget buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1B263B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Today's Earnings", style: TextStyle(color: Colors.grey, fontSize: 13)),
                    SizedBox(height: 6),
                    Text("₹1,245", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                Column(
                  children: [
                    Text("Orders", style: TextStyle(color: Colors.grey, fontSize: 13)),
                    SizedBox(height: 6),
                    Text("23", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                Column(
                  children: [
                    Text("Online Time", style: TextStyle(color: Colors.grey, fontSize: 13)),
                    SizedBox(height: 6),
                    Text("6h 20m", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1B263B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Smart Order Filter", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [1, 2, 5, 10].map((km) {
                    return ChoiceChip(
                      label: Text("$km KM"),
                      selected: selectedDistance == km,
                      selectedColor: const Color(0xFF00C853),
                      onSelected: (selected) {
                        if (selected) setState(() => selectedDistance = km);
                      },
                    );
                  }).toList(),
                ),
                const Divider(height: 24, color: Colors.grey),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Parcel Orders Only Mode"),
                    Switch(
                      value: parcelMode,
                      activeColor: Colors.blueAccent,
                      onChanged: (v) => setState(() => parcelMode = v),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Live Intercepted Feed", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: autoAccept ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  autoAccept ? "AI AUTO-ACCEPT ACTIVE" : "MANUAL MODE",
                  style: TextStyle(
                    color: autoAccept ? Colors.greenAccent : Colors.redAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final o = orders[index];
              return Card(
                color: const Color(0xFF161F30),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: o['color'],
                    child: Text(
                      o['platform'][0],
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    "${o['platform']} • ${o['location']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(o['distance'], style: const TextStyle(color: Colors.grey)),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        o['fare'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                      ),
                      const Text("Accepted", style: TextStyle(fontSize: 10, color: Colors.greenAccent)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildAdminView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Live Admin Overview", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _adminTile("Total Users", "12,568", Colors.blueAccent),
              _adminTile("Active Drivers", "8,945", Colors.greenAccent),
              _adminTile("Total Orders", "45,632", Colors.orangeAccent),
              _adminTile("Platform Revenue", "₹12,45,678", Colors.purpleAccent),
            ],
          ),
          const SizedBox(height: 20),
          const Text("Platform Distribution", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _platformStat("Zomato Orders", "35%"),
          _platformStat("Swiggy Orders", "25%"),
          _platformStat("Rapido Rides", "15%"),
          _platformStat("Uber Rides", "15%"),
          _platformStat("Zepto / Blinkit", "10%"),
        ],
      ),
    );
  }

  Widget _adminTile(String title, String val, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161F30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          Text(val, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _platformStat(String title, String pct) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          Text(
            pct,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00C853)),
          ),
        ],
      ),
    );
  }
}
