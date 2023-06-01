import 'dart:convert';

String decoder(String value) {
  if (value.length < 60) return value;
  return utf8.decode(base64.decode(value));
}
