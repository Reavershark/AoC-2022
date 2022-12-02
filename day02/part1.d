import std;

@safe:

enum Choice : int
{
    Rock = 1,
    Paper = 2,
    Scissors = 3
}

Choice charToChoice(in char c) pure
{
    final switch (c)
    {
    case 'A', 'X':
        return Choice.Rock;
    case 'B', 'Y':
        return Choice.Paper;
    case 'C', 'Z':
        return Choice.Scissors;
    }
}

Choice choiceThatWinsFrom(in Choice other) pure
{
    return cast(Choice)((other % 3) + 1); // each choice beats the previous one in the row, so return the next one
}

struct Round
{
    Choice player;
    Choice opponent;

    int score() const
    {
        int playerShapeScore = cast(int) player;

        int roundOutcome = 0;
        if (player == opponent) // draw
            roundOutcome = 3;
        else if (player == choiceThatWinsFrom(opponent))
            roundOutcome = 6;

        return playerShapeScore + roundOutcome;
    }

    static Round fromString(string s)
    {
        char playerChar, opponentChar;
        auto readCount = s.formattedRead!"%c %c"(opponentChar, playerChar); // they are in reverse order!
        enforce(readCount == 2);

        return Round(playerChar.charToChoice, opponentChar.charToChoice);
    }
}

void main() @system
{
    stdin.byLine
        .map!(roundLine => Round.fromString(cast(string) roundLine))
        .map!(round => round.score)
        .sum
        .writeln;
}
