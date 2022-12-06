import 'package:flutter/material.dart';
import 'Employee.dart';
import 'Services.dart';

// šis ir no liked 50 minūsu mobile programmer video

class DataTableDemo extends StatefulWidget {
  //
  DataTableDemo() : super();
  final String title = 'Flutter Data Table';

  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<DataTableDemo> {
  late List<Employee> _employees;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late TextEditingController
      _in_useController; // controller for the First Name TextField we are going to create
  late TextEditingController
      _locationController; // controller for the Last Name TextField we are going to create
  late Employee _selectedEmployee;
  late bool _isUpdating;
  late String _titleProgress;

  @override
  void initState() {
    super.initState();
    _employees = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to shoq a SnackBar
    _in_useController = TextEditingController();
    _locationController = TextEditingController();
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

/*
  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
*/
  _addEmployee() {
    if (_in_useController.text.isEmpty || _locationController.text.isEmpty) {
      print('Empty Fields');
      return;
    }
    //_showProgress('Adding Employee...');
    _showProgress(widget.title);
    print('-- 1');
    print('in_use_cntrl:');
    print(_in_useController.text);
    print('location_cntrl:');
    print(_locationController.text);
    Services.addEmployee(_in_useController.text, _locationController.text)
        .then((result) {
      if ('success' == result) {
        print('Augšupielādējās uz datu bāzi');
      }
      _clearValues();
    });
  }

  _getEmployees() {
    Services.getEmployees().then((employees) {
      setState(() {
        _employees = employees;
      });
      _showProgress(widget.title);
      print("Length: ${employees.length}");
    });
  }

/*
  _updateEmployee(Employee employee) {
    setState(() {
      _isUpdating = true;
    });
    Services.updateEmployee(
            employee.id_no, _in_useController.text, _locationController.text)
        .then((result) {
      if ('success' == result) {
        _getEmployees();
        setState(() {
          _isUpdating = false;
        });
        _clearValues();
      }
    });
  }
*/
  _deleteEmployee() {}

  // Method to clear TextField values
  _clearValues() {
    _in_useController.text = '';
    _locationController.text = '';
  }

/*
  // DataTable with employee list in it
  SingleChildScrollView _dataBody() {
    return SingleChildScrollView(
      scrollDirection:  Axis.vertical,
      child: SingleChildScrollView(scrollDirection: Axis.horizontal,child: DataTable(
        columns: [
          DataColumn(label: Text('ID'),)
        ], rows: [_employees.map()],
      ),),
    );
  }
*/
//---------------------------------------------------------------------------
  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress), // we show progress in the title
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _getEmployees();
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _in_useController,
                decoration: InputDecoration.collapsed(
                  hintText: 'In_use',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _locationController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Location',
                ),
              ),
            ),
            // Add an update button and a cancel button
            // show these buttons only when updating an employee
            _isUpdating
                ? Row(
                    children: <Widget>[
                      OutlinedButton(
                        child: Text('Update'),
                        onPressed: () {
                          // _updateEmployee();
                        },
                      ),
                      OutlinedButton(
                        child: Text('CANCEL'),
                        onPressed: () {
                          setState(() {
                            _isUpdating = false;
                          });
                          _clearValues();
                        },
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('-- 2');
          _addEmployee();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
