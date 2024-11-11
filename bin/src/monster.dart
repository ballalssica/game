import 'dart:math';

class Monster {
  String name;
  int hp;
  int power;
  int defense;

  Monster(this.name, this.hp, this.power, this.defense);

  // 공격 메서드
  void attackCharacter(Character character) {
    int damage = Random().nextInt(20) + 1;
    if (damage < character.defense) {
      damage = character.defense; // 최소 데미지는 캐릭터 방어력 이상
    }
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