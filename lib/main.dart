import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const SorteggioApp());
}

class SorteggioApp extends StatelessWidget {
  const SorteggioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();
  List<List<int>> gruppi = [];

  void generaGruppi() {
    int totale = int.tryParse(controller.text) ?? 0;
    if (totale <= 0) return;

    setState(() {
      gruppi = creaGruppi(totale);
    });
  }

  // 🔥 FUNZIONE CON SORTeggio CASUALE
  List<List<int>> creaGruppi(int totale) {
    const int dimensioneIdeale = 4;

    int numeroGruppi = (totale / dimensioneIdeale).round();
    if (numeroGruppi == 0) numeroGruppi = 1;

    // 1️⃣ Lista persone
    List<int> persone = List.generate(totale, (i) => i + 1);

    // 2️⃣ Mischia casualmente
    persone.shuffle(Random());

    int base = totale ~/ numeroGruppi;
    int extra = totale % numeroGruppi;

    List<List<int>> risultato = [];
    int index = 0;

    // 3️⃣ Crea gruppi equilibrati
    for (int i = 0; i < numeroGruppi; i++) {
      int dimensione = base + (i < extra ? 1 : 0);
      risultato.add(persone.sublist(index, index + dimensione));
      index += dimensione;
    }

    return risultato;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sorteggio Gruppi'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Numero totale di persone',
                        prefixIcon: Icon(Icons.people),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.shuffle),
                        label: const Text('Genera gruppi'),
                        onPressed: generaGruppi,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: gruppi.isEmpty
                    ? const Center(
                        child: Text(
                          'Inserisci un numero e genera i gruppi',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: gruppi.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text('${index + 1}'),
                              ),
                              title: Text(
                                'Gruppo ${index + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Persone: ${gruppi[index].join(', ')}',
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

