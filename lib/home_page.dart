import 'package:currency_convertor_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:currency_convertor_app/helper/currency_api_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Currency?> getData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData = CurrencyAPIHelper.apiHelper.fetchcurrencies();
  }

  TextEditingController amountController = TextEditingController();

  String dropdownValue1 = 'INR';
  String dropdownValue2 = 'USD';
  String answer = 'Converted Currency will be shown here :)';
  List history = [];

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return (isIos == false)
        ? Scaffold(
      appBar: AppBar(
        leading: Switch(
          value: isIos,
          onChanged: (val) {
            setState(() {
              isIos = val;
            });
          },
          activeColor: Colors.black,
        ),
        centerTitle: true,
        title: const Text("Currency Convertor"),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Center(
                        child: Text("Recent search"),
                      ),
                      content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: history
                              .map(
                                (e) => GestureDetector(
                              child: Row(
                                children: [
                                  Text(e),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop();
                                        int i = e.indexOf(e);
                                        setState(() {
                                          history.removeAt(i);
                                        });
                                      },
                                      icon: const Icon(
                                          Icons.cancel_outlined))
                                ],
                              ),
                            ),
                          )
                              .toSet()
                              .toList()),
                    ));
              },
              icon: const Icon(Icons.history))
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: FutureBuilder(
          future: getData,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error : ${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              Currency? data = snapshot.data;

              return Column(
                children: [
                  Icon(
                    CupertinoIcons.money_dollar_circle,
                    size: 100,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Convert Any Currency',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: amountController,
                            decoration: const InputDecoration(
                                hintText: 'Enter Amount'),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButton<String>(
                                  value: dropdownValue1,
                                  icon: const Icon(
                                      Icons.arrow_drop_down_rounded),
                                  iconSize: 24,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue1 = newValue!;
                                    });
                                  },
                                  items: data?.allRates.keys
                                      .toSet()
                                      .toList()
                                      .map<DropdownMenuItem<String>>(
                                          (value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20),
                                child: const Icon(Icons.compare_arrows),
                              ),
                              Expanded(
                                child: DropdownButton<String>(
                                  value: dropdownValue2,
                                  icon: const Icon(
                                      Icons.arrow_drop_down_rounded),
                                  iconSize: 24,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue2 = newValue!;
                                    });
                                  },
                                  items: data!.allRates.keys
                                      .toSet()
                                      .toList()
                                      .map((e) {
                                    return DropdownMenuItem<String>(
                                      value: e,
                                      child: Text(e),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              String op =
                              (double.parse(amountController.text) /
                                  data.allRates[dropdownValue1]!
                                      .toDouble() *
                                  data.allRates[dropdownValue2]!)
                                  .toStringAsFixed(2);
                              setState(() {
                                answer =
                                '${amountController.text} $dropdownValue1  = $op  $dropdownValue2';
                              });
                              history.add(answer);
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                MaterialStateColor.resolveWith(
                                        (states) => Colors.pink)),
                            child: const Text('Convert'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              answer,
                              style: const TextStyle(fontSize: 19),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.pink,
              ),
            );
          },
        ),
      ),
    )
        : CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoSwitch(
          value: isIos,
          onChanged: (val) {
            setState(() {
              isIos = val;
            });
          },
        ),
        middle: const Text(
          "Currency Covertor",
          style: TextStyle(
              color: CupertinoColors.white,
              fontSize: 20,
              letterSpacing: 1),
        ),
        trailing: GestureDetector(
          child: Icon(Icons.history, color: CupertinoColors.white),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Center(
                    child: Text("Recent search"),
                  ),
                  content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: history
                          .map(
                            (e) => GestureDetector(
                          child: Row(
                            children: [
                              Text(e),
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    int i = e.indexOf(e);
                                    setState(() {
                                      history.removeAt(i);
                                    });
                                  },
                                  icon:
                                  Icon(Icons.cancel_outlined))
                            ],
                          ),
                        ),
                      )
                          .toSet()
                          .toList()),
                ));
          },
        ),
        backgroundColor: CupertinoColors.systemPink,
      ),
      child: Container(
        margin: const EdgeInsets.all(10),
        child: FutureBuilder(
          future: getData,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error : ${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              Currency? data = snapshot.data;

              return Column(
                children: [
                  Icon(
                    CupertinoIcons.money_dollar_circle,
                    size: 100,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    elevation: 5,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Convert Any Currency',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ),
                          const SizedBox(height: 30),
                          CupertinoTextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            placeholder: "Enter Amount",
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    showCupertinoModalPopup(
                                        context: context,
                                        builder: (_) => SizedBox(
                                          width:
                                          MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.60,
                                          height: 250,
                                          child: CupertinoPicker(
                                            backgroundColor:
                                            Colors.white,
                                            itemExtent: 30,
                                            children: data!
                                                .allRates.keys
                                                .toSet()
                                                .toList()
                                                .map((e) {
                                              return DropdownMenuItem<
                                                  String>(
                                                value: e,
                                                child: Text(e),
                                              );
                                            }).toList(),
                                            onSelectedItemChanged:
                                                (value) {
                                              setState(() {
                                                dropdownValue1 = data
                                                    .allRates.keys
                                                    .elementAt(value);
                                              });
                                            },
                                          ),
                                        ));
                                  },
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Colors.black,
                                          width: 0.1),
                                    ),
                                    child: Text(
                                      "  ${dropdownValue1}",
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20),
                                child: const Icon(
                                  CupertinoIcons.arrow_right_arrow_left,
                                  color: CupertinoColors.black,
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    showCupertinoModalPopup(
                                        context: context,
                                        builder: (_) => SizedBox(
                                          width:
                                          MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.60,
                                          height: 250,
                                          child: CupertinoPicker(
                                            backgroundColor:
                                            Colors.white,
                                            itemExtent: 30,
                                            children: data!
                                                .allRates.keys
                                                .toSet()
                                                .toList()
                                                .map((e) {
                                              return DropdownMenuItem<
                                                  String>(
                                                value: e,
                                                child: Text(e),
                                              );
                                            }).toList(),
                                            onSelectedItemChanged:
                                                (value) {
                                              setState(() {
                                                dropdownValue2 = data
                                                    .allRates.keys
                                                    .elementAt(value);
                                              });
                                            },
                                          ),
                                        ));
                                  },
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Colors.black,
                                          width: 0.1),
                                    ),
                                    child: Text(
                                      "  ${dropdownValue2}",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          CupertinoButton(
                            color: CupertinoColors.systemPink,
                            onPressed: () {
                              String op =
                              (double.parse(amountController.text) /
                                  data!.allRates[dropdownValue1]!
                                      .toDouble() *
                                  data.allRates[dropdownValue2]!)
                                  .toStringAsFixed(2);
                              setState(() {
                                answer =
                                '${amountController.text} $dropdownValue1  = $op  $dropdownValue2';
                              });
                              history.add(answer);
                            },
                            child: const Text('Convert'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              answer,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.pink,
              ),
            );
          },
        ),
      ),
    );
  }
}