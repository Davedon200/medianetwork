import 'package:logger/web.dart';

class WebUtils {
  static Logger getLogger(String className) {
    return Logger(printer: SimpleLogPrinter(className));
  }
}

class SimpleLogPrinter extends LogPrinter {
  final String className;

  SimpleLogPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    final levelColors = {
      Level.trace: 37,
      Level.debug: 36,
      Level.info: 32,
      Level.warning: 33,
      Level.error: 45,
      Level.fatal: 35,
    };

    final levelEmojis = {
      Level.trace: '🔍',
      Level.debug: '🛠️',
      Level.info: 'ℹ️',
      Level.warning: '⚠️',
      Level.error: '❌',
      Level.fatal: '🤷',
    };

    final emoji = levelEmojis[event.level] ?? '';
    final color = levelColors[event.level] ?? 0;
    final coloredMessage =
        '\x1B[38;5;${color}m :::: <$className> :::: ${event.message}\x1B[0m';

    print('$emoji $coloredMessage');
    return [];
  }
}
