library weekly_date_picker;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:week_of_year/week_of_year.dart';
import "package:weekly_date_picker/datetime_apis.dart";

import '../../theme/app_styles.dart';
import '../../theme/colors.dart';
import '../custom_lock_scroll_physic.dart';

class WeeklyDatePicker extends StatefulWidget {
  WeeklyDatePicker({
    Key? key,
    required this.selectedDay,
    required this.changeDay,
    this.weekdayText = 'Week',
    this.weekdays = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    this.backgroundColor = const Color(0xFFFAFAFA),
    this.selectedBackgroundColor = const Color(0xFF2A2859),
    this.selectedDigitColor = const Color(0xFFFFFFFF),
    this.digitsColor = const Color(0xFF000000),
    this.weekdayTextColor = const Color(0xFF303030),
    this.enableWeeknumberText = true,
    this.weeknumberColor = const Color(0xFFB2F5FE),
    this.weeknumberTextColor = const Color(0xFF000000),
    this.daysInWeek = 7,
    required this.pageController,
    required this.callbackIndex,
    required this.callBackJumpToNextPage,
    this.monthCallBack,
  })  : assert(weekdays.length == daysInWeek,
            "weekdays must be of length $daysInWeek"),
        super(key: key);

  final VoidCallback? monthCallBack;

  /// The current selected day
  final DateTime selectedDay;

  /// Callback function with the new selected date
  final Function(DateTime) changeDay;

  /// Specifies the weekday text: default is 'Week'
  final String weekdayText;

  /// Specifies the weekday strings ['Mon', 'Tue'...]
  final List<String> weekdays;

  /// Background color
  final Color backgroundColor;

  /// Color of the selected digits text
  final Color selectedBackgroundColor;

  /// Color of the unselected digits text
  final Color selectedDigitColor;

  /// Color of the unselected digits text
  final Color digitsColor;

  /// Is the color of the weekdays 'Mon', 'Tue'...
  final Color weekdayTextColor;

  /// Set to false to hide the weeknumber textfield to the left of the slider
  final bool enableWeeknumberText;

  /// Color of the weekday container
  final Color weeknumberColor;

  /// Color of the weekday text
  final Color weeknumberTextColor;

  /// Specifies the number of weekdays to render, default is 7, so Monday to Sunday
  final int daysInWeek;

  Function(PageController controller) pageController;
  Function(int index) callbackIndex;
  Function(DateTime) callBackJumpToNextPage;

  @override
  _WeeklyDatePickerState createState() => _WeeklyDatePickerState();
}

class _WeeklyDatePickerState extends State<WeeklyDatePicker> {
  final DateTime _todaysDateTime = DateTime.now();

  // About 100 years back in time should be sufficient for most users, 52 weeks * 100
  final int _weekIndexOffset = 5200;

  late final PageController _controller;
  late final DateTime _initialSelectedDay;
  late String _weeknumberInSwipe;
  int currentIndex = 0;
  int currentWeek = 0;
  bool isHidePreviousButton = true;

  @override
  void initState() {
    super.initState();
    currentIndex = _weekIndexOffset;
    _controller = PageController(initialPage: _weekIndexOffset);
    widget.pageController(_controller);
    _initialSelectedDay = widget.selectedDay;
    _weeknumberInSwipe = convertDateToMMYYYY(widget.selectedDay);
    currentWeek = widget.selectedDay.weekOfYear;
  }

  String convertDateToMMYYYY(DateTime date) =>
      DateFormat('MM/yyyy').format(date);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 70,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                splashColor: isHidePreviousButton
                    ? Colors.transparent
                    : Colors.grey[100],
                onTap: () {
                  if (!isHidePreviousButton) {
                    _controller.animateToPage(currentIndex - 1,
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: const Duration(milliseconds: 700));
                  }
                },
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                    color: isHidePreviousButton
                        ? Colors.transparent
                        : Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  physics: currentIndex > _weekIndexOffset
                      ? const AlwaysScrollableScrollPhysics()
                      : CustomLockScrollPhysics(
                          parent: const AlwaysScrollableScrollPhysics(),
                          lockLeft: true),
                  controller: _controller,
                  onPageChanged: (int index) {
                    if (index == _weekIndexOffset) {
                      _controller.animateToPage(_weekIndexOffset,
                          curve: Curves.fastLinearToSlowEaseIn,
                          duration: const Duration(milliseconds: 700));
                    }
                    widget.callBackJumpToNextPage(_initialSelectedDay
                        .add(Duration(days: 7 * (index - _weekIndexOffset))));
                    currentIndex = index;
                    setState(() {
                      widget.callbackIndex(index);
                      _weeknumberInSwipe = convertDateToMMYYYY(
                          _initialSelectedDay.add(
                              Duration(days: 7 * (index - _weekIndexOffset))));
                      var currentDate = DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day);
                      var newDate = _initialSelectedDay
                          .add(Duration(days: 7 * (index - _weekIndexOffset)));
                      if (currentDate.isAfter(newDate) ||
                          currentDate.isSameDateAs(newDate)) {
                        isHidePreviousButton = true;
                      } else {
                        isHidePreviousButton = false;
                      }
                    });
                  },
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, weekIndex) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _weekdays(weekIndex - _weekIndexOffset),
                  ),
                ),
              ),
              InkWell(
                child: const Center(
                  child: Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 18,
                  ),
                ),
                onTap: () {
                  _controller.animateToPage(currentIndex + 1,
                      curve: Curves.fastLinearToSlowEaseIn,
                      duration: const Duration(milliseconds: 700));
                },
                // splashRadius: 17,
              ),
            ],
          ),
        )
      ],
    );
  }

  // Builds a 5 day list of DateButtons
  List<Widget> _weekdays(int weekIndex) {
    List<Widget> weekdays = [];

    for (int i = 0; i < widget.daysInWeek; i++) {
      final int offset = i + 1 - _initialSelectedDay.weekday;
      final int daysToAdd = weekIndex * 7 + offset;
      final DateTime dateTime =
          _initialSelectedDay.add(Duration(days: daysToAdd));
      weekdays.add(_dateButton(dateTime));
    }
    return weekdays;
  }

  Widget _dateButton(DateTime dateTime) {
    //to do
    final String weekday = widget.weekdays[dateTime.weekday - 1];
    final bool isSelected = dateTime.isSameDateAs(widget.selectedDay);

    var currentTime =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if (dateTime.isAfter(currentTime) || dateTime.isSameDateAs(currentTime)) {}
    return Expanded(
      child: GestureDetector(
        onTap: () {
          var currentTime = DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day);
          if (dateTime.isAfter(currentTime) ||
              dateTime.isSameDateAs(currentTime)) {
            _weeknumberInSwipe = convertDateToMMYYYY(dateTime);
            widget.changeDay(dateTime);
            setState(() {});
          }
        },
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text(
                  weekday,
                  style: typoSmallTextBold.copyWith(
                      color: dateTime.isBefore(currentTime)
                          ? colorGrey50
                          : isSelected
                              ? widget.selectedDigitColor
                              : widget.digitsColor),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                    color: dateTime.isSameDateAs(_todaysDateTime)
                        ? Colors.transparent
                        : Colors.transparent,
                    shape: BoxShape.circle),
                child: Text(
                  '${dateTime.day}',
                  style: typoSmallTextRegular.copyWith(
                      color: dateTime.isBefore(currentTime)
                          ? colorGrey50
                          : isSelected
                              ? widget.selectedDigitColor
                              : widget.digitsColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
