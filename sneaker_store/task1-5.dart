void main() {

  // // task-1

  // for (int digit = 1; digit <= 10; digit++) {
  //   for (int i = 1; i <= 10; i++) {
  //     print("$digit * $i = ${digit * i}");
  //   }
  // }


  // // task-2

  // bool isLeapYear(int year) {
  //   return year % 400 == 0 || (year % 4 == 0 && year % 100 != 0);
  // }

  // int daysInMonth(int month, int year) {
  //   if (month == 2) {
  //     return isLeapYear(year) ? 29 : 28;
  //   }

  //   if (month == 4 || month == 6 || month == 9 || month == 11) {
  //     return 30;
  //   }

  //   return 31;
  // }

  // bool isValidDate(int day, int month, int year) {
  //   if (month < 1 || month > 12) {
  //     return false;
  //   }

  //   int maxDay = daysInMonth(month, year);

  //   return day >= 1 && day <= maxDay;
  // }

  // String nextDay(int day, int month, int year) {
  //   if (!isValidDate(day, month, year)) {
  //     return 'Invalid date';
  //   }

  //   int maxDay = daysInMonth(month, year);

  //   if (day < maxDay) {
  //     day++;
  //   } else {
  //     day = 1;

  //     if (month < 12) {
  //       month++;
  //     } else {
  //       month = 1;
  //       year++;
  //     }
  //   }

  //   return '$day.$month.$year';
  // }

  // print(nextDay(5, 9, 2026));
  // print(nextDay(28, 2, 2024));
  // print(nextDay(28, 2, 2026));
  // print(nextDay(29, 2, 2026));
  // print(nextDay(31, 12, 2025));


  // // task-3

  // int countVowels(String text) {
  //   int count = 0;

  //   for (int i = 0; i < text.length; i++) {
  //     String letter = text[i].toLowerCase();

  //     if ('aeiou'.contains(letter)) {
  //       count++;
  //     }
  //   }

  //   return count;
  // }

  // print(countVowels("flutter mobile development"));


  // // task-4

  // List<int> numbers = [14, 88, 3, 42, 99, 12, 67];
  // List<int> numbers1 = [234, 34, 123, 44, 949, 112, 67];

  // void findMinMax(List<int> numbers) {
  //   int min = numbers[0];
  //   int max = numbers[0];

  //   for (int i = 1; i < numbers.length; i++) {
  //     if (numbers[i] < min) {
  //       min = numbers[i];
  //     }

  //     if (numbers[i] > max) {
  //       max = numbers[i];
  //     }
  //   }

  //   print('min: $min');
  //   print('max: $max');
  // }

  // findMinMax(numbers);
  // findMinMax(numbers1);


  // task-5

  bool isPrime(int number) {
    if (number < 2) {
      return false;
    }

    for (int i = 2; i < number; i++) {
      if (number % i == 0) {
        return false;
      }
    }

    return true;
  }

  print(isPrime(3));
  print(isPrime(6));
}