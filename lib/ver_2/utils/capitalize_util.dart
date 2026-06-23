class CapitalizeUtil {
  static String capitalize({required String text, bool allWords = false}) {
    List<String> words = [];
    if (allWords) {
      words = text.split(' ');
    } else {
      words = [text];
    }

    return words
        .map(
          (word) => word.isEmpty
              ? word
              : "${word[0].toUpperCase()}${word.substring(1).toLowerCase()}",
        )
        .join(' ');
  }
}
