class FontStyleModel {
  final String name;
  final String identifier;
  final String sample;
  final String Function(String) transform;

  FontStyleModel({
    required this.name,
    required this.identifier,
    required this.sample,
    required this.transform,
  });
}

class FontsData {
  static const String _normalLower = 'abcdefghijklmnopqrstuvwxyz';
  static const String _normalUpper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _normalDigits = '0123456789';

  static String _transformText(
    String input,
    String lowerMap,
    String upperMap,
    String digitMap,
  ) {
    StringBuffer result = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      String char = input[i];
      int lowerIdx = _normalLower.indexOf(char);
      if (lowerIdx != -1) {
        // Find UTF-16 character or surrogate pair
        result.write(_getCharFromMap(lowerMap, lowerIdx));
        continue;
      }
      int upperIdx = _normalUpper.indexOf(char);
      if (upperIdx != -1) {
        result.write(_getCharFromMap(upperMap, upperIdx));
        continue;
      }
      int digitIdx = _normalDigits.indexOf(char);
      if (digitIdx != -1 && digitMap.isNotEmpty) {
        result.write(_getCharFromMap(digitMap, digitIdx));
        continue;
      }
      result.write(char);
    }
    return result.toString();
  }

  // Support surrogate pairs in Unicode maps
  static String _getCharFromMap(String map, int index) {
    List<String> chars = [];
    int i = 0;
    while (i < map.length) {
      int charCode = map.codeUnitAt(i);
      if (charCode >= 0xD800 && charCode <= 0xDBFF && i + 1 < map.length) {
        chars.add(map.substring(i, i + 2));
        i += 2;
      } else {
        chars.add(map.substring(i, i + 1));
        i++;
      }
    }
    if (index >= 0 && index < chars.length) {
      return chars[index];
    }
    return '';
  }

  static List<FontStyleModel> get fontStyles => [
        FontStyleModel(
          name: 'Gothic Bold',
          identifier: 'gothic_bold',
          sample: '𝕾𝖆𝖎 𝕶𝖚𝖒𝖆𝖗',
          transform: (text) => _transformText(
            text,
            '𝖆𝖇𝖈𝖉𝖊𝖋𝖌𝖍𝖎𝖏𝖐𝖑𝖒𝖓𝖔𝖕𝖖𝖗𝖘𝖙𝖚𝖛𝖜𝖝𝖞𝖟',
            '𝕬𝕭𝕮𝕯𝕰𝕱𝕲𝕳𝕴𝕵𝕶𝕷𝕸𝕹𝕺𝕻𝕼𝕽𝕾𝕿𝖀𝖁𝖂𝖃𝖄𝖅',
            '𝟘𝟙𝟚𝟛𝟜𝟝𝟞𝟟𝟠𝟡',
          ),
        ),
        FontStyleModel(
          name: 'Script Elegant',
          identifier: 'script_elegant',
          sample: '𝒮𝒶𝒾 𝒦𝓊𝓂𝒶𝓇',
          transform: (text) => _transformText(
            text,
            '𝒶𝒷𝒸𝒹𝒻𝑔𝒽𝒾𝒿𝓀𝓁𝓂𝓃ℴ𝓅𝓆𝓇𝓈𝓉𝓊𝓋𝓌𝓍𝓎𝓏', // note: e -> ℯ, o -> ℴ, g -> 𝑔 etc
            '𝒜ℬ𝒞𝒟ℰℱ𝒢ℋℐ𝒥𝒦ℒℳ𝒩𝒪𝒫𝒬ℛ𝒮𝒯𝒰𝒱𝒲𝒳𝒴𝒵',
            '0123456789',
          ),
        ),
        FontStyleModel(
          name: 'Double Struck (Outline)',
          identifier: 'double_struck',
          sample: '𝕊𝕒𝕚 𝕂𝕦𝕞𝕒𝕣',
          transform: (text) => _transformText(
            text,
            '𝕒𝕓𝕔𝕕𝕖𝕗𝕘𝕙𝕚𝕛𝕜𝕝𝕞𝕟𝕠𝕡𝕦𝕣𝕤𝕥𝕦𝕧𝕨𝕩𝕪𝕫',
            '𝔸𝔹ℂ𝔻𝔼𝔽𝔾ℍ𝕀𝕁𝕂𝕃𝕄ℕ𝕆ℙℚℝ𝕊𝕋𝕌𝕍𝕎𝕏𝕐ℤ',
            '𝟘𝟙𝟚𝟛𝟜𝟝𝟞𝟟𝟠𝟡',
          ),
        ),
        FontStyleModel(
          name: 'Mathematical Bold',
          identifier: 'math_bold',
          sample: '𝐒𝐚𝐢 𝐊𝐮𝐦𝐚𝐫',
          transform: (text) => _transformText(
            text,
            '𝐚𝐛𝐜𝐝𝐞𝐟𝐠𝐡𝐢𝐣𝐤𝐥𝐦𝐧𝐨𝐩𝐪𝐫𝐬𝐭𝐮𝐯𝐰𝐱𝐲𝐳',
            '𝐀𝐁𝐂𝐃𝐄𝐅𝐆𝐇𝐈𝐉𝐊𝐋𝐌𝐍𝐎𝐏𝐐𝐑𝐒𝐓𝐔𝐕𝐖𝐗𝐘𝐙',
            '𝟎𝟏𝟐𝟑𝟒𝟓𝟔𝟕𝟖𝟗',
          ),
        ),
        FontStyleModel(
          name: 'Bubbles (Circled)',
          identifier: 'circled',
          sample: 'Ⓢⓐⓘ Ⓚⓤⓜⓐⓡ',
          transform: (text) => _transformText(
            text,
            'ⓐⓑⓒⓓⓔⓕⓖⓗⓘⓙⓚⓛⓜⓝⓞⓟⓠⓡⓢⓣⓤⓥⓦⓧⓨⓩ',
            'ⒶⒷⒸⒹⒺⒻcontents_will_be_updated_later_for_others',
            '⓪①②③④⑤⑥⑦⑧⑨',
          ).replaceAll('ⒶⒷⒸⒹⒺⒻcontents_will_be_updated_later_for_others', ''), // Actually let's map letters individually
        ),
      ];

  // More robust mapping including Circled, Squares, Gothic, Tiny Caps etc.
  static List<FontStyleModel> get allFonts {
    return [
      FontStyleModel(
        name: 'Gothic Bold',
        identifier: 'gothic_bold',
        sample: '𝕾𝖆𝖎 𝕶𝖚𝖒𝖆𝖗',
        transform: (text) => _transformText(text, 
          '𝖆𝖇𝖈𝖉𝖊𝖋𝖌𝖍𝖎𝖏𝖐𝖑𝖒𝖓𝖔𝖕𝖖𝖗𝖘𝖙𝖚𝖛𝖜𝖝𝖞𝖟', 
          '𝕬𝕭𝕮𝕯𝕰𝕱𝕲𝕳𝕴𝕵𝕶𝕷𝕸𝕹𝕺𝕻𝕼𝕽𝕾𝕿𝖀𝖁𝖂𝖃𝖄𝖅', 
          '𝟘𝟙𝟚𝟛𝟜𝟝𝟞𝟟𝟠𝟡'
        ),
      ),
      FontStyleModel(
        name: 'Gothic Light',
        identifier: 'gothic_light',
        sample: '𝔖𝔞𝔦 𝔎𝔲𝔪𝔞𝔯',
        transform: (text) => _transformText(text, 
          '𝔞𝔟𝔠𝔡𝔢𝔣𝔤𝔥𝔦𝔧𝔨𝔩𝔪𝔫𝔬𝔭𝔮𝔯𝔰𝔱𝔲𝔳𝔴𝔵𝔶𝔷', 
          '𝔄𝔅ℭ𝔇𝔈𝔉𝔊ℋℑ𝔍𝔎𝔏𝔐𝔑𝔒𝔓𝔔ℜ𝔖𝔗𝔘𝔙𝔚𝔛𝔜ℨ', 
          '0123456789'
        ),
      ),
      FontStyleModel(
        name: 'Script Elegant',
        identifier: 'script_elegant',
        sample: '𝒮𝒶𝒾 𝒦𝓊𝓂𝒶𝓇',
        transform: (text) => _transformText(text, 
          '𝒶𝒷𝒸𝒹ℯ𝒻𝑔𝒽𝒾𝒿𝓀𝓁𝓂𝓃ℴ𝓅𝓆𝓇𝓈𝓉𝓊𝓋𝓌𝓍𝓎𝓏', 
          '𝒜ℬ𝒞𝒟ℰℱ𝒢ℋℐ𝒥𝒦ℒℳ𝒩𝒪𝒫𝒬ℛ𝒮𝒯𝒰𝒱𝒲𝒳𝒴𝒵', 
          '0123456789'
        ),
      ),
      FontStyleModel(
        name: 'Script Bold',
        identifier: 'script_bold',
        sample: '𝓼𝓪𝓲 𝓴𝓾𝓶𝓪𝓻',
        transform: (text) => _transformText(text, 
          '𝓪𝓫𝓬𝓭𝓮𝓯𝓰𝓱𝓲𝓳𝓴𝓵𝓶𝓷𝓸𝓹𝓺𝓻𝓼𝓽𝓾𝓿𝔀𝔁𝔂𝔃', 
          '𝓐𝓑𝓒𝓓𝓔𝓕𝓖𝓗𝓘𝓙𝓚𝓛𝓜𝓝𝓞𝓟𝓠𝓡𝓢𝓣𝓤𝓥𝓦𝓳𝓨𝓩', 
          '0123456789'
        ),
      ),
      FontStyleModel(
        name: 'Double Struck',
        identifier: 'double_struck',
        sample: '𝕊𝕒𝕚 𝕂𝕦𝕞𝕒𝕣',
        transform: (text) => _transformText(text, 
          '𝕒𝕓𝕔𝕕𝕖𝕗𝕘𝕙𝕚𝕛𝕜𝕝𝕞𝕟𝕠𝕡𝕢𝕣𝕤𝕥𝕦𝕧𝕨𝕩𝕪𝕫', 
          '𝔸𝔹ℂ𝔻𝔼𝔽𝔾ℍ𝕀𝕁𝕂𝕃𝕄ℕ𝕆ℙℚℝ𝕊𝕋𝕌𝕍𝕎𝕏𝕐ℤ', 
          '𝟘𝟙𝟚𝟛𝟜𝟝𝟞𝟟𝟠𝟡'
        ),
      ),
      FontStyleModel(
        name: 'Bold Sans',
        identifier: 'bold_sans',
        sample: '𝗦𝗮𝗶 𝗞𝘂𝗺𝗮𝗿',
        transform: (text) => _transformText(text, 
          '𝗮𝗯𝗰𝗱𝗲𝗳𝗴𝗵𝗶𝗷𝗸𝗹𝗺𝗻𝗼𝗽𝗾𝗿𝘀𝘁𝘂𝘃𝘄𝘅𝘆𝘇', 
          '𝗔𝗕𝗖𝗗𝗘𝗙𝗚𝗛𝗜𝗝𝗞𝗟𝗠𝗡𝗢𝗣𝗤𝗥𝗦𝗧𝗨𝗩𝗪𝗫𝗬𝗭', 
          '𝟬𝟭𝟮𝟯𝟰𝟱𝟲𝟳𝟴𝟵'
        ),
      ),
      FontStyleModel(
        name: 'Italic Sans',
        identifier: 'italic_sans',
        sample: '𝘚𝘢𝘪 𝘒𝘶𝘮𝘢𝘳',
        transform: (text) => _transformText(text, 
          '𝘢𝘣𝘤𝘥𝘦𝘧𝘨𝘩𝘪𝘫𝘬𝘭𝘮𝘯𝘰𝘱𝘲𝘳𝘴𝘵𝘶𝘷𝘸𝘹𝘺𝘻', 
          '𝘈𝘉𝘊𝘋𝘌𝘍𝘎𝘏𝘐𝘑𝘒𝘓𝘔𝘕𝘖𝘗𝘘𝘙𝘚𝘛𝘜𝘝𝘞𝘟𝘠𝘡', 
          '0123456789'
        ),
      ),
      FontStyleModel(
        name: 'Bold Italic Sans',
        identifier: 'bold_italic_sans',
        sample: '𝙎𝙖𝙞 𝙆𝙪𝙢𝙖𝙧',
        transform: (text) => _transformText(text, 
          '𝙖𝙗𝙘𝙙𝙚𝙯𝙜𝙝𝙞𝙟𝙠𝙡𝙢𝙣𝙤𝙥𝙦𝙧𝙨𝙩𝙪𝙫𝙬𝙭𝙮𝙟', 
          '𝘼𝘽𝘾𝘿𝙀𝙁𝙂𝙃𝙄𝙅𝙆𝙇𝙈𝙉𝙊𝙋𝙌𝙍𝙎𝙏𝙐𝙑𝙒𝙓𝙔𝙕', 
          '0123456789'
        ),
      ),
      FontStyleModel(
        name: 'Circled Letters',
        identifier: 'circled_letters',
        sample: 'Ⓢⓐⓘ Ⓚⓤⓜⓐⓡ',
        transform: (text) => _transformText(text, 
          'ⓐⓑⓒⓓⓔⓕⓖⓗⓘⓙⓚⓛⓜⓝⓞⓟⓠⓡⓢⓣⓤⓥⓦⓧⓨⓩ', 
          'ⒶⒷⒸⒹⒺⒻⒼⒽⒾⒿⓀⓁⓂⓃⓄⓅⓆⓇⓈⓉⓊⓋⓌⓍⓎⓏ', 
          '⓪①②③④⑤⑥⑦⑧⑨'
        ),
      ),
      FontStyleModel(
        name: 'Square Letters',
        identifier: 'square_letters',
        sample: '🅂🄰🄸 🄺🅄🄼🄰🅁',
        transform: (text) => _transformText(text, 
          '🄰🄱🄲🄳🄴🄵🄶🄷🄸🄹🄺🄻🄼🄽🄾🄿🅀🅁🅂🅃🅄🅅🅆🅇🅈🅉', 
          '🄰🄱🄲🄳🄴🄵🄶🄷🄸🄹🄺🄻🄼🄽🄾🄿🅀🅁🅂🅃🅄🅅🅆🅇🅈🅉', 
          '0123456789'
        ),
      ),
      FontStyleModel(
        name: 'Small Caps',
        identifier: 'small_caps',
        sample: 'ꜱᴀɪ ᴋᴜᴍᴀʀ',
        transform: (text) => _transformText(text, 
          'ᴀʙᴄᴅᴇꜰɢʜɪᴊᴋʟᴍɴᴏᴩqʀꜱᴛᴜᴠᴡxʏᴢ', 
          'ᴀʙᴄᴅᴇꜰɢʜɪᴊᴋʟᴍɴᴏᴩqʀꜱᴛᴜᴠᴡxʏᴢ', 
          '0123456789'
        ),
      ),
      FontStyleModel(
        name: 'Wide Fullwidth',
        identifier: 'wide_fullwidth',
        sample: 'Ｓａｉ　Ｋｕｍａｒ',
        transform: (text) => _transformText(text, 
          'ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ', 
          'ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ', 
          '０１２３４５６７８９'
        ),
      ),
      FontStyleModel(
        name: 'Mirror / Flip',
        identifier: 'mirror',
        sample: 'ƨɒi ʞumɒɿ',
        transform: (text) {
          // Reverse and map
          String reversed = text.split('').reversed.join('');
          return _transformText(reversed, 
            'ɒdɔbɘᎸgʜiꞁʞlmnoqpɿꙅʇuvwxγz', 
            'AʚƆᗞƎℲGHIႱꓘ⅃MᴎOԀQЯƧTUVWXYZ', 
            '0123456789'
          );
        },
      ),
    ];
  }
}
