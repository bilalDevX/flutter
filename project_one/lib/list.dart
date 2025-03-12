void main() {
  var colors = ['pink', 'blue', 'light green'];

  print(colors[0]);  // Output: pink
  print(colors[1]);  // Output: blue
  print(colors[2]);  // Output: light green

  List<int> numbers = [1, 2, 3, 4, 5];
  List<String> colorList = ['red', 'green', 'blue'];
  List<dynamic> items = [1, 'hello', 3.14];

  print(colorList); // Output: [red, green, blue]
  print(items); // Output: [1, hello, 3.14]
  print(numbers); // Output: [1, 2, 3, 4, 5]

  colorList.add('yellow');
  print(colorList);  // Output: [red, green, blue, yellow]

  print(colorList.first);  // Output: red
  print(colorList.last);  // Output: yellow
  print(colorList.length);  // Output: 4
  print(colorList.reversed);  // Output: (yellow, blue, green, red)
 
  print(colorList.isEmpty);  // Output: false
  print(colorList.isNotEmpty);  // Output: true

  print(colorList.indexOf('green'));  // Output: 1
  print(colorList.runtimeType);  // Output: List<String>
 
  print(colorList.removeAt(1));  // Output: green
  print(colorList);  // Output: [red, blue, yellow]
 
  print(colorList.remove('blue'));  // Output: true also removes the element
  print(colorList);  // Output: [red, yellow]

  print(colorList.removeLast());  // Output: yellow
  print(colorList);  // Output: [red]

  colorList.add('red');
  colorList.add('green');
  colorList.add('blue');

  colorList.insert(1, 'black');

  print(colorList);  // Output: [red, black, red, green, blue]

  colorList.insertAll(2, ['yellow', 'white']);
  print(colorList);  // Output: [red, black, yellow, white, red, green, blue]

  colorList.clear();
  print(colorList);  // Output: []

}