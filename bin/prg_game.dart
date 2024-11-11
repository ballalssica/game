import 'dart:io';
import 'dart:math';

class Character {
  String name;
  int hp;
  int power;
  int defense;

  Character(this.name, this.hp, this.power, this.defense);

  // 공격 메서드
  void attackMonster(Monster monster) {
    monster.hp -= this.power;
  }

  // 방어 메서드
  void defend() {
    this.hp += this.defense;
    int monsterDamage = Random().nextInt(10) + 1;
    this.hp += monsterDamage;
  }

  // 상태를 출력하는 메서드 (매턴마다 출력)
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
  int defense; // 몬스터의 방어력은 0이라고 가정합니다.

  Monster(this.name, this.hp, this.power, this.defense);

  // 공격 메서드
  void attackCharacter(Character character) {
    int damage = Random().nextInt(20) + 1;
    if (damage < character.defense) {
      damage = character.defense;
    }
    character.hp -= damage;
  }

  // 상태를 출력하는 메서드 (매턴마다 출력)
  void showStatus() {
    print('현재 체력: ${this.hp}');
    print('현재 공격력: ${this.power}');
  }
}

class Game {
  Character character;
  List<Monster> monsters;
  int defeatedMonsterCount = 0;

  Game(this.character, this.monsters);

  // 랜덤으로 몬스터를 불러오는 메서드
  Monster getRandomMonster() {
    int randomIndex = Random().nextInt(this.monsters.length);
    return this.monsters[randomIndex];
  }

  // 게임을 시작하는 메서드
  void startGame() {
    while (this.character.hp > 0) {
      battle();
      if (this.character.hp <= 0) {
        print('게임이 종료되었습니다.');
        break;
      }
      print('다음 몬스터와 대결하시겠습니까? (y/n)');
      String? answer = stdin.readLineSync();
      if (answer == 'n') {
        break;
      }
    }
    if (this.defeatedMonsterCount == this.monsters.length) {
      print('게임에서 승리하였습니다.');
    }
  }

  // 전투를 진행하는 메서드
  void battle() {
    Monster currentMonster = getRandomMonster();
    print('새로운 몬스터가 나타났습니다!');
    currentMonster.showStatus();

    while (currentMonster.hp > 0) {
      print('${character.name}의 턴');
      print('행동을 선택하세요. (1: 공격, 2: 방어)');
      String? action = stdin.readLineSync();
      int actionNumber = int.tryParse(action ?? '') ?? 0;

      if (actionNumber == 1) {
        character.attackMonster(currentMonster);
        print("공격을 선택하셨습니다!");
      } else if (actionNumber == 2) {
        character.defend();
        print("방어를 선택하셨습니다!");
      } else {
        print("잘못된 입력입니다. 1 또는 2를 입력하세요.");
        continue;
      }

      currentMonster.attackCharacter(character);
      character.showStatus();
      currentMonster.showStatus();

      if (character.hp <= 0) {
        print("캐릭터가 패배했습니다.");
        break;
      }
      if (currentMonster.hp <= 0) {
        print("${currentMonster.name}을 물리쳤습니다!");
        this.defeatedMonsterCount++;
        this.monsters.remove(currentMonster);
        break;
      }
    }
  }
}

void main() async {
  // 캐릭터 이름 입력받기
  print('캐릭터의 이름을 입력해주세요.');
  String? characterName = stdin.readLineSync();

  // 유효한 이름이 입력될 때까지 반복
  while (characterName == null || characterName.isEmpty) {
    print('캐릭터 이름이 입력되지 않았습니다. 다시 입력해주세요.');
    characterName = stdin.readLineSync();
  }

  print('''
  캐릭터의 이름은 $characterName 입니다.
  게임을 시작합니다!'''
      .trim());

  // 캐릭터 객체 생성
  await Future.delayed(Duration(seconds: 1));
  Character character = Character(characterName, 50, 10, 5);
  print(
      '${character.name} - 체력: ${character.hp}, 공격력: ${character.power}, 방어력: ${character.defense}');

  // 몬스터 객체 생성
  List<Monster> monsters = [
    Monster('슬라임', 20, 5, 0),
    Monster('스파이더', 25, 6, 0),
    Monster('스켈레톤', 30, 8, 0),
    Monster('마왕', 50, 15, 0),
  ];

  Game game = Game(character, monsters);
  game.startGame(); // 게임 시작
}
