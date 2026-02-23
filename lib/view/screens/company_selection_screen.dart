import 'package:fabric_warehouse_dashboard/controller/ware_house_controller.dart';
import 'package:fabric_warehouse_dashboard/view/fabric_warehouse_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CompanySelectionScreen extends StatelessWidget {
  const CompanySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final companies = [
      {'id': '04', 'name': 'BGL', 'color': const Color(0xFF1F618D)},
      {'id': '06', 'name': 'TAL', 'color': const Color(0xFF27AE60)},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Fabric Warehouse Dashboard',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'ফ্যাব্রিক ওয়ারহাউজ ড্যাশবোর্ড',
              style: TextStyle(
                fontSize: 22,
                color: Colors.white60,
              ),
            ),
            SizedBox(height: 60),
            Text(
              'Select Company / কোম্পানি নির্বাচন করুন',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '← → arrow keys to navigate  |  OK / Enter to select',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white38,
              ),
            ),
            SizedBox(height: 40),
            // FocusTraversalGroup ensures D-pad moves between cards
            FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: companies.asMap().entries.map((entry) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: _CompanyCard(
                      id: entry.value['id'] as String,
                      name: entry.value['name'] as String,
                      color: entry.value['color'] as Color,
                      autofocus: entry.key == 0,
                      order: entry.key.toDouble(),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompanyCard extends StatefulWidget {
  final String id;
  final String name;
  final Color color;
  final bool autofocus;
  final double order;

  const _CompanyCard({
    required this.id,
    required this.name,
    required this.color,
    required this.autofocus,
    required this.order,
  });

  @override
  State<_CompanyCard> createState() => _CompanyCardState();
}

class _CompanyCardState extends State<_CompanyCard> {
  bool _focused = false;
  bool _hovered = false;

  bool get _highlighted => _focused || _hovered;

  void _onSelect() {
    if (Get.isRegistered<FabricWarehouseController>()) {
      Get.find<FabricWarehouseController>().initializeWithCompany(widget.id);
    } else {
      Get.put(FabricWarehouseController()).initializeWithCompany(widget.id);
    }
    Get.to(() => const FabricDashboardScreen());
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      autofocus: widget.autofocus,
      onFocusChange: (focused) => setState(() => _focused = focused),
      onShowFocusHighlight: (focused) => setState(() => _focused = focused),
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            _onSelect();
            return null;
          },
        ),
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: _onSelect,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 260,
            height: 180,
            decoration: BoxDecoration(
              color: _highlighted
                  ? widget.color
                  : widget.color.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _highlighted ? Colors.white : Colors.white24,
                width: _highlighted ? 3 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: _highlighted ? 0.7 : 0.2),
                  blurRadius: _highlighted ? 32 : 10,
                  spreadRadius: _highlighted ? 6 : 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: _highlighted ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 180),
                  child: Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                AnimatedOpacity(
                  opacity: _highlighted ? 1.0 : 0.6,
                  duration: const Duration(milliseconds: 180),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: _highlighted
                          ? Colors.white.withValues(alpha: 0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _highlighted ? Colors.white54 : Colors.transparent,
                      ),
                    ),
                    child: Text(
                      _highlighted ? 'Press OK to Select' : 'View Dashboard',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: _highlighted
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
