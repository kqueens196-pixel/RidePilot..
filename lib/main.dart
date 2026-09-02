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
      home: const AuthWrapper(),
    );
  }
}

// ---------------- AUTH FLOW ----------------

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isLoggedIn = false;
  bool permissionsGranted = false;

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) {
      return LoginScreen(onLoginSuccess: () {
        setState(() => isLoggedIn = true);
      });
    }

    if (!permissionsGranted) {
      return PermissionSetupScreen(onDone: () {
        setState(() => permissionsGranted = true);
      });
    }

    return const AppMasterNavigation();
  }
}

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  bool otpSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.flash_on, size: 70, color: Color(0xFF00C853)),
            const SizedBox(height: 12),
            const Text(
              "RIDEPILOT",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            const Text(
              "All Delivery & Ride Apps in One Dashboard",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 40),
            if (!otpSent) ...[
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixText: "+91 ",
                  labelText: "Mobile Number",
                  filled: true,
                  fillColor: const Color(0xFF161F30),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C853),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (phoneController.text.isNotEmpty) {
                    setState(() => otpSent = true);
                  }
                },
                child: const Text("SEND OTP", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              ),
            ] else ...[
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter 4-Digit OTP",
                  filled: true,
                  fillColor: const Color(0xFF161F30),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C853),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: widget.onLoginSuccess,
                child: const Text("VERIFY & CONTINUE", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

// ---------------- PERMISSION ONBOARDING ----------------

class PermissionSetupScreen extends StatefulWidget {
  final VoidCallback onDone;
  const PermissionSetupScreen({super.key, required this.onDone});

  @override
  State<PermissionSetupScreen> createState() => _PermissionSetupScreenState();
}

class _PermissionSetupScreenState extends State<PermissionSetupScreen> {
  bool accessibilityOn = false;
  bool overlayOn = false;
  bool batteryOptOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("System Permissions Setup"),
        backgroundColor: const Color(0xFF161F30),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Swiggy, Zomato aur Uber orders auto-accept karne ke liye ye 3 system permissions on karein:",
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 24),
            _permissionTile(
              title: "1. Accessibility Service",
              subtitle: "Screen par Accept button detect aur auto-click karne ke liye",
              status: accessibilityOn,
              onToggle: () => setState(() => accessibilityOn = !accessibilityOn),
            ),
            _permissionTile(
              title: "2. Display Over Other Apps",
              subtitle: "Order pop-up float heads dikhane ke liye",
              status: overlayOn,
              onToggle: () => setState(() => overlayOn = !overlayOn),
            ),
            _permissionTile(
              title: "3. Disable Battery Saver",
              subtitle: "Background me bina kill huye order auto-receive karne ke liye",
              status: batteryOptOn,
              onToggle: () => setState(() => batteryOptOn = !batteryOptOn),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: (accessibilityOn && overlayOn && batteryOptOn)
                    ? const Color(0xFF00C853)
                    : Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: (accessibilityOn && overlayOn && batteryOptOn) ? widget.onDone : null,
              child: const Text("ACTIVATE SERVICE & CONTINUE", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _permissionTile({required String title, required String subtitle, required bool status, required VoidCallback onToggle}) {
    return Card(
      color: const Color(0xFF161F30),
      margin: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: Switch(
          value: status,
          activeColor: const Color(0xFF00C853),
          onChanged: (_) => onToggle(),
        ),
      ),
    );
  }
}

// ---------------- MAIN APP SYSTEM ----------------

class AppMasterNavigation extends StatefulWidget {
  const AppMasterNavigation({super.key});

  @override
  State<AppMasterNavigation> createState() => _AppMasterNavigationState();
}

class _AppMasterNavigationState extends State<AppMasterNavigation> {
  int currentTab = 0;
  bool autoAccept = true;
  bool parcelMode = false;
  int selectedDistance = 2;

  final List<Map<String, dynamic>> orders = [
    {"platform": "Zomato", "distance": "0.8 km away", "fare": "₹42", "location": "Sector 18, Noida", "color": Colors.redAccent},
    {"platform": "Swiggy", "distance": "1.2 km away", "fare": "₹38", "location": "Sector 16, Noida", "color": Colors.orangeAccent},
    {"platform": "Rapido", "distance": "1.5 km away", "fare": "₹55", "location": "Sector 19, Noida", "color": Colors.amberAccent},
    {"platform": "Uber", "distance": "1.8 km away", "fare": "₹102", "location": "Sector 62, Noida", "color": Colors.white},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF161F30),
        title: const Text("RIDEPILOT", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        actions: [
          Switch(
            value: autoAccept,
            activeColor: const Color(0xFF00C853),
            onChanged: (val) => setState(() => autoAccept = val),
          )
        ],
      ),
      body: currentTab == 0 ? buildDriverDashboard() : buildAdminPanel(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        backgroundColor: const Color(0xFF161F30),
        selectedItemColor: const Color(0xFF00C853),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => currentTab = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.flash_on), label: "Live Driver"),
          BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: "Admin Console"),
        ],
      ),
    );
  }

  Widget buildDriverDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: const Color(0xFF1B263B), borderRadius: BorderRadius.circular(16)),
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
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF1B263B), borderRadius: BorderRadius.circular(16)),
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
                    child: Text(o['platform'][0], style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  title: Text("${o['platform']} • ${o['location']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(o['distance'], style: const TextStyle(color: Colors.grey)),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(o['fare'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
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

  Widget buildAdminPanel() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Super Admin Console", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Emergency: Global Order Sync Paused")),
                  );
                },
                icon: const Icon(Icons.pause, size: 16),
                label: const Text("Stop All", style: TextStyle(fontSize: 12)),
              )
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _adminTile("Total Registered Users", "12,568", Colors.blueAccent),
              _adminTile("Active Drivers Online", "8,945", Colors.greenAccent),
              _adminTile("Total Auto-Accepted", "45,632", Colors.orangeAccent),
              _adminTile("Platform Revenue", "₹12,45,678", Colors.purpleAccent),
            ],
          ),
          const SizedBox(height: 24),
          const Text("Live Platform Split", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _platformStat("Zomato Delivery Fleet", "35%"),
          _platformStat("Swiggy Delivery Partner", "25%"),
          _platformStat("Rapido Captain Fleet", "15%"),
          _platformStat("Uber Driver Fleet", "15%"),
          _platformStat("Zepto & Blinkit Hubs", "10%"),
          const SizedBox(height: 24),
          const Text("Master Automation Override", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ListTile(
            tileColor: const Color(0xFF161F30),
            title: const Text("Force Minimum Distance Threshold"),
            subtitle: const Text("Lock all driver apps to max 2KM limit"),
            trailing: Switch(value: true, onChanged: (_) {}),
          ),
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
          Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 8),
          Text(val, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _platformStat(String title, String pct) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          Text(pct, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00C853))),
        ],
      ),
    );
  }
}
