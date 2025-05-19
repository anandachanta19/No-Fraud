import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _amtController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _longController = TextEditingController();
  final TextEditingController _cityPopController = TextEditingController();
  final TextEditingController _merchLatController = TextEditingController();
  final TextEditingController _merchLongController = TextEditingController();
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String? _result;
  bool _loading = false;

  // Dropdown options for category and gender
  final List<Map<String, String>> _categories = [
    {'label': 'Shopping (Net)', 'value': 'shopping_net'},
    {'label': 'Miscellaneous (Net)', 'value': 'misc_net'},
    {'label': 'Grocery (POS)', 'value': 'grocery_pos'},
    {'label': 'Shopping (POS)', 'value': 'shopping_pos'},
    {'label': 'Gas/Transport', 'value': 'gas_transport'},
    {'label': 'Miscellaneous (POS)', 'value': 'misc_pos'},
    {'label': 'Travel', 'value': 'travel'},
    {'label': 'Grocery (Net)', 'value': 'grocery_net'},
    {'label': 'Entertainment', 'value': 'entertainment'},
    {'label': 'Personal Care', 'value': 'personal_care'},
    {'label': 'Kids/Pets', 'value': 'kids_pets'},
    {'label': 'Food/Dining', 'value': 'food_dining'},
    {'label': 'Home', 'value': 'home'},
    {'label': 'Health/Fitness', 'value': 'health_fitness'},
  ];

  final List<Map<String, dynamic>> _genders = [
    {'label': 'Male', 'value': 0},
    {'label': 'Female', 'value': 1},
  ];

  // Add state dropdown options
  final List<Map<String, String>> _states = [
    {'label': 'North Carolina', 'value': 'NC'},
    {'label': 'Washington', 'value': 'WA'},
    {'label': 'Idaho', 'value': 'ID'},
    {'label': 'Montana', 'value': 'MT'},
    {'label': 'Virginia', 'value': 'VA'},
    {'label': 'Pennsylvania', 'value': 'PA'},
    {'label': 'Kansas', 'value': 'KS'},
    {'label': 'Tennessee', 'value': 'TN'},
    {'label': 'Iowa', 'value': 'IA'},
    {'label': 'West Virginia', 'value': 'WV'},
    {'label': 'Florida', 'value': 'FL'},
    {'label': 'California', 'value': 'CA'},
    {'label': 'New Mexico', 'value': 'NM'},
    {'label': 'New Jersey', 'value': 'NJ'},
    {'label': 'Oklahoma', 'value': 'OK'},
    {'label': 'Indiana', 'value': 'IN'},
    {'label': 'Massachusetts', 'value': 'MA'},
    {'label': 'Texas', 'value': 'TX'},
    {'label': 'Wisconsin', 'value': 'WI'},
    {'label': 'Michigan', 'value': 'MI'},
    {'label': 'Wyoming', 'value': 'WY'},
    {'label': 'Hawaii', 'value': 'HI'},
    {'label': 'Nebraska', 'value': 'NE'},
    {'label': 'Oregon', 'value': 'OR'},
    {'label': 'Louisiana', 'value': 'LA'},
    {'label': 'District of Columbia', 'value': 'DC'},
    {'label': 'Kentucky', 'value': 'KY'},
    {'label': 'New York', 'value': 'NY'},
    {'label': 'Mississippi', 'value': 'MS'},
    {'label': 'Utah', 'value': 'UT'},
    {'label': 'Alabama', 'value': 'AL'},
    {'label': 'Arkansas', 'value': 'AR'},
    {'label': 'Maryland', 'value': 'MD'},
    {'label': 'Georgia', 'value': 'GA'},
    {'label': 'Maine', 'value': 'ME'},
    {'label': 'Arizona', 'value': 'AZ'},
    {'label': 'Minnesota', 'value': 'MN'},
    {'label': 'Ohio', 'value': 'OH'},
    {'label': 'Colorado', 'value': 'CO'},
    {'label': 'Vermont', 'value': 'VT'},
    {'label': 'Missouri', 'value': 'MO'},
    {'label': 'South Carolina', 'value': 'SC'},
    {'label': 'Nevada', 'value': 'NV'},
    {'label': 'Illinois', 'value': 'IL'},
    {'label': 'New Hampshire', 'value': 'NH'},
    {'label': 'South Dakota', 'value': 'SD'},
    {'label': 'Alaska', 'value': 'AK'},
    {'label': 'North Dakota', 'value': 'ND'},
    {'label': 'Connecticut', 'value': 'CT'},
    {'label': 'Rhode Island', 'value': 'RI'},
    {'label': 'Delaware', 'value': 'DE'},
  ];

  String? _selectedCategory;
  int? _selectedGender;
  String? _selectedState;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _result = null;
    });

    final url = Uri.parse('https://nofraud.onrender.com/predict');
    final body = {
      "category": _selectedCategory ?? '',
      "amt": double.tryParse(_amtController.text) ?? 0.0,
      "gender": _selectedGender ?? 0,
      "state": _selectedState ?? '',
      "lat": double.tryParse(_latController.text) ?? 0.0,
      "long": double.tryParse(_longController.text) ?? 0.0,
      "city_pop": int.tryParse(_cityPopController.text) ?? 0,
      "merch_lat": double.tryParse(_merchLatController.text) ?? 0.0,
      "merch_long": double.tryParse(_merchLongController.text) ?? 0.0,
      "hour": int.tryParse(_hourController.text) ?? 0,
      "age": int.tryParse(_ageController.text) ?? 0,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prob = data['fraud_probability'];
        final isFraud = data['is_fraud'];
        setState(() {
          _result = isFraud == 1
              ? 'Fraudulent Transaction Detected!\nProbability: ${prob.toStringAsFixed(2)}'
              : 'Legitimate Transaction.\nProbability: ${prob.toStringAsFixed(2)}';
        });
      } else {
        setState(() {
          _result = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _clearInputs() {
    _amtController.clear();
    _latController.clear();
    _longController.clear();
    _cityPopController.clear();
    _merchLatController.clear();
    _merchLongController.clear();
    _hourController.clear();
    _ageController.clear();
    setState(() {
      _selectedCategory = null;
      _selectedGender = null;
      _selectedState = null;
      _result = null;
    });
  }

  @override
  void dispose() {
    _amtController.dispose();
    _latController.dispose();
    _longController.dispose();
    _cityPopController.dispose();
    _merchLatController.dispose();
    _merchLongController.dispose();
    _hourController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'No Fraud',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  "Enter all details of a credit card transaction to detect the transaction is a fraud or legit",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'Category'),
                items: _categories
                    .map((cat) => DropdownMenuItem<String>(
                          value: cat['value'],
                          child: Text(cat['label']!),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedCategory = val;
                  });
                },
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _amtController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              DropdownButtonFormField<int>(
                value: _selectedGender,
                decoration: InputDecoration(labelText: 'Gender'),
                items: _genders
                    .map((g) => DropdownMenuItem<int>(
                          value: g['value'],
                          child: Text(g['label']),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedGender = val;
                  });
                },
                validator: (v) => v == null ? 'Required' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedState,
                decoration: InputDecoration(labelText: 'State'),
                items: _states
                    .map((state) => DropdownMenuItem<String>(
                          value: state['value'],
                          child: Text('${state['label']} (${state['value']})'),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedState = val;
                  });
                },
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _latController,
                decoration: InputDecoration(labelText: 'Payment Latitude'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _longController,
                decoration: InputDecoration(labelText: 'Payment Longitude'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _cityPopController,
                decoration: InputDecoration(labelText: 'City Population'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _merchLatController,
                decoration: InputDecoration(labelText: 'Merchant Latitude'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _merchLongController,
                decoration: InputDecoration(labelText: 'Merchant Longitude'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _hourController,
                decoration: InputDecoration(labelText: 'At which hour transaction happenned? (0-24)'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: _loading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Check Transaction',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              if (_result != null)
                Card(
                  color: _result!.contains('Fraudulent')
                      ? Colors.red[100]
                      : Colors.green[100],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _result!,
                      style: TextStyle(
                        color: _result!.contains('Fraudulent')
                            ? Colors.red
                            : Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              if (_result != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: _clearInputs,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                    ),
                    child: Text(
                      'Clear Inputs',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}