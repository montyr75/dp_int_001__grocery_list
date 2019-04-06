/*
 * Create a program that allows the user to add or remove items in a grocery list. The user
 * should also be able to view the list or quit the program. The list should be saved between
 * program executions.
 */

import "dart:io";
import "dart:convert";

const String DATA_FILE_PATH = "grocery_list.json";

List<String> groceryList;
File dataFile = File(DATA_FILE_PATH);

void main() {
  print("\n************");
  print("\nGROCERY LIST");
  print("\n************");

  // if data file exists, read it in and restore the list -- otherwise, start with an empty list
  groceryList = dataFile.existsSync() ? (jsonDecode(dataFile.readAsStringSync()) as List).cast<String>() : [];

  printList();
  printMenu();
}

void printMenu() {
  print("\n** MENU **"
    "\n(A)dd an item to the list"
    "\n(R)emove items from the list"
    "\n(S)how the list"
    "\n(Q)uit"
  );

  // get user input (not case sensitive)
  String input = stdin.readLineSync().toLowerCase();

  // handle menu selections
  switch (input) {
    case 'a': add(); break;
    case 'r': remove(); break;
    case 's': show(); break;
    case 'q': quit(); break;
    default:
      print("\nI don't know what the hell you're saying to me.");
      printMenu();
      break;
  }
}

void add() {
  print("\nEnter a grocery item to add to the list:");
  String groceryItem = stdin.readLineSync();
  groceryList.add(groceryItem);
  print("\n[$groceryItem] has been added to the list.");
  printMenu();
}

void remove() {
  int index;
  String strInput;
  bool inputError = false;

  if (groceryList.isEmpty) {
    print("\nThere are no items in the list.");
  }
  else {
    printList();
    print("\nEnter the number for the item you wish to remove (<ENTER> = cancel, * = all):");
    strInput = stdin.readLineSync();

    switch (strInput) {
      case "": break;
      case "*": groceryList.clear(); printList(); break;
      default:
        try {
          index = int.parse(strInput);
        }
        catch (e) {
          inputError = true;
        }

        if (!inputError && --index >= 0 && index < groceryList.length) {
          print("\n[${groceryList.removeAt(index)}] has been removed from the list.");
        }
        else {
          print("\nInvalid item number.");
        }
        break;
    }
  }

  printMenu();
}

void show() {
  printList();
  printMenu();
}

void printList() {
  print("\n** LIST (Items: ${groceryList.length}) **");

  for (int i = 0; i < groceryList.length; i++) {
    print("${i + 1}. ${groceryList[i]}");
  }
}

void quit() {
  print("\nGoodbye! Your data will be saved in $DATA_FILE_PATH.");

  // create or overwrite data file with current list
  dataFile.writeAsStringSync(jsonEncode(groceryList));
}