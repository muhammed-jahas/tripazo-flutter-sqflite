import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tripline/database/database_helper.dart';

// Input Text Field
class CustomInputField extends StatefulWidget {
  final String hintText;
  final IconData inputIcon;
  final TextEditingController InputControl;
  final FormFieldValidator<String>? customValidator;
  final String? errorText;
  final FocusNode? focusnode;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardtype;
  final String? labelText;

  CustomInputField({
    super.key,
    required this.hintText,
    required this.InputControl,
    required this.inputIcon,
    this.customValidator,
    this.errorText,
    this.focusnode,
    this.obscureText = false,
    this.onChanged,
    this.keyboardtype,
    this.labelText,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 58,
      ),
      child: TextFormField(
        validator: widget.customValidator,
        onChanged: widget.onChanged,
        focusNode: widget.focusnode,
        controller: widget.InputControl,
        keyboardType: widget.keyboardtype,
        obscureText:
            widget.obscureText == true ? isObscured : widget.obscureText,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Color(0xFFB3B3B3),
          ),
          suffixIcon: InkWell(
            onTap: () {
              setState(() {
                isObscured = !isObscured;
              });
            },
            child: Icon(
              widget.obscureText == false
                  ? widget.inputIcon
                  : isObscured == true
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
              size: 20,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          errorText: widget.errorText,
        ),
      ),
    );
  }
}

//Calendar Input Field

class CustomCalendarInputField extends StatefulWidget {
  final String hintText;
  final IconData inputIcon;
  final TextEditingController inputControl;
  final FormFieldValidator<String>? customValidator;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final String? labelText;

  CustomCalendarInputField({
    required this.hintText,
    required this.inputIcon,
    required this.inputControl,
    this.customValidator,
    this.errorText,
    this.onChanged,
    this.labelText,
  });

  @override
  _CustomCalendarInputFieldState createState() =>
      _CustomCalendarInputFieldState();
}

class _CustomCalendarInputFieldState extends State<CustomCalendarInputField> {
  String selectedDate = '';
  List<String> selectedTripDates = [];

  void initState() {
    super.initState();
    loadSelectedTripDates(); // Load selected trip dates from the database
  }

  Future<void> loadSelectedTripDates() async {
    // You should modify this function to retrieve the selected trip dates for the user
    // from the database using the appropriate function from your DatabaseHelper class.
    // For example, if you have a function called `getSelectedTripDates` in your DatabaseHelper,
    // you can call it like this:
    List<String> dates = await DatabaseHelper.instance.getSelectedTripDates(1);
    setState(() {
      selectedTripDates = dates;
    });
  }

  Future<void> _showCustomDatePicker() async {
    DateTime? pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        DateTime selectedDate = DateTime.now();
        bool isInvalidDateSelected =
            false; // To track if an invalid date is selected
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TableCalendar(
                      firstDay: DateTime.now(), // Disable dates before today
                      lastDay: DateTime(2099),
                      focusedDay: selectedDate,
                      selectedDayPredicate: (day) {
                        final formattedDate =
                            DateFormat('yyyy-MM-dd').format(day);
                        return !selectedTripDates.contains(formattedDate);
                      },
                      onDaySelected: (selected, focused) {
                        final formattedDate =
                            DateFormat('yyyy-MM-dd').format(selected);
                        if (!selectedTripDates.contains(formattedDate)) {
                          // The selected date is not already a trip date, so close the picker and return the date
                          Navigator.pop(context, selected);
                        } else {
                          // The selected date is already a trip date, show the error message
                          setState(() {
                            isInvalidDateSelected = true;
                          });
                        }
                      },
                      calendarBuilders: CalendarBuilders(
                        // Define a custom dayBuilder for non-selectable dates
                        // Here, we give them a grey background
                        defaultBuilder: (context, day, focusedDay) {
                          final formattedDate =
                              DateFormat('yyyy-MM-dd').format(day);
                          if (selectedTripDates.contains(formattedDate)) {
                            return Container(
                              margin: const EdgeInsets.all(4),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                day.day.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    if (isInvalidDateSelected)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.red,

                          ),
                          
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20),
                            child: Text(
                              'You have already a Trip in this Date.',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        widget.inputControl.text = selectedDate;
        print(widget.inputControl.text);
       
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 58,
      ),
      child: TextFormField(
        onChanged: widget.onChanged,
        controller: widget.inputControl,
        readOnly: true, // Make the field non-editable
        onTap: _showCustomDatePicker, // Show date picker on tap
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Color(0xFFB3B3B3),
          ),
          suffixIcon: Icon(
            widget.inputIcon,
            size: 20,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          errorText: widget.errorText,
        ),
      ),
    );
  }
}
