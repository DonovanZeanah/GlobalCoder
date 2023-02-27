Class Character {
levelUp() {
Enemy.level++
}
}
Class Enemy {
static level := 10
hp := 100
onDamage() {
this.hp--
}
}