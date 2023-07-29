import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartCustom extends StatelessWidget {
  const ChartCustom({
    super.key,
    required this.currentExpense,
    required this.data,
  });

  final double currentExpense;
  final List<Expense> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          height: 250,
          padding: const EdgeInsets.all(10),
          child: SfCartesianChart(
            plotAreaBorderWidth: 1, // Remove plot area border
            primaryXAxis: CategoryAxis(
              isVisible: false, // Hide the bottom axis
            ),
            primaryYAxis: NumericAxis(
              majorGridLines:
                  MajorGridLines(width: 0), // Remove horizontal gridlines
              minimum: 0,
              maximum: currentExpense,
              isVisible: false,
            ),
            series: <ChartSeries>[
              ColumnSeries<Expense, String>(
                dataSource: data,
                xValueMapper: (Expense expense, _) => expense.category,
                yValueMapper: (Expense expense, _) => expense.amount,
                dataLabelSettings: DataLabelSettings(
                  isVisible: false, // Disable data labels on bars
                ),
                // borderRadius: BorderRadius.circular(4), // Set a border radius for the bars

                width: 0.4, // Reduce the width of the bars
                pointColorMapper: (Expense expense, _) {
                  // Set different colors for each bar
                  if (expense.category == 'Travel') {
                    return Color(0xFF019962);
                  } else if (expense.category == 'Food') {
                    return Color(0xFFFFC976);
                  } else if (expense.category == 'Accommodation') {
                    return Color(0xFFFF7872);
                  } else if (expense.category == 'Others') {
                    return Color(0xFF91E4F6);
                  }
                  return Colors.grey;
                },
              ),
            ],
            annotations: <CartesianChartAnnotation>[
              for (final expense in data)
                CartesianChartAnnotation(
                  widget: Container(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      expense.amount.toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  coordinateUnit: CoordinateUnit.point,
                  x: expense.category,
                  y: expense.amount,
                  verticalAlignment: ChartAlignment.far,
                  horizontalAlignment: ChartAlignment.center,
                  region: AnnotationRegion.chart,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class Expense {
  final String category;
  final int amount;

  Expense({required this.category, required this.amount});
}
