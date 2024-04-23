import 'package:http/http.dart' as http;

/// Fetches server data from the specified URL.
///
/// Makes an HTTP GET request to the given URL and prints the response body if the request is successful.
/// If the request fails, it prints the status code.
void fetchServerData() async {
  var url = Uri.parse(
      'https://zw08kknv-3000.inc1.devtunnels.ms/data'); //TODO: Replace URL with cloud server URL
  var response = await http.get(url);
  if (response.statusCode == 200) {
    print('Response from Node.js: ${response.body}');
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}
