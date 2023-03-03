import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List programList = [];
  List exerciseList = [];
  List selectedList = [];
  List editingList = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController desController = TextEditingController();

  TextEditingController nameEditController = TextEditingController();
  TextEditingController typeEditController = TextEditingController();
  TextEditingController desEditController = TextEditingController();

  TextEditingController exerciseController = TextEditingController();

  bool viewProgram = false;
  String selectedExercise = '';
  int selectedIndex = 0;

  Widget _verticalDivider = const VerticalDivider(
    color: Colors.grey,
    thickness: 0.5,
    width: 0.5,
  );

  void addProgram() async {
    if (nameController.text.isNotEmpty &&
        typeController.text.isNotEmpty &&
        desController.text.isNotEmpty) {
      Map data = {};
      data.addAll({
        "name": nameController.text,
        "type": typeController.text,
        "des": desController.text,
        "exes": []
      });

      setState(() {
        programList.add(data);
      });
      nameController.text = '';
      typeController.text = '';
      desController.text = '';
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill all the forms')));
    }
  }

  void editProgram(element) async {
    programList.removeAt(element);
    Map data = {};
    data.addAll({
      "name": nameEditController.text,
      "type": typeEditController.text,
      "des": desEditController.text,
      "exes": editingList
    });

    setState(() {
      programList.insert(element, data);
    });
    nameEditController.text = '';
    typeEditController.text = '';
    desEditController.text = '';

    Navigator.pop(context, true);
  }

  void deleteProgram(element) {
    setState(() {
      programList.removeAt(element);
    });

    Navigator.pop(context, true);
  }

  void deleteExercise(key) {
    setState(() {
      selectedList.removeAt(key);
    });
  }

  void deletePopup(element) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            child: Stack(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 25, bottom: 25, right: 25, left: 25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Delete Program',
                          style: TextStyle(fontSize: 20.0, color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Do you really want to delete the program?',
                          style: TextStyle(
                              fontFamily: 'OpenRegular',
                              fontSize: 16.0,
                              color: Colors.grey),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                textStyle: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                          Spacer(),
                          ElevatedButton(
                            child: Text('Delete'),
                            onPressed: () {
                              deleteProgram(element);
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                textStyle: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          );
        });
  }

  void addExercise() {
    exerciseList.add(exerciseController.text);
    exerciseController.text = '';
    Navigator.pop(context, true);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Exercise added successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return !viewProgram
        ? Scaffold(
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            ElevatedButton(
                              child: Text('Add Program'),
                              onPressed: () {
                                openAddDialog();
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Spacer(),
                            ElevatedButton(
                              child: Text('Add Exercise'),
                              onPressed: () {
                                openAddExercise();
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                        child: Text(
                          'Fitness Program List',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                        height: 0.5,
                      ),
                      programList.length > 0
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              child: DataTable(
                                columnSpacing: 0,
                                dividerThickness: 1,
                                columns: [
                                  DataColumn(
                                      label: Text('Name',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(label: _verticalDivider),
                                  DataColumn(
                                      label: Text('Type',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(label: _verticalDivider),
                                  DataColumn(
                                      label: Text('Description',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(label: _verticalDivider),
                                  DataColumn(
                                      label: Text('',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(label: _verticalDivider),
                                  DataColumn(
                                      label: Text('',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(label: _verticalDivider),
                                  DataColumn(
                                      label: Text('',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold))),
                                ],
                                rows:
                                    programList // Loops through dataColumnText, each iteration assigning the value to element
                                        .asMap()
                                        .entries
                                        .map(
                                          ((elem) => DataRow(
                                                cells: <DataCell>[
                                                  DataCell(Text(
                                                    elem.value['name']
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  )),
                                                  DataCell(_verticalDivider),
                                                  DataCell(Text(
                                                    elem.value['type']
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  )),
                                                  DataCell(_verticalDivider),
                                                  DataCell(SizedBox(
                                                    width: 60,
                                                    child: Text(
                                                      elem.value['des']
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  )),
                                                  DataCell(_verticalDivider),
                                                  DataCell(GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        nameEditController
                                                                .text =
                                                            elem.value['name'];
                                                        typeEditController
                                                                .text =
                                                            elem.value['type'];
                                                        desEditController.text =
                                                            elem.value['des'];
                                                        editingList =
                                                            elem.value['exec'];
                                                      });

                                                      openEditDialog(elem.key);
                                                    },
                                                    child: Text(
                                                      'Edit',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )),
                                                  DataCell(_verticalDivider),
                                                  DataCell(GestureDetector(
                                                    onTap: () {
                                                      deletePopup(elem.key);
                                                    },
                                                    child: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )),
                                                  DataCell(_verticalDivider),
                                                  DataCell(
                                                    Center(
                                                        child: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          selectedList = elem
                                                              .value['exes'];
                                                          selectedIndex =
                                                              elem.key;
                                                        });
                                                        setState(() {
                                                          viewProgram = true;
                                                        });
                                                      },
                                                      icon: Icon(
                                                          Icons.arrow_forward),
                                                    )),
                                                  )
                                                ],
                                              )),
                                        )
                                        .toList(),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                              child: Text(
                                'No Programs added yet',
                                style:
                                    TextStyle(fontSize: 15, color: Colors.red),
                              ),
                            ),
                      Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                        height: 0.5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Add Exercise'),
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    viewProgram = false;
                  });
                },
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton(
                        underline: SizedBox(),
                        hint: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text(
                            "Select exercise to add",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                        isExpanded: true,
                        icon: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: const Icon(Icons.keyboard_arrow_down),
                        ),
                        onChanged: (map) {
                          setState(() {
                            selectedExercise = map.toString();
                          });
                          if (selectedList.contains(selectedExercise)) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Exercise Already exist')));
                          } else {
                            setState(() {
                              selectedList.add(selectedExercise);
                              programList[selectedIndex]['exec'] = selectedList;
                            });
                          }
                        },
                        items: exerciseList
                            .map((e) => DropdownMenuItem(
                                  alignment: AlignmentDirectional.center,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 10, 10, 10),
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Text(
                                            e,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.grey,
                                          thickness: 0.5,
                                          height: 0.5,
                                        )
                                      ],
                                    ),
                                  ),
                                  value: e,
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Text(
                      'Exercise List',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                    height: 0.5,
                  ),
                  selectedList.length > 0
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          child: DataTable(
                            columnSpacing: 0,
                            dividerThickness: 1,
                            columns: [
                              DataColumn(
                                  label: Text('Exercise Name',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(label: _verticalDivider),
                              DataColumn(
                                  label: Text('',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold))),
                            ],
                            rows: selectedList
                                .asMap()
                                .entries
                                .map(
                                  ((element) => DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text(
                                            element.value,
                                            style: TextStyle(fontSize: 12),
                                          )),
                                          DataCell(_verticalDivider),
                                          DataCell(GestureDetector(
                                            onTap: () {
                                              deleteExercise(element.key);
                                            },
                                            child: Text(
                                              'Delete',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                        ],
                                      )),
                                )
                                .toList(),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                          child: Text(
                            'No Exercise added to this program',
                            style: TextStyle(fontSize: 15, color: Colors.red),
                          ),
                        ),
                  Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                    height: 0.5,
                  ),
                ],
              ),
            ),
          );
  }

  void openAddExercise() async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Center(
                child: Text(
                  'Add Exercise',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 15, 5, 55),
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            controller: exerciseController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              labelText: 'Exercise Name',
                              hintText: 'Exercise Name',
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                //uniqueController
                              });
                            },
                          ),
                        ),
                      ),
                      ElevatedButton(
                        child: Text('Add Now'),
                        onPressed: () {
                          addExercise();
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  void openAddDialog() async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Center(
                child: Text(
                  'Add Program',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.55,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 15, 5, 5),
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              labelText: 'Program Name',
                              hintText: 'Program Name',
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                //uniqueController
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 15, 5, 5),
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            controller: typeController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              labelText: 'Program Type',
                              hintText: 'Program Type',
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                //uniqueController
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 15, 5, 5),
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  desController.text = value.toString();
                                });
                              },
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Description',
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        child: Text('Add Now'),
                        onPressed: () {
                          addProgram();
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  void openEditDialog(element) async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Center(
                child: Text(
                  'Edit Program',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.45,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            controller: nameEditController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              labelText: 'Program Name',
                              hintText: 'Program Name',
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                //uniqueController
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            controller: typeEditController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              labelText: 'Program Type',
                              hintText: 'Program Type',
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                //uniqueController
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            controller: desEditController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              labelText: 'Program Description',
                              hintText: 'Program Description',
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        child: Text('Update'),
                        onPressed: () {
                          editProgram(element);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }
}
