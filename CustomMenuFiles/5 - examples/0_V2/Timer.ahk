#SingleInstance Off
Persistent true
#Include <Tools\Timer>
#Include <Text>
#Include <Paths>

Timer(ReadFile(Paths.Ptf["Timer.txt"]),, true)