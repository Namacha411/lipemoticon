import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef Char = String;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LipEmoticon',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'LipEmoticon'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ひらがなとカタカナの50音表
  static const List<List<String>> hiragana = [
    ['あ', 'い', 'う', 'え', 'お'],
    ['か', 'き', 'く', 'け', 'こ'],
    ['さ', 'し', 'す', 'せ', 'そ'],
    ['ざ', 'じ', 'ず', 'ぜ', 'ぞ'],
    ['た', 'ち', 'つ', 'て', 'と'],
    ['だ', 'ぢ', 'づ', 'で', 'ど'],
    ['な', 'に', 'ぬ', 'ね', 'の'],
    ['は', 'ひ', 'ふ', 'へ', 'ほ'],
    ['ば', 'び', 'ぶ', 'べ', 'ぼ'],
    ['ぱ', 'ぴ', 'ぷ', 'ぺ', 'ぽ'],
    ['ま', 'み', 'む', 'め', 'も'],
    ['や', '', 'ゆ', '', 'よ'],
    ['ら', 'り', 'る', 'れ', 'ろ'],
    ['わ', '', '', '', 'を'],
  ];
  static const List<List<String>> katakana = [
    ['ア', 'イ', 'ウ', 'エ', 'オ'],
    ['カ', 'キ', 'ク', 'ケ', 'コ'],
    ['ガ', 'ギ', 'グ', 'ゲ', 'ゴ'],
    ['サ', 'シ', 'ス', 'セ', 'ソ'],
    ['ザ', 'ジ', 'ズ', 'ゼ', 'ゾ'],
    ['タ', 'チ', 'ツ', 'テ', 'ト'],
    ['ダ', 'ヂ', 'ヅ', 'デ', 'ド'],
    ['ナ', 'ニ', 'ヌ', 'ネ', 'ノ'],
    ['ハ', 'ヒ', 'フ', 'ヘ', 'ホ'],
    ['バ', 'ビ', 'ブ', 'ベ', 'ボ'],
    ['パ', 'ピ', 'プ', 'ペ', 'ポ'],
    ['マ', 'ミ', 'ム', 'メ', 'モ'],
    ['ヤ', '', 'ユ', '', 'ヨ'],
    ['ラ', 'リ', 'ル', 'レ', 'ロ'],
    ['ワ', '', '', '', 'ヲ'],
  ];
  static const List<String> emoticon = [
    "('□' )", // あ
    "('ㅂ' )", // い
    "('ε' )", // う
    "('ㅂ' )", // え
    "('ﾛ' )", // お
    "('_' )", // ん
  ];

  String _convertedText = '';

  List<Set<String>> _tableColumns() {
    List<Set<String>> columns = List.generate(5, (_) => {});
    // ひらがなとカタカナの50音表を列ごとに分ける
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < hiragana.length; j++) {
        if (hiragana[j][i] != '') {
          columns[i].add(hiragana[j][i]);
        }
        if (katakana[j][i] != '') {
          columns[i].add(katakana[j][i]);
        }
      }
    }
    return columns;
  }

  String _toEmoticon(Char c) {
    var col = _tableColumns();
    final isJapanese = RegExp(r'[ぁ-ん]|[ァ-ン]');
    if (!isJapanese.hasMatch(c)) {
      return c;
    }
    for (int i = 0; i < 5; i++) {
      if (col[i].contains(c)) {
        return emoticon[i];
      }
    }
    return emoticon[5];
  }

  String _toEmoticons(String s) {
    String result = '';
    for (int i = 0; i < s.length; i++) {
      result += _toEmoticon(s[i]);
    }
    return result;
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: _convertedText));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                    "変換例: あいうえお → ('□' )('ㅂ' )('ε' )('ㅂ' )('ﾛ' )"), // 変換例
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (text) {
                    setState(() {
                      _convertedText = _toEmoticons(text);
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '変換元',
                  ),
                ),
                TextField(
                  readOnly: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '変換後',
                    suffixIcon: IconButton(
                      onPressed: _copyToClipboard,
                      icon: const Icon(Icons.copy),
                    ),
                  ),
                  controller: TextEditingController(text: _convertedText),
                )
              ],
            ),
          ),
        )
      );
  }
}
