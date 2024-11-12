import 'dart:io';
import 'dart:math';

class Character {
  String name; // 이름
  int hp; // 체력
  int power; // 공격력
  int defense; // 방어력

  Character(this.name, this.hp, this.power, this.defense);

  void attackMonster(Monster monster) {
    monster.hp -= this.power;
    print('${monster.name}에게 ${this.power}의 피해를 입혔습니다.');
  }

  void defend() {
    int monsterDamage = Random().nextInt(10) + 1;
    this.hp += monsterDamage;
  }

  void showStatus() {
    print('현재 체력: ${this.hp}');
    print('현재 공격력: ${this.power}');
    print('현재 방어력: ${this.defense}');
  }
}

class Monster {
  String name;
  int hp;
  int power;
  int defense = 0;

  Monster(this.name, this.hp, this.power, this.defense);

  void attackCharacter(Character character) {
    int damage = Random().nextInt(20) + 1;
    damage = max(damage, character.defense);
    character.hp -= damage;
    print('${character.name}에게 $damage의 피해를 입혔습니다.');
  }

  void showStatus() {
    print('현재 체력: ${this.hp}');
    print('현재 공격력: ${this.power}');
    print('현재 방어력: ${this.defense}');
  }
}

class Game {
  Character character;
  List<Monster> monsters;
  int defeatedMonsterCount = 0;

  Game(this.character, this.monsters);

  // 몬스터를 렌덤으로 뽑는 메서드
  Monster getRandomMonster() {
    int randomIndex = Random().nextInt(this.monsters.length);
    return this.monsters[randomIndex];
  }

  
  Future<void> battle() async {
    await Future.delayed(Duration(seconds: 1));
    Monster currentMonster = getRandomMonster();
    print('-' * 30);
    print('새로운 몬스터가 나타났습니다!');
    await Future.delayed(Duration(seconds: 1));
    print('-' * 30);
    print('${currentMonster.name} - 체력: ${currentMonster.hp}, 공격력: ${currentMonster.power}');

    await Future.delayed(Duration(seconds: 1));
    while (currentMonster.hp > 0 && character.hp > 0) {
      print('행동을 선택하세요. (1: 공격, 2: 방어)');
      String? action = stdin.readLineSync();
      int actionNumber = int.tryParse(action ?? '') ?? 0;

      await Future.delayed(Duration(seconds: 1));
      switch (actionNumber) {
        case 1:
          print("공격을 선택하셨습니다!");
          character.attackMonster(currentMonster);
          break;
        case 2:
          print("방어를 선택하셨습니다!");
          character.defend();
          break;
        default:
          print("잘못된 입력입니다. 1 또는 2를 입력하세요.");
          continue;
      }

      print('*' * 30);
      print('<${character.name}>');
      character.showStatus();
      print('');
      print('<${currentMonster.name}>');
      currentMonster.showStatus();
      print('*' * 30);

      if (character.hp <= 0) {
        print('${character.name}님이 패배하였습니다.');
        break;
      } else if (currentMonster.hp <= 0) {
        print('${currentMonster.name}을 물리쳤습니다!');
        defeatedMonsterCount++;
        monsters.remove(currentMonster);
        break;
      }

      await Future.delayed(Duration(seconds: 3));
      print('${currentMonster.name}의 공격!');
      currentMonster.attackCharacter(character);
      print('*' * 30);
    }
  }

  Future<void> startGame() async {
    while (character.hp > 0 && monsters.isNotEmpty) {
      await battle();
      if (character.hp > 0 && monsters.isNotEmpty) {
        print('다음 몬스터와 대결하시겠습니까? (y/n)');
        String? nextBattle = stdin.readLineSync();
        if (nextBattle == 'n') {
          break;
        }
      }
    }

    bool gameWon = monsters.isEmpty && character.hp > 0;

    if (gameWon) {
      print('모든 몬스터를 물리치고 승리하였습니다.');
    } else if (character.hp <= 0) {
      print('게임에서 패배하였습니다.');
    } else {
      print('게임이 종료되었습니다');
    }

    await saveGameResult(gameWon);
  }
  
  // 게임결과 저장하기
  Future<void> saveGameResult(bool gameWon) async {
    print('결과를 저장하시겠습니까? (y/n)');
    String? response = stdin.readLineSync();

    if (response?.toLowerCase() == 'y') {
      String result = gameWon ? '승리' : '패배';
      String content =
          '캐릭터 이름: ${character.name}\n남은 체력: ${character.hp}\n게임 결과: $result\n';

      File('result.txt').writeAsStringSync(content);
      print('게임 결과가 result.txt 파일에 저장되었습니다.');
    } else {
      print('게임 결과가 저장되지 않았습니다.');
    }
  }
}

// 캐릭터파일 불러오기
Future<Character> loadCharacterFromFile(String name, String filePath) async {
  List<String> lines = await File(filePath).readAsLines();
  int hp = int.parse(lines[0]);
  int power = int.parse(lines[1]);
  int defense = int.parse(lines[2]);

  return Character(name, hp, power, defense);
}

// 몬스터 파일 불러오기
Future<List<Monster>> loadMonstersFromFile(String filePath) async {
  List<String> lines = await File(filePath).readAsLines();
  List<Monster> monsters = [];

  for (String line in lines) {
    List<String> parts = line.split(',');

    String name = parts[0];
    int hp = int.parse(parts[1]);
    int power = int.parse(parts[2]);
    int defense = int.parse(parts[3]);

    monsters.add(Monster(name, hp, power, defense));
  }

  return monsters;
}

void main() async {
  print('캐릭터의 이름을 입력해주세요.');
  String? characterName = stdin.readLineSync();

  while (characterName == null || characterName.isEmpty || !RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(characterName)) {
    print('잘못된 이름입니다. 다시 입력해주세요.');
    characterName = stdin.readLineSync();
  }

  print('캐릭터의 이름은 $characterName 입니다. 게임을 시작합니다!');
  Character character = await loadCharacterFromFile(characterName, 'characters.txt');
  print('${character.name} - 체력: ${character.hp}, 공격력: ${character.power}, 방어력: ${character.defense}');

  List<Monster> monsters = await loadMonstersFromFile('monsters.txt');
  Game game = Game(character, monsters);
  await game.startGame();
}
