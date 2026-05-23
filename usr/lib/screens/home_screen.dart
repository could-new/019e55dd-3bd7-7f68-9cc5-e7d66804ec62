import 'package:flutter/material.dart';
import '../models/medication.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Medication> _medications = [
    Medication(id: '1', name: 'فيتامين د', time: const TimeOfDay(hour: 8, minute: 0), description: 'حبة واحدة بعد الإفطار'),
    Medication(id: '2', name: 'مسكن ألم', time: const TimeOfDay(hour: 14, minute: 30), description: 'عند الحاجة'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أدويتي', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: _medications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.medical_information, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'لا يوجد أدوية مضافة',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _medications.length,
              itemBuilder: (context, index) {
                final med = _medications[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.medication, color: Theme.of(context).colorScheme.primary),
                    ),
                    title: Text(
                      med.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Text(
                                med.time.format(context),
                                style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          if (med.description != null && med.description!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(med.description!, style: TextStyle(color: Colors.grey.shade600)),
                          ]
                        ],
                      ),
                    ),
                    trailing: Switch(
                      value: med.isActive,
                      onChanged: (value) {
                        setState(() {
                          med.isActive = value;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddMedicationDialog();
        },
        icon: const Icon(Icons.add),
        label: const Text('إضافة دواء'),
      ),
    );
  }

  void _showAddMedicationDialog() {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('إضافة دواء جديد'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'اسم الدواء',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(
                        labelText: 'ملاحظات (اختياري)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      title: const Text('وقت التنبيه'),
                      trailing: Text(
                        selectedTime.format(context),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (time != null) {
                          setDialogState(() {
                            selectedTime = time;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      setState(() {
                        _medications.add(
                          Medication(
                            id: DateTime.now().toString(),
                            name: nameController.text,
                            time: selectedTime,
                            description: descController.text,
                          ),
                        );
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('حفظ'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
