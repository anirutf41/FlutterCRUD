import 'package:flutter/material.dart';
import 'Employees.dart';
import 'Services.dart';

class DataTableDemo extends StatefulWidget {
  DataTableDemo() : super();
  final String title = 'Flutter Data Table';
  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<DataTableDemo> {
  List<Employee> _employees;
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _firstNameComtroller;
  TextEditingController _lastNameComtroller;
  Employee _selectedEmployee;
  bool _isUpdateing;
  String _titleProgress;

  @override
  void initState() {
    super.initState();
    _employees = [];
    _isUpdateing = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey();
    _firstNameComtroller = TextEditingController();
    _lastNameComtroller = TextEditingController();
    _getEmployee();
  }

  // Method update title appbar
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _createTable() {
    _showProgress('Creating Table...');
    Services.createTable().then((result) {
      if ('success' == result) {
        _showSnackBar(context, result);
        _showProgress(widget.title);
      } else {
        _showSnackBar(context, result);
        _showProgress(widget.title);
      }
    });
  }

  _addEmployee() {
    if (_firstNameComtroller.text.isEmpty || _lastNameComtroller.text.isEmpty) {
      print("Empty Fields");
      return;
    }
    _showProgress('Adding Employee...');
    Services.addEmployee(_firstNameComtroller.text, _lastNameComtroller.text)
        .then((result) {
      if ('success' == result) {
        _getEmployee();
        _clearValues();
      }
    });
  }

  _getEmployee() {
    _showProgress('Loading Employee...');
    Services.getEmployees().then((employee) {
      setState(() {
        _employees = employee;
      });
      _showProgress(widget.title);
      print("Length ${employee.length}");
    });
  }

  _updateEmployee(Employee employee) {
    setState(() {
      _isUpdateing = true;
    });
    _showProgress('Updating Employee...');
    Services.updateEmployee(
            employee.id, _firstNameComtroller.text, _lastNameComtroller.text)
        .then((result) {
      if ('success' == result) {
        _getEmployee();
        setState(() {
          _isUpdateing = false;
        });
      }
    });
    _clearValues();
  }

  _daleteEmployee(Employee employee) {
    _showProgress("Deleting Employee...");
    Services.daleteEmployee(employee.id).then((result) {
      if ('success' == result) {
        _getEmployee();
      }
    });
  }

  // Method to clear textfield
  _clearValues() {
    _firstNameComtroller.text = "";
    _lastNameComtroller.text = "";
  }

  _showValues(Employee employee) {
    _firstNameComtroller.text = employee.firstName;
    _lastNameComtroller.text = employee.lastName;
  }

  // + and show
  SingleChildScrollView _dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('ID'),
            ),
            DataColumn(
              label: Text('FIRST NAME'),
            ),
            DataColumn(
              label: Text('LAST NAME'),
            ),
            DataColumn(
              label: Text("DALETE"),
            ),
          ],
          rows: _employees
              .map(
                (employee) => DataRow(cells: [
                  DataCell(Text(employee.id), onTap: () {
                    _showValues(employee);
                    _selectedEmployee = employee;
                    setState(() {
                      _isUpdateing = true;
                    });
                  }),
                  DataCell(
                    Text(
                      employee.firstName.toUpperCase(),
                    ),
                    onTap: () {
                      _showValues(employee);
                      _selectedEmployee = employee;
                      setState(() {
                        _isUpdateing = true;
                      });
                    },
                  ),
                  DataCell(
                    Text(
                      employee.lastName.toUpperCase(),
                    ),
                    onTap: () {
                      _showValues(employee);
                      _selectedEmployee = employee;
                      setState(() {
                        _isUpdateing = true;
                      });
                    },
                  ),
                  DataCell(IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _daleteEmployee(employee);
                    },
                  ))
                ]),
              )
              .toList(),
        ),
      ),
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _createTable();
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _getEmployee();
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
                controller: _firstNameComtroller,
                decoration: InputDecoration.collapsed(
                  hintText: 'First Name',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _lastNameComtroller,
                decoration: InputDecoration.collapsed(
                  hintText: 'Last Name',
                ),
              ),
            ),
            // add an update
            _isUpdateing
                ? Row(
                    children: <Widget>[
                      OutlineButton(
                        child: Text('UPDATE'),
                        onPressed: () {
                          _updateEmployee(_selectedEmployee);
                        },
                      ),
                      OutlineButton(
                        child: Text('CANCEL'),
                        onPressed: () {
                          setState(() {
                            _isUpdateing = false;
                          });
                          _clearValues();
                        },
                      ),
                    ],
                  )
                : Container(),
            Expanded(
              child: _dataBody(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addEmployee();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
