import 'package:http/http.dart' as http;

void fetchServerData() async {
  var url = Uri.parse('https://zw08kknv-3000.inc1.devtunnels.ms/data');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    print('Response from Node.js: ${response.body}');
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}
