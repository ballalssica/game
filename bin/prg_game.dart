import 'dart:io';
import 'dart:math';

// 캐릭터 클래스
class Character {
  String name; // 이름
  int hp; // 체력
  int power; // 공격력
  int defense; // 방어력

  Character(this.name, this.hp, this.power, this.defense);

  // 공격 메서드 (몬스터의 체력을 캐릭터의 공격력만큼 감소시킴)
  void attackMonster(Monster monster) {
    monster.hp -= this.power;
    print('${monster.name}에게 ${this.power}의 피해를 입혔습니다.');
  }

  // 방어 메서드 (몬스터가 입힌 데미지만큼 체력을 상승시킴)
  void defend() {
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


// 몬스터 클래스
class Monster {
  String name; // 이름
  int hp; // 체력
  int power; // 공격력 랜덤,단 몬스터의 공격력은 캐릭터의 방어력보다 작을 수 없음
  int defense = 0; // 방어력 = 0

  Monster(this.name, this.hp, this.power, this.defense);

  // 공격 메서드
  void attackCharacter(Character character) {
    int damage = Random().nextInt(20) + 1;
    damage = max(damage, character.defense); // 렌덤값과 캐릭터 방어력 중 큰 값 적용
    character.hp -= damage;
    print('${character.name}에게 $damage의 피해를 입혔습니다.');
  }

  // 상태를 출력하는 메서드 (매턴마다 출력)
  void showStatus() {
    print('현재 체력: ${this.hp}');
    print('현재 공격력: ${this.power}');
    print('현재 방어력: ${this.defense}');
  }
}


// 게임 클래스
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

  // 전투를 진행하는 메서드
  Future<void> battle() async {
    await Future.delayed(Duration(seconds: 1));
    Monster currentMonster = getRandomMonster();
    print('-' * 30);
    print('새로운 몬스터가 나타났습니다!');
    await Future.delayed(Duration(seconds: 1));
    print('-' * 30);
    print(
        '${currentMonster.name} - 체력: ${currentMonster.hp}, 공격력: ${currentMonster.power}');

    // 캐릭터와 몬스터가 살아있는 동안 반복
    await Future.delayed(Duration(seconds: 1));
    while (currentMonster.hp > 0 && character.hp > 0) {
      print('행동을 선택하세요. (1: 공격, 2: 방어)');
      String? action = stdin.readLineSync();
      int actionNumber = int.tryParse(action ?? '') ?? 0;

      await Future.delayed(Duration(seconds: 1));
      switch (actionNumber) {
        case 1:
          print("공격을 선택하셨습니다!");
          character.attackMonster(currentMonster); // 캐릭터가 몬스터 공격
          break;
        case 2:
          print("방어를 선택하셨습니다!"); // 캐릭터가 방어
          character.defend();
          break;
        default:
          print("잘못된 입력입니다. 1 또는 2를 입력하세요.");
          continue;
      }

      // 캐릭터와 몬스터 상태 출력
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

      // 몬스터의 공격
      await Future.delayed(Duration(seconds: 3));
      print('${currentMonster.name}의 공격!');
      currentMonster.attackCharacter(character);
      print('*' * 30);
    }
  }

  // 게임을 시작하는 메서드
  Future<void> startGame() async {
    while (this.character.hp > 0 && monsters.isNotEmpty) {
      await battle();
      if (character.hp > 0 && monsters.isNotEmpty) {
        print('다음 몬스터와 대결하시겠습니까? (y/n)');
        String? nextBattle = stdin.readLineSync();
        if (nextBattle == 'n') {
          break;
        }
      }
    }

    // 게임 승리 및 패배 여부를 출력
    if (monsters.isEmpty){
      print('모든 몬스터를 물리치고 승리하였습니다.');
    } else if (this.character.hp <= 0 ){
      print('게임에서 패배하였습니다.');
    } else {
      print('게임이 종료되었습니다');
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

  // 유효한 이름이 입력되었을 때 출력
  print('캐릭터의 이름은 $characterName 입니다. 게임을 시작합니다!');

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

  // 게임 시작
 Game game = Game(character, monsters);
  await game.startGame();
}