import 'package:gpteacher/utilis/decoder.dart';

final OPENAI_KEY = decoder(const String.fromEnvironment('OPENAI_KEY'));
final PINECONE_KEY = decoder(const String.fromEnvironment('PINECONE_KEY'));
