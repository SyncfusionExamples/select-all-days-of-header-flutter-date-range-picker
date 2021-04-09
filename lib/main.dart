import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

void main() => runApp(ViewHeaderSelectedDates());

class ViewHeaderSelectedDates extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HeaderCustomization(),
    );
  }
}

class HeaderCustomization extends StatefulWidget {
  @override
  HeaderCustomizationState createState() => HeaderCustomizationState();
}

class HeaderCustomizationState extends State<HeaderCustomization> {
  final List<String> _days = <String>['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  final DateRangePickerController _controller = DateRangePickerController();
  String _headerString = '';
  late PickerDateRange _visibleDateRange;
  int _selectedWeekDay = -1;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    const double viewHeaderHeight = 50;
    final double viewHeaderCellWidth = width / _days.length;

    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            child: Row(
          children: <Widget>[
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: viewHeaderCellWidth,
                child: IconButton(
                  icon: Icon(Icons.arrow_left),
                  color: Colors.black,
                  onPressed: () {
                    setState(() {
                      _controller.backward!();
                    });
                  },
                )),
            Expanded(
              child: Text(_headerString,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, color: Colors.black)),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: viewHeaderCellWidth,
                child: IconButton(
                  icon: Icon(Icons.arrow_right),
                  color: Colors.black,
                  onPressed: () {
                    setState(() {
                      _controller.forward!();
                    });
                  },
                )),
          ],
        )),
        Container(
            height: viewHeaderHeight,
            width: width,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: ListView.builder(
                itemCount: _days.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        final int selectedIndex = index == 0 ? 7 : index;
                        _selectedWeekDay = selectedIndex;
                        _updateSelectedDates();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: viewHeaderCellWidth,
                        height: viewHeaderHeight,
                        child: Text(_days[index]),
                      ));
                })),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: SfDateRangePicker(
            selectionMode: DateRangePickerSelectionMode.multiple,
            controller: _controller,
            headerHeight: 0,
            onViewChanged: viewChanged,
            monthViewSettings:
                DateRangePickerMonthViewSettings(viewHeaderHeight: 0),
          ),
        )
      ],
    ));
  }

  void _updateSelectedDates() {
    if (_selectedWeekDay == -1) {
      return;
    }

    final List<DateTime> selectedDates = <DateTime>[];
    DateTime date = _visibleDateRange.startDate!;
    while (date.isBefore(_visibleDateRange.endDate!) ||
        (date.year == _visibleDateRange.endDate!.year &&
            date.month == _visibleDateRange.endDate!.month &&
            date.day == _visibleDateRange.endDate!.day)) {
      if (_selectedWeekDay == date.weekday) {
        selectedDates.add(date);
      }

      date = date.add(Duration(days: 1));
    }

    _controller.selectedDates = selectedDates;
  }

  void viewChanged(DateRangePickerViewChangedArgs args) {
    _visibleDateRange = args.visibleDateRange;
    final int daysCount = (args.visibleDateRange.endDate!
        .difference(args.visibleDateRange.startDate!)
        .inDays);
    final DateTime date =
        args.visibleDateRange.startDate!.add(Duration(days: daysCount ~/ 2));
    _headerString = DateFormat('MMMM yyyy').format(date).toString();
    SchedulerBinding.instance!.addPostFrameCallback((duration) {
      setState(() {});
    });
  }
}
