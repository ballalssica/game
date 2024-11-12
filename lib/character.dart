import 'dart:math';

import 'package:prg_game/monster.dart';

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