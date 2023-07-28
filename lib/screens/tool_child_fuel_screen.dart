import 'package:flutter/material.dart';
import 'package:tripline/widgets/input_fields.dart';
import 'package:tripline/widgets/other_widgets.dart';

class ToolsChildFuel extends StatefulWidget {
  final String title;

  const ToolsChildFuel({required this.title});

  @override
  State<ToolsChildFuel> createState() => _ToolsChildFuelState();
}

class _ToolsChildFuelState extends State<ToolsChildFuel> {
  final TextEditingController distance = TextEditingController();
  final TextEditingController mileage = TextEditingController();
  final TextEditingController fuelCost = TextEditingController();
  String calculatedAmount = '₹0.00';

  void calculateFuelCost() {
    double totalDistance = double.tryParse(distance.text) ?? 0;
    double vehicleMileage = double.tryParse(mileage.text) ?? 0;
    double costPerLiter = double.tryParse(fuelCost.text) ?? 0;

    if (totalDistance <= 0 || vehicleMileage <= 0 || costPerLiter <= 0) {
      setState(() {
        calculatedAmount = '₹0.00';
      });
    } else {
      double fuelAmount = (totalDistance / vehicleMileage) * costPerLiter;

      setState(() {
        calculatedAmount = '₹' + fuelAmount.toStringAsFixed(2);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 500,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                'Fuel Cost',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
              ),
              Text(
                '$calculatedAmount',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              CustomInputField(
                hintText: 'Enter Total Distance',
                InputControl: distance,
                inputIcon: Icons.confirmation_number_outlined,
              ),
              SizedBox(
                height: 15,
              ),
              CustomInputField(
                hintText: 'Enter Mileage of Your Vehicle',
                InputControl: mileage,
                inputIcon: Icons.confirmation_number_outlined,
              ),
              SizedBox(
                height: 15,
              ),
              CustomInputField(
                hintText: 'Enter Fuel Cost',
                InputControl: fuelCost,
                inputIcon: Icons.confirmation_number_outlined,
              ),
              SizedBox(
                height: 15,
              ),
              CustomSecondaryButton(
                buttonText: 'Calculate',
                onPressed: () {
                  calculateFuelCost();
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
