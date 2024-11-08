import 'package:game/game.dart';
import 'package:game/character.dart';
import 'package:game/monster.dart';
import 'dart:io';

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
