// class ReusableButton extends StatelessWidget {
//   final String text; // Button text (property)
//   final Function onPressed; // Callback function (property)
//
//   const ReusableButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       onPressed: onPressed,
//       child: Text(text),
//     );
//   }
// }
//
// ElevatedButton(
// onPressed: () => print('Clicked!'),
// child: ReusableButton(text: 'Click Me', onPressed: () => print('Clicked!')),
// ),
