/**
 * Author: Ilamah, Osho
 * 
 * 2020.11.29  - Created
 * 2020.12.02  - Basic functionality completed | Added support for command line args
 * 2020.12.04  - Improved command line support implementation, including use of defaults
 */

import 'models/models.dart';
import 'data/datasource.dart';

import 'dart:io';
import 'package:args/args.dart';

ArgResults args;

DataSource<Item> itemDataSource;

void main(List<String> arguments) {
  //deal with the command line args ||  --file=filename --report | --file filename --report | -f=filename -r | -f filename -r | can also use --no-report
  final ArgParser cliParser = new ArgParser()
    ..addOption('file', abbr: 'f', help: 'The input data file', defaultsTo: 'Dart_Vending_Machine.csv')
    ..addFlag('report', abbr: 'r', help: 'Save transaction reports', defaultsTo: false);

  args = cliParser.parse(arguments);

  print(args['file']);

  print(args['report']);

  print('');

  print(cliParser.usage);

  final dataFile = new File(args['file']);

  List<String> data;

  // myFile.readAsLines().then((data) {
  //   startMachine(data);
  // }, onError: (error) {
  //   print('${error.toString()}');
  // });

  try {
    data = dataFile.readAsLinesSync();
  } on FileSystemException catch (e) {
    print('Exception in file read:\n${e.toString()}');
    return;
  }

  itemDataSource = new MemoryMapItemDataSource();
  data.map(getItemFromString).forEach((item) {
    item.inventoryQuantity = 5; //max per slot
    itemDataSource.add(item);
    //print(item);
  });

  print('******************************************************************');
  print('***************** Vendo-Matic 800 Vending Machine ****************');
  print('******************************************************************');
  print('******************************************************************\n');
  int showMainMenuOption = 0;
  double moneyAvailable = 0;
  Map<Item, int> selectedItems = {};

  while (showMainMenuOption != 3) {
    showMainMenuOption = showMenu(mainMenuMessage);
    switch (showMainMenuOption) {
      case 1: //display vending machine items
        print('\n%%%%%%% Vending Machine Inventory::');
        itemDataSource.readAll().forEach((item) {
          print(item);
        });
        print('\n');
        break;
      case 2: //purchase items
        //print('\n%%%%%%% Vending Machine Purchase::');
        int showPurchaseMenuOption = 0;
        while (showPurchaseMenuOption != 3) {
          showPurchaseMenuOption = showMenu(purchaseMenuMessage);
          print('\nCurrent money provided: $moneyAvailable\n');
          switch (showPurchaseMenuOption) {
            case 1:
              //feed money in
              moneyAvailable += addMoney();
              break;
            case 2:
              //select product
              selectProduct(selectedItems, moneyAvailable);
              break;
            case 3:
              //finalize transaction
              if (selectedItems.isNotEmpty) {
                print('\n%%%%%%% Vending Machine <Selected Items> ::');
                selectedItems.forEach((key, value) {
                  print('x$value | $key ');
                });
              }
              int showFinalizeMenuOption = showMenu(finishMenuMessage);
              if (showFinalizeMenuOption == 3) {
                //continue option
                print('\n');
              } else {
                if (showFinalizeMenuOption == 2) {
                  //cancel transaction
                  selectedItems.clear();
                }
                //finish/cancel the transaction
                finishTransaction(selectedItems, moneyAvailable);
                moneyAvailable = 0;
                selectedItems.clear();
                showPurchaseMenuOption = 3;
                showMainMenuOption = 3;
              }
          }
        }
        break;
      case 3: //exit
        if (selectedItems.isNotEmpty || moneyAvailable > 0) {
          print('\n\nPlease use the Purchase menu option to finish or cancel your transaction\n\n');
          showMainMenuOption = 0;
        }
    }
  }
}

int showMenu(String message) {
  stdout.write(message);
  int menuOption = 0;
  try {
    menuOption = int.parse(stdin.readLineSync());
  } on FormatException {
    print('Invalid main option. Please enter a valid menu option from the available choices');
  }
  return menuOption;
}

int addMoney() {
  stdout.write('\n%%%%%%% Vending Machine <Add Money> ::\nPlease add 1, 2, 5, or 10 dollars\n\nUser Input: ');
  int amount = 0;
  bool valid = false;
  try {
    amount = int.parse(stdin.readLineSync());
    switch (amount) {
      case 1:
      case 2:
      case 5:
      case 10:
        valid = true;
    }
  } on FormatException {
    print('Invalid main option. Please enter a valid menu option from the available choices');
  }
  return valid ? amount : 0;
}

void finishTransaction(Map<Item, int> selectedItems, double moneyAvailable) {
  double balance = getCreditBalance(selectedItems, moneyAvailable);
  int hasChange = 0, hasItems = 0;
  //dispense
  if (moneyAvailable > 0) {
    print('\n\n%%%%%%% Vending Machine <Money Dispense> ::');
    print('Dispensing your $balance ${selectedItems.isEmpty ? 'refund' : 'change'}');
    hasChange = 1;
  }
  if (selectedItems.isNotEmpty) {
    print('\n\n%%%%%%% Vending Machine <Item Dispense> ::');
    print('Dispensing your items . . . .');
    //update inventory
    selectedItems.forEach((key, qty) {
      final item = itemDataSource.read(key.id);
      if (item != null) {
        item.inventoryQuantity = item.inventoryQuantity - qty;
        print(' {$qty}x ${item.name}!');
      }
    });
    hasItems = 4;
  }

  int hasChangeAndItems = hasItems + hasChange;

  switch (hasChangeAndItems) {
    case 0: // no items or money
    case 1: // no items but with money refund
      print('\nThanks for stopping by, come back soon!');
      break;
    case 4: //items but no change
      print('Items dispensed!\nThanks for the purchase! Enjoy!');
      break;
    case 5:
      print('Items and change dispensed!\nThanks for the purchase! Enjoy!');
  }
}

void selectProduct(Map<Item, int> selectedItems, double moneyAvailable) {
  stdout.write('\n%%%%%%% Vending Machine <Select Product> ::\nPlease enter the desired item code\n\nUser Input: ');
  String slot = stdin.readLineSync().toUpperCase();
  //https://stackoverflow.com/a/50523049
  Item selectedItem = itemDataSource.readAll().firstWhere((item) => item.slot == slot, orElse: () => null);
  if (selectedItem != null) {
    int alreadySelectedQuantity = selectedItems.containsKey(selectedItem) ? selectedItems[selectedItem] : 0;
    if ((selectedItem.inventoryQuantity - alreadySelectedQuantity) < 1) {
      //quantity too low
      print('Item $slot | ${selectedItem.name} is SOLD out');
    } else {
      final creditBalance = getCreditBalance(selectedItems, moneyAvailable);
      if (creditBalance < selectedItem.price) {
        print('Item $slot | ${selectedItem.name} | price exceeds remaning money balance: $creditBalance');
      } else {
        selectedItems.update(selectedItem, (qty) => qty + 1, ifAbsent: () => 1);
      }
    }
  }
}

double getCreditBalance(Map<Item, int> selectedItems, double moneyAvailable) {
  double cost = 0;
  selectedItems.forEach((item, quantity) {
    cost += (item.price * quantity);
  });
  return moneyAvailable - cost;
}

Item getItemFromString(String dataString) {
  List<String> itemData = dataString.split('|');
  final String slot = itemData[0];
  final String name = itemData[1];
  final double price = double.tryParse(itemData[2]);
  final String category = itemData[3];

  Item i = new Item(slot, name, price, category);

  return i;
}

const mainMenuMessage = '''
Please choose from the following menu options:
   (1) Display Vending Machine Items
   (2) Purchase
   (3) Exit
User Input: ''';

const purchaseMenuMessage = '''

Please choose from the following menu options:
   (1) Feed Money
   (2) Select Product
   (3) Manage Transaction
User Input: ''';

const finishMenuMessage = '''

Please choose from the following menu options:
   (1) Finish
   (2) Cancel
   (3) Continue
User Input: ''';

// // readline.dart
// //
// // Demonstrates a simple command-line interface that does not require line
// // editing services from the shell.

// import 'dart:io';

// import 'package:dart_console/dart_console.dart'; //https://github.com/timsneath/dart_console  https://pub.dev/packages/dart_console

// final console = Console();

// const prompt = '>>> ';

// // Inspired by
// // http://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html#writing-a-command-line
// // as a test of the Console class capabilities

// void main() {
//   console.write('The ');
//   console.setForegroundColor(ConsoleColor.brightYellow);
//   console.write('Console.readLine()');
//   console.resetColorAttributes();
//   console.writeLine(' method provides a basic readline implementation.');

//   console.write('Unlike the built-in ');
//   console.setForegroundColor(ConsoleColor.brightYellow);
//   console.write('stdin.readLineSync()');
//   console.resetColorAttributes();
//   console.writeLine(' method, you can use arrow keys as well as home/end.');
//   console.writeLine();

//   console.writeLine('As a demo, this command-line reader "shouts" all text '
//       'back in upper case.');
//   console.writeLine('Enter a blank line or press Ctrl+C to exit.');

//   while (true) {
//     console.write(prompt);
//     final response = console.readLine(cancelOnBreak: true);
//     if (response == null || response.isEmpty) {
//       exit(0);
//     } else {
//       console.writeLine('YOU SAID: ${response.toUpperCase()}');
//       console.writeLine();
//     }
//   }
// }
